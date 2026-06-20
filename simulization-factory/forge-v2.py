#!/usr/bin/env python3
"""Forge Console v2 — Built layer by layer. Ping works. Now add reads."""
import http.server
import json
import subprocess
import os
from pathlib import Path

IMAGE_DIR = "/tmp"

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/ping':
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'FORGE_OK\n')
        
        elif self.path == '/api/images':
            images = []
            for ext in [".img", ".img.xz", ".img.gz"]:
                for f in Path(IMAGE_DIR).glob(f"*{ext}"):
                    size = f.stat().st_size
                    images.append({
                        "name": f.name,
                        "path": str(f),
                        "size": size,
                        "size_human": self._format_size(size)
                    })
            images.sort(key=lambda x: x["name"])
            self._send_json(images)
        
        elif self.path == '/api/drives':
            drives = []
            try:
                result = subprocess.run(
                    ["lsblk", "-J", "-o", "NAME,SIZE,TYPE,MOUNTPOINT,MODEL,RM,HOTPLUG"],
                    capture_output=True, text=True, timeout=10
                )
                data = json.loads(result.stdout)
                for device in data.get("blockdevices", []):
                    if device.get("type") == "disk" and device.get("rm"):
                        drive = {
                            "name": device["name"],
                            "path": f"/dev/{device['name']}",
                            "size": device.get("size", "?"),
                            "model": (device.get("model") or "Unknown").strip(),
                            "mounted": [],
                            "dangerous": False,
                            "dangerous_reason": ""
                        }
                        # Check if it's the root device
                        try:
                            root = subprocess.run(
                                ["findmnt", "-n", "-o", "SOURCE", "/"],
                                capture_output=True, text=True
                            ).stdout.strip()
                            if drive["path"] in root or root in drive["path"]:
                                drive["dangerous"] = True
                                drive["dangerous_reason"] = "Root filesystem"
                        except:
                            pass
                        # Check mounted partitions
                        for child in device.get("children", []):
                            mount = child.get("mountpoint")
                            if mount:
                                drive["mounted"].append(mount)
                                drive["dangerous"] = True
                                drive["dangerous_reason"] = f"Mounted: {mount}"
                        drives.append(drive)
            except Exception as e:
                self._send_json({"error": str(e)}, 500)
                return
            self._send_json(drives)
        
        elif self.path == '/api/status':
            self._send_json({
                "status": "ok",
                "images": len(list(Path(IMAGE_DIR).glob("*.img*"))),
                "port": 8081
            })
        
        elif self.path == '/api/logs':
            try:
                with open("/home/pi/logs/forge/forge.log", "r") as f:
                    logs = f.read()
            except:
                logs = "No logs yet."
            self._send_json({"logs": logs})
        
        elif self.path == '/':
            # Serve the UI
            html_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "forge-ui.html")
            try:
                with open(html_path, "r") as f:
                    html = f.read()
                self.send_response(200)
                self.send_header('Content-Type', 'text/html')
                self.end_headers()
                self.wfile.write(html.encode())
            except:
                self._send_json({"error": "UI not found"}, 500)
        
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'NOT_FOUND\n')
    
    def do_POST(self):
        if self.path == '/api/flash':
            # Read body
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length)
            try:
                data = json.loads(body)
            except:
                self._send_json({"success": False, "message": "Invalid JSON"}, 400)
                return
            
            image_path = data.get("image", "")
            target = data.get("target", "")
            confirm = data.get("confirm", "")
            
            # Validate
            if not image_path or not target:
                self._send_json({"success": False, "message": "Missing image or target"}, 400)
                return
            
            if confirm != f"FLASH {target}":
                self._send_json({"success": False, "message": "Confirmation mismatch"}, 400)
                return
            
            if not os.path.exists(image_path):
                self._send_json({"success": False, "message": f"Image not found: {image_path}"}, 404)
                return
            
            # Check dangerous
            try:
                root = subprocess.run(
                    ["findmnt", "-n", "-o", "SOURCE", "/"],
                    capture_output=True, text=True
                ).stdout.strip()
                if target in root or root in target:
                    self._send_json({"success": False, "message": "Cannot flash root filesystem"}, 403)
                    return
            except:
                pass
            
            # Log and execute
            os.makedirs("/home/pi/logs/forge", exist_ok=True)
            log_f = open("/home/pi/logs/forge/forge.log", "a")
            log_f.write(f"[{self._now()}] FLASH_START: {image_path} -> {target}\n")
            log_f.flush()
            
            # Unmount target partitions
            try:
                lsblk_out = subprocess.run(
                    ["lsblk", "-n", "-o", "MOUNTPOINT", target],
                    capture_output=True, text=True
                ).stdout.strip()
                for mount in lsblk_out.split("\n"):
                    if mount:
                        subprocess.run(["sudo", "umount", mount], capture_output=True)
                        log_f.write(f"[{self._now()}] Unmounted {mount}\n")
                        log_f.flush()
            except:
                pass
            
            # Execute dd with progress
            import threading
            def do_flash():
                try:
                    cmd = f"sudo dd if={image_path} of={target} bs=4M status=progress conv=fsync"
                    log_f.write(f"[{self._now()}] CMD: {cmd}\n")
                    log_f.flush()
                    proc = subprocess.Popen(
                        cmd.split(),
                        stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT,
                        text=True
                    )
                    for line in proc.stdout:
                        log_f.write(f"[{self._now()}] dd: {line.strip()}\n")
                        log_f.flush()
                    proc.wait()
                    if proc.returncode == 0:
                        log_f.write(f"[{self._now()}] FLASH_SUCCESS: {target}\n")
                    else:
                        log_f.write(f"[{self._now()}] FLASH_FAILED: exit {proc.returncode}\n")
                except Exception as e:
                    log_f.write(f"[{self._now()}] FLASH_ERROR: {e}\n")
                finally:
                    log_f.close()
            
            thread = threading.Thread(target=do_flash, daemon=True)
            thread.start()
            
            self._send_json({
                "success": True,
                "message": f"Flashing {os.path.basename(image_path)} to {target}. Check logs for progress."
            })
        
        else:
            self.send_response(404)
            self.end_headers()
    
    def _send_json(self, data, status=200):
        body = json.dumps(data, default=str).encode()
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    
    def _format_size(self, size):
        for unit in ["B", "KB", "MB", "GB", "TB"]:
            if size < 1024:
                return f"{size:.1f} {unit}"
            size /= 1024
        return f"{size:.1f} PB"
    
    def _now(self):
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    # Kill anything on port 8081 first
    os.system("fuser -k 8081/tcp 2>/dev/null")
    import time
    time.sleep(1)
    
    server = http.server.HTTPServer(('0.0.0.0', 8081), Handler)
    print('Forge Console v2 on port 8081', flush=True)
    server.serve_forever()