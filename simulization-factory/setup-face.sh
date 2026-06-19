#!/bin/bash
# setup-face.sh — Create minimal web face for Adam or Eve
# Run on each Pi after setup-sensory.sh

NODE_NAME="${1:?Usage: setup-face.sh [adam|eve]}"
PORT="${2:-8080}"

echo "=== Setting up web face for $NODE_NAME on port $PORT ==="

# Create face directory
FACE_DIR="/home/pi/face"
mkdir -p "$FACE_DIR"

# Create the web face HTML
cat > "$FACE_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>__NODE_NAME__</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: monospace; background: #1a1a2e; color: #eee; padding: 20px; max-width: 600px; margin: 0 auto; }
        h1 { color: #00d4ff; }
        .status { background: #16213e; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .status.ok { border-left: 3px solid #00ff88; }
        .status.warn { border-left: 3px solid #ffaa00; }
        input[type=text] { width: 70%; padding: 8px; background: #0f3460; color: #eee; border: 1px solid #00d4ff; }
        button { padding: 8px 16px; background: #00d4ff; color: #000; border: none; cursor: pointer; }
        button:hover { background: #00a8cc; }
        #log { background: #0a0a1a; padding: 10px; height: 200px; overflow-y: scroll; font-size: 12px; border: 1px solid #333; }
        .log-entry { margin: 2px 0; }
        .log-time { color: #666; }
    </style>
</head>
<body>
    <h1>__NODE_NAME__</h1>
    <div class="status ok" id="status">Online</div>
    
    <h2>Speak</h2>
    <input type="text" id="speakText" placeholder="Type something..." onkeypress="if(event.key==='Enter')speak()">
    <button onclick="speak()">Speak</button>
    
    <h2>Chat</h2>
    <input type="text" id="chatInput" placeholder="Ask something..." onkeypress="if(event.key==='Enter')chat()">
    <button onclick="chat()">Send</button>
    
    <h2>Log</h2>
    <div id="log"></div>
    
    <script>
        function log(msg) {
            const d = document.getElementById('log');
            const t = new Date().toLocaleTimeString();
            d.innerHTML = '<div class="log-entry"><span class="log-time">[' + t + ']</span> ' + msg + '</div>' + d.innerHTML;
        }
        
        function speak() {
            const text = document.getElementById('speakText').value;
            if (!text) return;
            log('Speaking: ' + text);
            fetch('/api/speak', {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({text})})
                .then(r => r.json()).then(d => log('OK: ' + d.status)).catch(e => log('ERR: ' + e));
        }
        
        function chat() {
            const text = document.getElementById('chatInput').value;
            if (!text) return;
            log('You: ' + text);
            document.getElementById('chatInput').value = '';
            fetch('/api/chat', {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({text})})
                .then(r => r.json()).then(d => log('__NODE_NAME__: ' + d.response)).catch(e => log('ERR: ' + e));
        }
        
        // Status check every 10s
        setInterval(() => {
            fetch('/api/status').then(r => r.json()).then(d => {
                document.getElementById('status').textContent = 'Online - ' + d.uptime;
            }).catch(() => {
                document.getElementById('status').textContent = 'Offline';
                document.getElementById('status').className = 'status warn';
            });
        }, 10000);
        
        log('Face loaded');
    </script>
</body>
</html>
HTMLEOF

# Replace placeholder with actual node name
sed -i "s/__NODE_NAME__/$NODE_NAME/g" "$FACE_DIR/index.html"

# Create the Python web server
cat > "$FACE_DIR/server.py" << 'PYEOF'
#!/usr/bin/env python3
"""Minimal web face for a Pi node."""

import http.server
import json
import subprocess
import time
import os
from urllib.parse import urlparse

NODE_NAME = os.environ.get("NODE_NAME", "node")
PORT = int(os.environ.get("PORT", 8080))
FACE_DIR = os.path.dirname(os.path.abspath(__file__))

class FaceHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path == '/' or parsed.path == '/index.html':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            with open(f'{FACE_DIR}/index.html', 'r') as f:
                self.wfile.write(f.read().encode())
        elif parsed.path == '/api/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            uptime = subprocess.getoutput("uptime -p").replace("up ", "")
            self.wfile.write(json.dumps({"status": "ok", "uptime": uptime, "node": NODE_NAME}).encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_POST(self):
        parsed = urlparse(self.path)
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)
        
        try:
            data = json.loads(body) if body else {}
        except:
            data = {}
        
        if parsed.path == '/api/speak':
            text = data.get('text', '')
            if text:
                # Use espeak-ng for TTS
                subprocess.run(['espeak-ng', '-v', 'en', text], timeout=30)
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"status": "spoken", "text": text}).encode())
            else:
                self.send_response(400)
                self.end_headers()
        
        elif parsed.path == '/api/chat':
            text = data.get('text', '')
            if text:
                # Simple echo for now — will be replaced with actual model
                response = f"Received: {text}"
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"response": response}).encode())
            else:
                self.send_response(400)
                self.end_headers()
        
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        pass  # Suppress log output

if __name__ == '__main__':
    server = http.server.HTTPServer(('0.0.0.0', PORT), FaceHandler)
    print(f'{NODE_NAME} face server running on port {PORT}')
    server.serve_forever()
PYEOF

chmod +x "$FACE_DIR/server.py"

# Create systemd service
sudo tee /etc/systemd/system/${NODE_NAME}-face.service << SERVICEEOF
[Unit]
Description=Web Face for $NODE_NAME
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=$FACE_DIR
Environment=NODE_NAME=$NODE_NAME
Environment=PORT=$PORT
ExecStart=/usr/bin/python3 $FACE_DIR/server.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable ${NODE_NAME}-face.service
sudo systemctl start ${NODE_NAME}-face.service

echo ""
echo "=== Web face setup complete for $NODE_NAME ==="
echo "URL: http://$(hostname -I | awk '{print $1}'):$PORT"
echo "Service: ${NODE_NAME}-face.service"
echo "Status: $(sudo systemctl is-active ${NODE_NAME}-face.service)"