#!/usr/bin/env python3
"""University Status API — Minimal, boring, testable."""
import http.server
import json
import subprocess
import os
from datetime import datetime

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/ping':
            self._text('UNIVERSITY_OK\n')
        elif self.path == '/status':
            self._json(self._get_status())
        elif self.path == '/resources':
            self._json(self._get_resources())
        else:
            self._text('NOT_FOUND\n', 404)
    
    def _text(self, msg, code=200):
        self.send_response(code)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write(msg.encode())
    
    def _json(self, data, code=200):
        body = json.dumps(data, indent=2, default=str).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    
    def _get_status(self):
        return {
            "name": "University",
            "hostname": subprocess.getoutput("hostname -f"),
            "uptime": subprocess.getoutput("uptime -p"),
            "time": datetime.now().isoformat(),
            "status": "online"
        }
    
    def _get_resources(self):
        return {
            "cpu": subprocess.getoutput("nproc").strip(),
            "memory": subprocess.getoutput("free -h | grep Mem | awk '{print $2}'").strip(),
            "memory_free": subprocess.getoutput("free -h | grep Mem | awk '{print $7}'").strip(),
            "storage": subprocess.getoutput("df -h / | tail -1 | awk '{print $2}'").strip(),
            "storage_free": subprocess.getoutput("df -h / | tail -1 | awk '{print $4}'").strip(),
            "os": subprocess.getoutput("cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"'").strip(),
            "kernel": subprocess.getoutput("uname -r").strip(),
            "docker": subprocess.getoutput("docker --version 2>/dev/null | head -1").strip(),
            "python": subprocess.getoutput("python3 --version").strip(),
            "tailscale": subprocess.getoutput("tailscale version 2>/dev/null | head -1").strip()
        }
    
    def log_message(self, fmt, *args):
        pass

if __name__ == '__main__':
    os.makedirs("/srv/hermes/logs", exist_ok=True)
    with open("/srv/hermes/logs/university.log", "a") as f:
        f.write(f"[{datetime.now().isoformat()}] University API started on port 8080\n")
    server = http.server.HTTPServer(('0.0.0.0', 8080), Handler)
    print("University API on port 8080", flush=True)
    server.serve_forever()