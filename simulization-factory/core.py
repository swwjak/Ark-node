#!/usr/bin/env python3
"""Text core for Adam and Eve.
Maintains state, accepts commands, runs inference.
Always available via SSH.
"""

import os
import sys
import json
import subprocess
import time
import threading
from datetime import datetime

NODE = os.environ.get("NODE_NAME", "node")
STATE_FILE = f"/home/pi/state/{NODE}.json"
LOG_FILE = f"/home/pi/state/{NODE}.log"
INVENTORY_FILE = "/home/pi/state/inventory.jsonl"

os.makedirs("/home/pi/state", exist_ok=True)

state = {
    "node": NODE,
    "status": "READY",
    "mode": "IDLE",
    "thought": None,
    "last_action": "Boot complete",
    "started": datetime.now().isoformat(),
    "errors": []
}

def save_state():
    try:
        with open(STATE_FILE, 'w') as f:
            json.dump(state, f, indent=2)
    except:
        pass

def log(msg):
    try:
        ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(LOG_FILE, 'a') as f:
            f.write(f"[{ts}] {msg}\n")
    except:
        pass

def load_state():
    global state
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
    except:
        pass

def get_uptime():
    try:
        return subprocess.getoutput("uptime -p").replace("up ", "")
    except:
        return "unknown"

def get_ip():
    try:
        return subprocess.getoutput("hostname -I").split()[0]
    except:
        return "unknown"

def get_load():
    try:
        return subprocess.getoutput("cat /proc/loadavg").split()[0]
    except:
        return "?"

def get_memory():
    try:
        lines = subprocess.getoutput("free -m").split("\n")
        parts = lines[1].split()
        return f"{parts[2]}M/{parts[1]}M"
    except:
        return "?"

def think(prompt):
    """Run Ollama inference via subprocess. Returns text response."""
    state["mode"] = "THINKING"
    state["thought"] = prompt
    save_state()
    log(f"THINK: {prompt[:80]}")
    
    try:
        result = subprocess.run(
            ["ollama", "run", "qwen3:4b"],
            input=prompt,
            capture_output=True,
            text=True,
            timeout=300
        )
        response = result.stdout.strip()
        if not response:
            response = "No response"
        
        state["mode"] = "IDLE"
        state["last_action"] = f"Thought about: {prompt[:50]}"
        save_state()
        log(f"THINK DONE: {response[:80]}")
        return response
        
    except subprocess.TimeoutExpired:
        state["mode"] = "IDLE"
        state["errors"].append("Think timeout")
        save_state()
        log(f"THINK TIMEOUT: {prompt[:50]}")
        return "Error: Inference timed out (300s). The model may be loading."
    except Exception as e:
        state["mode"] = "IDLE"
        state["errors"].append(str(e))
        save_state()
        log(f"THINK ERROR: {e}")
        return f"Error: {e}"

def speak(text):
    """Speak text aloud via espeak-ng."""
    state["mode"] = "SPEAKING"
    save_state()
    log(f"SPEAK: {text[:80]}")
    
    try:
        subprocess.run(["espeak-ng", text], timeout=30)
        state["mode"] = "IDLE"
        state["last_action"] = f"Said: {text[:50]}"
        save_state()
        return f"Spoken: {text}"
    except Exception as e:
        state["mode"] = "IDLE"
        save_state()
        return f"Speech error: {e}"

def inventory_list():
    items = []
    try:
        with open(INVENTORY_FILE, 'r') as f:
            for line in f:
                line = line.strip()
                if line:
                    items.append(json.loads(line))
    except:
        pass
    if not items:
        return "Inventory is empty."
    lines = [f"Inventory ({len(items)} items):"]
    for item in items[-20:]:
        name = item.get("name", "?")
        loc = item.get("location", "?")
        ts = item.get("added", "?")[:16]
        lines.append(f"  {name} | {loc} | {ts}")
    return "\n".join(lines)

def inventory_add(name, location="", notes=""):
    item = {
        "name": name,
        "location": location,
        "notes": notes,
        "added": datetime.now().isoformat()
    }
    with open(INVENTORY_FILE, 'a') as f:
        f.write(json.dumps(item) + "\n")
    log(f"INVENTORY ADD: {name}")
    return f"Added: {name} @ {location}"

def status():
    load_state()
    return f"""STATUS: {state['status']}
MODE: {state['mode']}
NODE: {NODE}
IP: {get_ip()}
UPTIME: {get_uptime()}
LOAD: {get_load()}
MEMORY: {get_memory()}
LAST_ACTION: {state['last_action']}
ERRORS: {len(state['errors'])}
THOUGHT: {state.get('thought', 'None')}"""

def process_command(cmd_text):
    cmd_text = cmd_text.strip()
    if not cmd_text:
        return "No command given. Try: STATUS, THINK, SPEAK, INVENTORY"
    parts = cmd_text.split(None, 1)
    cmd = parts[0].upper()
    args = parts[1] if len(parts) > 1 else ""
    
    if cmd == "STATUS":
        return status()
    elif cmd == "THINK":
        if not args:
            return "Usage: THINK <prompt>"
        return think(args)
    elif cmd == "SPEAK":
        if not args:
            return "Usage: SPEAK <text>"
        return speak(args)
    elif cmd == "INVENTORY":
        if args.upper().startswith("ADD "):
            item_text = args[4:]
            parts = [p.strip() for p in item_text.split("|")]
            name = parts[0] if parts else "unknown"
            loc = parts[1] if len(parts) > 1 else ""
            notes = parts[2] if len(parts) > 2 else ""
            return inventory_add(name, loc, notes)
        else:
            return inventory_list()
    elif cmd == "LOG":
        try:
            lines = subprocess.getoutput(f"tail -20 {LOG_FILE}")
            return f"Recent log:\n{lines}"
        except:
            return "No log available."
    elif cmd == "PING":
        return f"PONG from {NODE}"
    elif cmd == "HELP":
        return """Commands:
  STATUS — current state
  THINK <prompt> — run inference (~30s on Pi 4)
  SPEAK <text> — speak aloud
  INVENTORY — list items
  INVENTORY ADD name | location | notes — add item
  LOG — recent log entries
  PING — test connection
  HELP — this list"""
    else:
        return f"Unknown command: {cmd}. Try HELP."

def interactive():
    print(f"╔══════════════════════════════════╗")
    print(f"║  {NODE:^32s}  ║")
    print(f"║  Text Core v1.0                  ║")
    print(f"╚══════════════════════════════════╝")
    print(f"Type HELP for commands. Ctrl+C to exit.\n")
    while True:
        try:
            cmd = input(f"{NODE}> ")
            response = process_command(cmd)
            print(response)
            print()
        except KeyboardInterrupt:
            print(f"\n{NODE} signing off.")
            break
        except EOFError:
            break

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = " ".join(sys.argv[1:])
        print(process_command(cmd))
    else:
        interactive()