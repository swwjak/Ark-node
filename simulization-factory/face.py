#!/usr/bin/env python3
"""Minimal face display using direct framebuffer access."""

import os
import sys
import json
import subprocess
import time
import threading

NODE = os.environ.get("NODE_NAME", "node")
STATE_FILE = f"/tmp/{NODE}_face_state.json"

# Use fbcon driver which writes directly to /dev/fb0
os.environ["SDL_VIDEODRIVER"] = "fbcon"
os.environ["SDL_FBDEV"] = "/dev/fb0"

import pygame

pygame.init()
info = pygame.display.Info()
W, H = info.current_w, info.current_h

# Try fullscreen first, then windowed
try:
    screen = pygame.display.set_mode((W, H), pygame.FULLSCREEN)
except:
    try:
        screen = pygame.display.set_mode((W, H))
    except:
        screen = pygame.display.set_mode((480, 320))
        W, H = 480, 320

pygame.mouse.set_visible(False)
print(f"Face display: {W}x{H}", flush=True)

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

font_small = pygame.font.SysFont("monospace", max(12, H // 40))
font_med = pygame.font.SysFont("monospace", max(16, H // 25))
font_big = pygame.font.SysFont("monospace", max(24, H // 15))

state = {"mode": "idle", "message": NODE, "sub": "", "blink": 0}

def load_state():
    global state
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
    except:
        pass

def draw_eye(surface, cx, cy, w, h, pupil_offset=(0,0), blink=0):
    if blink > 0.5:
        pygame.draw.line(surface, WHITE, (cx - w//2, cy), (cx + w//2, cy), 2)
        return
    pygame.draw.ellipse(surface, EYE_WHITE, (cx - w//2, cy - h//2, w, h))
    pygame.draw.ellipse(surface, DIM, (cx - w//2, cy - h//2, w, h), 2)
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
    
    if mode == "thinking":
        pupil_off = (0, -2); eye_h = H // 12
    elif mode == "speaking":
        pupil_off = (0, 0); eye_h = H // 10
    elif mode == "warning":
        pupil_off = (0, 2); eye_h = H // 14
    elif mode == "sleeping":
        pupil_off = (0, 0); eye_h = H // 20
    else:
        pupil_off = (0, 0); eye_h = H // 10
    
    eye_w = H // 5
    eye_y = H // 3
    eye_spacing = H // 3
    
    draw_eye(screen, W//2 - eye_spacing, eye_y, eye_w, eye_h, pupil_off, blink)
    draw_eye(screen, W//2 + eye_spacing, eye_y, eye_w, eye_h, pupil_off, blink)
    
    status_colors = {"idle": CYAN, "thinking": YELLOW, "speaking": GREEN, "warning": RED, "sleeping": DIM}
    sc = status_colors.get(mode, CYAN)
    pygame.draw.circle(screen, sc, (W // 2, H // 8), H // 60)
    
    name_surf = font_big.render(msg, True, WHITE)
    screen.blit(name_surf, (W//2 - name_surf.get_width()//2, H//2))
    
    mode_surf = font_med.render(mode.upper(), True, CYAN)
    screen.blit(mode_surf, (W//2 - mode_surf.get_width()//2, H//2 + H//12))
    
    if sub:
        sub_surf = font_small.render(sub[:40], True, DIM)
        screen.blit(sub_surf, (W//2 - sub_surf.get_width()//2, H//2 + H//6))
    
    try:
        up = subprocess.getoutput("uptime -p").replace("up ", "")[:20]
        up_surf = font_small.render(up, True, DIM)
        screen.blit(up_surf, (W//2 - up_surf.get_width()//2, H - H//10))
    except:
        pass
    
    pygame.display.flip()

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
    clock.tick(15)

pygame.quit()