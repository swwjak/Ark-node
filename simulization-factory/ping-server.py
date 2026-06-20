#!/usr/bin/env python3
"""Minimal test server for Forge Console."""
import http.server
import json

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/ping':
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'FORGE_OK\n')
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    server = http.server.HTTPServer(('0.0.0.0', 8081), Handler)
    print('Serving on port 8081', flush=True)
    server.serve_forever()