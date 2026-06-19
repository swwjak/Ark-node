#!/bin/bash
# setup-face-display.sh — Install face display service on Adam or Eve
# Run on each Pi

NODE_NAME="${1:?Usage: setup-face-display.sh [adam|eve]}"

echo "=== Setting up face display for $NODE_NAME ==="

# Install pygame for DSI rendering
pip3 install --break-system-packages pygame 2>&1 | tail -3

# Create face directory
FACE_DIR="/home/pi/face"
mkdir -p "$FACE_DIR"

# Create the face application
cat > "$FACE_DIR/face.py" << 'PYEOF'
#!/usr/bin/env python3
"""Minimal face display for DSI. Shows eyes, status, and messages."""

import pygame
import sys
import os
import json
import subprocess
import time
import threading

NODE = os.environ.get("NODE_NAME", "node")
STATE_FILE = f"/tmp/{NODE}_face_state.json"

# Initialize pygame for DSI
os.environ["SDL_VIDEODRIVER"] = "kmsdrm"
os.environ["SDL_FBDEV"] = "/dev/fb0"

pygame.init()

# Get display info
info = pygame.display.Info()
W, H = info.current_w, info.current_h
screen = pygame.display.set_mode((W, H), pygame.FULLSCREEN)
pygame.mouse.set_visible(False)

# Colors
BG = (10, 10, 20)
WHITE = (220, 220, 220)
CYAN = (0, 200, 220)
DIM = (60, 60, 80)
EYE_WHITE = (240, 240, 250)
EYE_PUPIL = (30, 30, 40)
GREEN = (0, 255, 120)
YELLOW = (255, 200, 0)
RED = (255, 80, 80)

# Fonts
font_small = pygame.font.SysFont("monospace", max(12, H // 40))
font_med = pygame.font.SysFont("monospace", max(16, H // 25))
font_big = pygame.font.SysFont("monospace", max(24, H // 15))

# State
state = {"mode": "idle", "message": NODE, "sub": "", "blink": 0}

def load_state():
    global state
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
    except:
        pass

def draw_eye(surface, cx, cy, w, h, pupil_offset=(0,0), blink=0):
    """Draw one eye with optional blink (0=open, 1=closed)."""
    if blink > 0.5:
        # Closed eye — just a line
        pygame.draw.line(surface, WHITE, (cx - w//2, cy), (cx + w//2, cy), 2)
        return
    
    # Eye white (ellipse)
    pygame.draw.ellipse(surface, EYE_WHITE, (cx - w//2, cy - h//2, w, h))
    pygame.draw.ellipse(surface, DIM, (cx - w//2, cy - h//2, w, h), 2)
    
    # Pupil
    pr = h // 3
    px = cx + pupil_offset[0]
    py = cy + pupil_offset[1]
    pygame.draw.circle(surface, EYE_PUPIL, (px, py), pr)
    pygame.draw.circle(surface, CYAN, (px, py), pr - 2)

def draw_face():
    screen.fill(BG)
    
    load_state()
    mode = state.get("mode", "idle")
    msg = state.get("message", NODE)
    sub = state.get("sub", "")
    blink = state.get("blink", 0)
    
    # Determine eye expression based on mode
    if mode == "thinking":
        pupil_off = (0, -2)  # eyes up
        eye_h = H // 12
    elif mode == "speaking":
        pupil_off = (0, 0)
        eye_h = H // 10  # wider
    elif mode == "warning":
        pupil_off = (0, 2)  # eyes down
        eye_h = H // 14  # narrowed
    elif mode == "sleeping":
        pupil_off = (0, 0)
        eye_h = H // 20  # nearly closed
    else:  # idle
        pupil_off = (0, 0)
        eye_h = H // 10
    
    eye_w = H // 5
    eye_y = H // 3
    eye_spacing = H // 3
    
    # Draw eyes
    draw_eye(screen, W//2 - eye_spacing, eye_y, eye_w, eye_h, pupil_off, blink)
    draw_eye(screen, W//2 + eye_spacing, eye_y, eye_w, eye_h, pupil_off, blink)
    
    # Status indicator (small dot)
    status_colors = {
        "idle": CYAN, "thinking": YELLOW, "speaking": GREEN,
        "warning": RED, "sleeping": DIM
    }
    sc = status_colors.get(mode, CYAN)
    pygame.draw.circle(screen, sc, (W // 2, H // 8), H // 60)
    
    # Node name
    name_surf = font_big.render(msg, True, WHITE)
    screen.blit(name_surf, (W//2 - name_surf.get_width()//2, H//2))
    
    # Mode text
    mode_surf = font_med.render(mode.upper(), True, CYAN)
    screen.blit(mode_surf, (W//2 - mode_surf.get_width()//2, H//2 + H//12))
    
    # Sub message
    if sub:
        sub_surf = font_small.render(sub[:40], True, DIM)
        screen.blit(sub_surf, (W//2 - sub_surf.get_width()//2, H//2 + H//6))
    
    # Uptime
    try:
        up = subprocess.getoutput("uptime -p").replace("up ", "")[:20]
        up_surf = font_small.render(up, True, DIM)
        screen.blit(up_surf, (W//2 - up_surf.get_width()//2, H - H//10))
    except:
        pass
    
    pygame.display.flip()

# Blink timer
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

# Main loop
clock = pygame.time.Clock()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                running = False
    
    draw_face()
    clock.tick(15)  # 15fps is plenty for a face

pygame.quit()
PYEOF

chmod +x "$FACE_DIR/face.py"

# Create systemd service
sudo tee /etc/systemd/system/${NODE_NAME}-face-display.service << SERVICEEOF
[Unit]
Description=Face Display for $NODE_NAME
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=$FACE_DIR
Environment=NODE_NAME=$NODE_NAME
Environment=SDL_VIDEODRIVER=kmsdrm
Environment=SDL_FBDEV=/dev/fb0
ExecStartPre=/bin/sleep 3
ExecStart=/usr/bin/python3 $FACE_DIR/face.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable ${NODE_NAME}-face-display.service
sudo systemctl start ${NODE_NAME}-face-display.service

echo ""
echo "=== Face display setup complete for $NODE_NAME ==="
echo "Service: ${NODE_NAME}-face-display.service"
echo "Status: $(sudo systemctl is-active ${NODE_NAME}-face-display.service)"
echo ""
echo "The face should appear on the DSI display."
echo "States: idle, thinking, speaking, warning, sleeping"
echo "Update state: '{\"mode\":\"thinking\",\"message\":\"Thinking...\"}' > /tmp/${NODE_NAME}_face_state.json"