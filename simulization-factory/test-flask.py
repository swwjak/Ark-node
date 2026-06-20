#!/usr/bin/env python3
"""Test Flask JSON response"""
import json
from flask import Flask, Response

app = Flask(__name__)

@app.route('/test')
def test():
    data = {"test": "ok", "count": 3, "items": ["a", "b", "c"]}
    resp = Response(json.dumps(data) + "\n", mimetype="application/json")
    return resp

@app.route('/drives')
def drives():
    import subprocess
    result = subprocess.run(
        ["lsblk", "-J", "-o", "NAME,SIZE,TYPE,RM"],
        capture_output=True, text=True, timeout=10
    )
    data = json.loads(result.stdout)
    drives = []
    for d in data.get("blockdevices", []):
        if d.get("type") == "disk" and d.get("rm"):
            drives.append({"name": d["name"], "size": d["size"]})
    return Response(json.dumps(drives) + "\n", mimetype="application/json")

if __name__ == "__main__":
    print("Starting test server on port 9999")
    app.run(host="0.0.0.0", port=9999, debug=False)