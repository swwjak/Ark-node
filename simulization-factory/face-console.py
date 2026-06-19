#!/usr/bin/env python3
"""Console face for Adam and Eve. Text-based status display."""

import os
import sys
import json
import subprocess
import time
import threading

NODE = os.environ.get("NODE_NAME", "node")
STATE_FILE = f"/tmp/{NODE}_face_state.json"

state = {"mode": "idle", "message": NODE, "sub": "", "blink": 0}

def load_state():
    global state
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
    except:
        pass

def clear_screen():
    os.system('clear')

def draw_face():
    load_state()
    mode = state.get("mode", "idle")
    msg = state.get("message", NODE)
    sub = state.get("sub", "")
    blink = state.get("blink", 0)
    
    # Face ASCII art
    eye_open = "  ○   ○  "
    eye_blink = "  ─   ─  "
    eyes = eye_blink if blink > 0.5 else eye_open
    
    status_colors = {
        "idle": "CYAN", "thinking": "YELLOW", "speaking": "GREEN",
        "warning": "RED", "sleeping": "DIM"
    }
    sc = status_colors.get(mode, "CYAN")
    
    # ANSI color codes
    colors = {
        "CYAN": "\033[36m", "YELLOW": "\033[33m", "GREEN": "\033[32m",
        "RED": "\033[31m", "DIM": "\033[2;37m", "WHITE": "\033[37m",
        "RESET": "\033[0m", "BOLD": "\033[1m"
    }
    
    c = colors.get(sc, colors["CYAN"])
    r = colors["RESET"]
    b = colors["BOLD"]
    w = colors["WHITE"]
    
    # Get uptime
    try:
        up = subprocess.getoutput("uptime -p").replace("up ", "")[:20]
    except:
        up = "unknown"
    
    # Get IP
    try:
        ip = subprocess.getoutput("hostname -I").split()[0]
    except:
        ip = "unknown"
    
    clear_screen()
    
    print(f"""
{c}{b}  ╔══════════════════════════════════╗
  ║  {w}{b}{msg:^32s}{c}  ║
  ║  {w}{mode.upper():^32s}{c}  ║
  ╚══════════════════════════════════╝{r}

{w}        {eyes}

{c}  Status: {w}{mode}{c}    IP: {w}{ip}{c}
  Uptime: {w}{up}{c}
  Node:   {w}{NODE}{r}
""")
    
    if sub:
        print(f"{c}  {w}{sub}{r}")
    
    print(f"""
{c}  ──────────────────────────────────
  Commands: speak | think | idle | sleep
  Status file: {STATE_FILE}
{c}  ──────────────────────────────────{r}
""")

def blink_loop():
    import random
    while True:
        time.sleep(random.uniform(2, 5))
        state["blink"] = 1
        try:
            with open(STATE_FILE, 'w') as f:
                json.dump(state, f)
        except:
            pass
        time.sleep(0.15)
        state["blink"] = 0
        try:
            with open(STATE_FILE, 'w') as f:
                json.dump(state, f)
        except:
            pass

blink_thread = threading.Thread(target=blink_loop, daemon=True)
blink_thread.start()

print(f"Console face for {NODE}. Set state via:")
print(f'  echo \'{{"mode":"speaking","message":"{NODE}","sub":"Hello"}}\' > {STATE_FILE}')
print(f"Running refresh loop...\n")

while True:
    draw_face()
    time.sleep(1)