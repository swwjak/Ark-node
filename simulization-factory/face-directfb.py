#!/usr/bin/env python3
"""Direct framebuffer face display. No pygame needed."""

import os
import sys
import json
import subprocess
import time
import threading
import struct
import mmap

NODE = os.environ.get("NODE_NAME", "node")
STATE_FILE = f"/tmp/{NODE}_face_state.json"
FB_DEV = "/dev/fb0"

# Colors (RGB565 for 16-bit framebuffer)
def rgb565(r, g, b):
    return ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3)

BG = rgb565(10, 10, 20)
WHITE = rgb565(220, 220, 220)
CYAN = rgb565(0, 200, 220)
DIM = rgb565(60, 60, 80)
EYE_WHITE = rgb565(240, 240, 250)
EYE_PUPIL = rgb565(30, 30, 40)
GREEN = rgb565(0, 255, 120)
YELLOW = rgb565(255, 200, 0)
RED = rgb565(255, 80, 80)

# Get framebuffer info
def get_fb_info():
    with open(FB_DEV, 'rb') as f:
        # FBIOGET_VSCREENINFO = 0x4600
        import fcntl
        info = fcntl.ioctl(f.fileno(), 0x4600, b'\x00' * 160)
        # Parse struct fb_var_screeninfo
        xres, yres = struct.unpack_from('II', info, 0)
        bpp = struct.unpack_from('I', info, 24)[0]
        return xres, yres, bpp

try:
    W, H, bpp = get_fb_info()
    print(f"Framebuffer: {W}x{H} @ {bpp}bpp", flush=True)
except Exception as e:
    print(f"Cannot open framebuffer: {e}", flush=True)
    # Fallback: just print to stdout
    W, H = 480, 320
    bpp = 16

state = {"mode": "idle", "message": NODE, "sub": "", "blink": 0}

def load_state():
    global state
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
    except:
        pass

def draw_frame():
    """Draw the face directly to framebuffer."""
    load_state()
    mode = state.get("mode", "idle")
    msg = state.get("message", NODE)
    sub = state.get("sub", "")
    blink = state.get("blink", 0)
    
    # Create a simple framebuffer image
    # For simplicity, we'll use a subprocess to render with ffmpeg or Python PIL
    # But first, let's try the simplest possible approach: write raw pixels
    
    # Actually, let's use a much simpler approach: write a PPM image and use fbi
    # Or better: use Python's built-in struct to write raw RGB to the framebuffer
    
    # For 16-bit framebuffer (RGB565)
    if bpp == 16:
        row_size = W * 2
        buf = bytearray(row_size * H)
        
        for y in range(H):
            for x in range(W):
                # Default background
                color = BG
                
                # Simple face rendering
                cx, cy = W // 2, H // 3
                
                # Left eye
                lex, ley = cx - H//3, cy
                if (x - lex)**2 + (y - ley)**2 < (H//10)**2:
                    if blink > 0.5 and abs(x - lex) < H//20 and y == ley:
                        color = WHITE  # blink line
                    else:
                        color = EYE_WHITE
                        # Pupil
                        if (x - lex)**2 + (y - ley)**2 < (H//30)**2:
                            color = EYE_PUPIL
                
                # Right eye
                rex, rey = cx + H//3, cy
                if (x - rex)**2 + (y - rey)**2 < (H//10)**2:
                    if blink > 0.5 and abs(x - rex) < H//20 and y == rey:
                        color = WHITE
                    else:
                        color = EYE_WHITE
                        if (x - rex)**2 + (y - rey)**2 < (H//30)**2:
                            color = EYE_PUPIL
                
                # Status dot
                if (x - cx)**2 + (y - H//8)**2 < (H//60)**2:
                    status_colors = {"idle": CYAN, "thinking": YELLOW, "speaking": GREEN, "warning": RED, "sleeping": DIM}
                    color = status_colors.get(mode, CYAN)
                
                # Write pixel (RGB565, little-endian)
                offset = y * row_size + x * 2
                buf[offset] = color & 0xFF
                buf[offset + 1] = (color >> 8) & 0xFF
        
        # Write to framebuffer
        try:
            with open(FB_DEV, 'wb') as f:
                f.write(buf)
        except Exception as e:
            print(f"FB write failed: {e}", flush=True)

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

print("Face display running (framebuffer mode)", flush=True)
clock = time.time()
while True:
    draw_frame()
    time.sleep(0.1)  # 10fps