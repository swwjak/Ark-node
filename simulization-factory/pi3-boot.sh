#!/bin/bash
# pi3-boot.sh — First boot setup for Pi 3 public service nodes
# Run once after first boot, before role specialization

set -e

NODE_NAME=$(hostname)
ROLE=""

echo "=== Pi 3 First Boot: $NODE_NAME ==="

# 1. Update system
sudo apt update -qq && sudo apt upgrade -y -qq 2>&1 | tail -3

# 2. Install essentials
sudo apt install -y -qq \
  openssh-server \
  avahi-daemon \
  git \
  curl \
  wget \
  rsync \
  python3 \
  python3-venv \
  python3-pip \
  jq \
  htop \
  tmux \
  nano \
  vim-tiny \
  socat \
  sqlite3 \
  ripgrep \
  tree

# 3. Create library mount point
sudo mkdir -p /library
sudo chown pi:pi /library

# 4. Create standard directory structure
mkdir -p /home/pi/state
mkdir -p /home/pi/logs

# 5. Set timezone
sudo timedatectl set-timezone America/Juneau 2>/dev/null || true

# 6. Disable unnecessary services
sudo systemctl disable bluetooth 2>/dev/null || true
sudo systemctl stop bluetooth 2>/dev/null || true

# 7. Status
echo ""
echo "=== Setup Complete ==="
echo "Hostname: $NODE_NAME"
echo "IP: $(hostname -I | awk '{print $1}')"
echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "Storage: $(df -h / | tail -1 | awk '{print $2 " total, " $4 " free"}')"
echo ""
echo "Next: Run role-specific setup (archive|messenger|voice|watchtower)"