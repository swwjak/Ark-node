#!/bin/bash
# setup-sensory.sh — Set up voice, ears, face, and camera on Adam and Eve
# Run this script on each Pi

set -e

NODE_NAME="${1:?Usage: setup-sensory.sh [adam|eve]}"

echo "=== Setting up $NODE_NAME ==="

# 1. Set hostname
echo "Setting hostname to $NODE_NAME..."
sudo hostnamectl set-hostname "$NODE_NAME"
echo "127.0.1.1 $NODE_NAME" | sudo tee -a /etc/hosts > /dev/null

# 2. Install packages
echo "Installing packages..."
sudo apt update -qq
sudo apt install -y -qq \
  python3 python3-venv python3-pip \
  sox alsa-utils pulseaudio-utils \
  libcamera-apps \
  git curl wget ffmpeg \
  avahi-daemon \
  2>&1 | tail -3

# 3. Enable avahi for .local resolution
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon

# 4. Test audio
echo ""
echo "=== Audio Test ==="
speaker-test -t sine -f 440 -c 1 -s 1 2>&1 | head -3 || echo "speaker-test not available"

echo ""
echo "=== Setup complete for $NODE_NAME ==="
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I | awk '{print $1}')"