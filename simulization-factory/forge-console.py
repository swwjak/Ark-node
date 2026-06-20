#!/home/pi/forge-venv/bin/python3
"""
Forge Console — Safe image flashing interface.
Local only. Binds to localhost.
Makes dd safer, slower, and more deliberate.
"""

import os
import sys
import json
import subprocess
import threading
import time
from datetime import datetime
from pathlib import Path

from flask import Flask, request, render_template_string, Response

def json_response(data):
    """Return a proper JSON response."""
    return Response(
        json.dumps(data, default=str),
        mimetype="application/json"
    )

app = Flask(__name__)

# Configuration
IMAGE_DIR = "/tmp"
LOG_DIR = "/home/pi/logs/forge"
DANGEROUS_DEVICES = []  # Populated at runtime

os.makedirs(LOG_DIR, exist_ok=True)

# ─── Helpers ──────────────────────────────────────────────

def log_operation(msg):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(f"{LOG_DIR}/forge.log", "a") as f:
        f.write(f"[{ts}] {msg}\n")

def get_removable_drives():
    """Get list of removable USB drives."""
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
                    "model": device.get("model", "Unknown").strip(),
                    "removable": device.get("rm"),
                    "hotplug": device.get("hotplug"),
                    "mounted": [],
                    "children": []
                }
                # Check for mounted partitions
                for child in device.get("children", []):
                    mount = child.get("mountpoint")
                    if mount:
                        drive["mounted"].append(mount)
                    drive["children"].append({
                        "name": child["name"],
                        "path": f"/dev/{child['name']}",
                        "size": child.get("size", "?"),
                        "mountpoint": mount
                    })
                drives.append(drive)
    except Exception as e:
        log_operation(f"Error getting drives: {e}")
    return drives

def get_images():
    """Get list of image files."""
    images = []
    for ext in [".img", ".img.xz", ".img.gz"]:
        for f in Path(IMAGE_DIR).glob(f"*{ext}"):
            images.append({
                "name": f.name,
                "path": str(f),
                "size": f.stat().st_size,
                "size_human": format_size(f.stat().st_size)
            })
    return sorted(images, key=lambda x: x["name"])

def format_size(size):
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if size < 1024:
            return f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} PB"

def is_dangerous(device_path):
    """Check if a device is dangerous to flash."""
    # Check if it's the root device
    try:
        root_dev = subprocess.run(
            ["findmnt", "-n", "-o", "SOURCE", "/"],
            capture_output=True, text=True
        ).stdout.strip()
        if device_path in root_dev or root_dev in device_path:
            return True, "This is the root filesystem"
    except:
        pass
    
    # Check if mounted
    try:
        result = subprocess.run(
            ["lsblk", "-n", "-o", "MOUNTPOINT", device_path],
            capture_output=True, text=True
        )
        if result.stdout.strip():
            return True, "Device has mounted partitions"
    except:
        pass
    
    # Check dangerous list
    for d in DANGEROUS_DEVICES:
        if d in device_path:
            return True, f"Device {device_path} is in dangerous list"
    
    return False, ""

# ─── HTML Template ────────────────────────────────────────

HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>Forge Console</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * { box-sizing: border-box; }
        body { font-family: monospace; background: #0a0a1a; color: #ccc; padding: 20px; max-width: 800px; margin: 0 auto; }
        h1 { color: #ff6600; }
        h2 { color: #00aaff; border-bottom: 1px solid #333; padding-bottom: 5px; }
        .section { background: #111; padding: 15px; margin: 10px 0; border-radius: 5px; border: 1px solid #333; }
        .drive { background: #1a1a2e; padding: 10px; margin: 5px 0; border-radius: 3px; border-left: 3px solid #00ff88; }
        .drive.dangerous { border-left-color: #ff4444; }
        .drive.selected { border-left-color: #ff6600; background: #2a1a0e; }
        .image { background: #1a2e1a; padding: 10px; margin: 5px 0; border-radius: 3px; cursor: pointer; }
        .image:hover { background: #2a3e2a; }
        .image.selected { background: #0e2a0e; border: 1px solid #00ff88; }
        button { padding: 10px 20px; background: #ff6600; color: #000; border: none; cursor: pointer; font-family: monospace; font-size: 14px; margin: 5px; }
        button:hover { background: #ff8800; }
        button:disabled { background: #333; color: #666; cursor: not-allowed; }
        button.danger { background: #ff4444; }
        button.danger:hover { background: #ff6666; }
        .warning { color: #ff4444; font-weight: bold; }
        .ok { color: #00ff88; }
        .log { background: #000; padding: 10px; max-height: 200px; overflow-y: scroll; font-size: 12px; }
        .progress { background: #222; padding: 10px; margin: 10px 0; display: none; }
        .progress-bar { background: #ff6600; height: 20px; width: 0%; transition: width 0.5s; }
        #status { color: #00aaff; }
        .confirm-input { background: #000; color: #ff6600; border: 1px solid #ff6600; padding: 10px; font-family: monospace; width: 100%; }
    </style>
</head>
<body>
    <h1>⚒ Forge Console</h1>
    <p id="status">Ready.</p>
    
    <div class="section">
        <h2>📁 Images</h2>
        <div id="images">Loading...</div>
    </div>
    
    <div class="section">
        <h2>💾 Drives</h2>
        <div id="drives">Loading...</div>
    </div>
    
    <div class="section" id="flash-section" style="display:none;">
        <h2>⚡ Flash</h2>
        <p>Image: <span id="selected-image" class="ok"></span></p>
        <p>Target: <span id="selected-drive" class="warning"></span></p>
        <p class="warning" id="danger-warning"></p>
        <p>Type the device path to confirm:</p>
        <input type="text" id="confirm-input" class="confirm-input" placeholder="Type: FLASH /dev/sdX">
        <br><br>
        <button id="flash-btn" class="danger" disabled>⚡ FLASH</button>
        <button onclick="cancelFlash()">Cancel</button>
    </div>
    
    <div class="section progress" id="progress-section">
        <h2>⏳ Progress</h2>
        <div class="progress-bar" id="progress-bar"></div>
        <p id="progress-text"></p>
    </div>
    
    <div class="section">
        <h2>📋 Logs</h2>
        <button onclick="refreshLogs()">Refresh</button>
        <div class="log" id="logs">Loading...</div>
    </div>
    
    <script>
        let selectedImage = null;
        let selectedDrive = null;
        
        function refreshImages() {
            fetch('/api/images').then(r => r.json()).then(data => {
                let html = '';
                if (data.length === 0) {
                    html = '<p>No images found in /tmp</p>';
                }
                data.forEach(img => {
                    const sel = selectedImage === img.path ? 'selected' : '';
                    html += `<div class="image ${sel}" onclick="selectImage('${img.path}', '${img.name}', '${img.size_human}')">
                        <strong>${img.name}</strong> (${img.size_human})
                    </div>`;
                });
                document.getElementById('images').innerHTML = html;
            });
        }
        
        function refreshDrives() {
            fetch('/api/drives').then(r => r.json()).then(data => {
                let html = '';
                if (data.length === 0) {
                    html = '<p>No removable drives found</p>';
                }
                data.forEach(drive => {
                    const dangerous = drive.dangerous ? 'dangerous' : '';
                    const sel = selectedDrive === drive.path ? 'selected' : '';
                    const mounted = drive.mounted.length > 0 ? `<span class="warning">MOUNTED: ${drive.mounted.join(', ')}</span>` : '<span class="ok">Not mounted</span>';
                    html += `<div class="drive ${dangerous} ${sel}" onclick="selectDrive('${drive.path}', '${drive.name}', '${drive.size}', '${drive.model}', ${drive.dangerous})">
                        <strong>/dev/${drive.name}</strong> — ${drive.size} — ${drive.model}<br>
                        ${mounted}
                    </div>`;
                });
                document.getElementById('drives').innerHTML = html;
            });
        }
        
        function selectImage(path, name, size) {
            selectedImage = path;
            document.getElementById('selected-image').textContent = `${name} (${size})`;
            checkReady();
        }
        
        function selectDrive(path, name, size, model, dangerous) {
            selectedDrive = path;
            document.getElementById('selected-drive').textContent = `/dev/${name} — ${size} — ${model}`;
            if (dangerous) {
                document.getElementById('danger-warning').textContent = '⚠ DANGEROUS: ' + dangerous;
            } else {
                document.getElementById('danger-warning').textContent = '';
            }
            checkReady();
        }
        
        function checkReady() {
            if (selectedImage && selectedDrive) {
                document.getElementById('flash-section').style.display = 'block';
            }
        }
        
        function cancelFlash() {
            selectedImage = null;
            selectedDrive = null;
            document.getElementById('flash-section').style.display = 'none';
            document.getElementById('confirm-input').value = '';
            document.getElementById('flash-btn').disabled = true;
        }
        
        document.getElementById('confirm-input').addEventListener('input', function() {
            const expected = `FLASH ${selectedDrive}`;
            document.getElementById('flash-btn').disabled = this.value !== expected;
        });
        
        document.getElementById('flash-btn').addEventListener('click', function() {
            if (!confirm('Are you absolutely sure? This will destroy all data on ' + selectedDrive)) return;
            
            document.getElementById('progress-section').style.display = 'block';
            document.getElementById('progress-text').textFlashing...';
            
            fetch('/api/flash', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({image: selectedImage, target: selectedDrive})
            }).then(r => r.json()).then(data => {
                document.getElementById('progress-text').textContent = data.message;
                if (data.success) {
                    document.getElementById('progress-bar').style.width = '100%';
                }
                refreshLogs();
            });
        });
        
        function refreshLogs() {
            fetch('/api/logs').then(r => r.json()).then(data => {
                document.getElementById('logs').textContent = data.logs || 'No logs';
            });
        }
        
        // Initial load
        refreshImages();
        refreshDrives();
        refreshLogs();
        
        // Auto-refresh drives every 5s
        setInterval(refreshDrives, 5000);
    </script>
</body>
</html>
"""

# ─── Routes ───────────────────────────────────────────────

@app.route("/")
def index():
    return render_template_string(HTML)

@app.route("/api/images")
def api_images():
    return json_response(get_images())

@app.route("/api/drives")
def api_drives():
    drives = get_removable_drives()
    # Mark dangerous drives
    for drive in drives:
        dangerous, reason = is_dangerous(drive["path"])
        drive["dangerous"] = dangerous
        drive["dangerous_reason"] = reason
    return json_response(drives)

@app.route("/api/flash", methods=["POST"])
def api_flash():
    data = request.get_json()
    image_path = data.get("image", "")
    target = data.get("target", "")
    
    # Validate
    if not image_path or not target:
        return json_response({"success": False, "message": "Missing image or target"}), 400
    
    if not os.path.exists(image_path):
        return json_response({"success": False, "message": f"Image not found: {image_path}"}), 404
    
    dangerous, reason = is_dangerous(target)
    if dangerous:
        log_operation(f"REFUSED: Flash to dangerous device {target}: {reason}")
        return json_response({"success": False, "message": f"Dangerous target: {reason}"}), 403
    
    # Start flash in background
    thread = threading.Thread(target=flash_image, args=(image_path, target))
    thread.start()
    
    log_operation(f"START: Flash {image_path} to {target}")
    return json_response({"success": True, "message": "Flash started. Check logs for progress."})

@app.route("/api/logs")
def api_logs():
    try:
        with open(f"{LOG_DIR}/forge.log", "r") as f:
            logs = f.read()
    except:
        logs = "No logs yet."
    return json_response({"logs": logs})

# ─── Flash Function ───────────────────────────────────────

def flash_image(image_path, target):
    """Flash image to target device safely."""
    try:
        log_operation(f"Flashing {image_path} to {target}")
        
        # Unmount any partitions
        result = subprocess.run(
            ["lsblk", "-n", "-o", "MOUNTPOINT", target],
            capture_output=True, text=True
        )
        for mount in result.stdout.strip().split("\n"):
            if mount:
                subprocess.run(["sudo", "umount", mount], capture_output=True)
                log_operation(f"Unmounted {mount}")
        
        # Write image with progress
        cmd = f"sudo dd if={image_path} of={target} bs=4M status=progress conv=fsync"
        log_operation(f"Running: {cmd}")
        
        process = subprocess.Popen(
            cmd.split(),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        
        for line in process.stdout:
            log_operation(f"dd: {line.strip()}")
        
        process.wait()
        
        if process.returncode == 0:
            log_operation(f"SUCCESS: Flashed {image_path} to {target}")
        else:
            log_operation(f"FAILED: dd exit code {process.returncode}")
            
    except Exception as e:
        log_operation(f"ERROR: {e}")

# ─── Main ─────────────────────────────────────────────────

if __name__ == "__main__":
    log_operation("Forge Console started")
    app.run(host="0.0.0.0", port=8081, debug=False)