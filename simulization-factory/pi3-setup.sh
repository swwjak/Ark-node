#!/bin/bash
# pi3-setup.sh — Common setup for all Pi 3 public service nodes
# Run on each Pi 3 after first boot

set -e

NODE_NAME="${1:?Usage: pi3-setup.sh [pi3-archive|pi3-messenger|pi3-voice|pi3-watchtower]}"
ROLE="${2:?Usage: pi3-setup.sh <hostname> [archive|messenger|voice|watchtower]}"

echo "=== Pi 3 Setup: $NODE_NAME ($ROLE) ==="

# 1. Set hostname
echo "Setting hostname..."
sudo hostnamectl set-hostname "$NODE_NAME"
echo "127.0.1.1 $NODE_NAME" | sudo tee -a /etc/hosts > /dev/null

# 2. Update system
echo "Updating..."
sudo apt update -qq && sudo apt upgrade -y -qq 2>&1 | tail -3

# 3. Install common packages
echo "Installing common packages..."
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
  vim \
  socat \
  sqlite3 \
  ripgrep \
  fd-find \
  tree \
  2>&1 | tail -3

# 4. Enable SSH and avahi
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon

# 5. Configure timezone
sudo timedatectl set-timezone America/Juneau 2>/dev/null || true

# 6. Create library directory
sudo mkdir -p /library/society
sudo chown pi:pi /library
sudo chown pi:pi /library/society

# 7. Create device registry entry
cat > /tmp/device.json << EOF
{
  "hostname": "$NODE_NAME",
  "role": "$ROLE",
  "type": "pi3",
  "status": "active",
  "ip": "$(hostname -I | awk '{print $1}')",
  "added": "$(date -Iseconds)"
}
EOF

# 8. Create state directory
mkdir -p /home/pi/state

# 9. Role-specific setup
echo "Setting up role: $ROLE..."
case "$ROLE" in
  archive)
    echo "Installing Archive packages..."
    # sqlite3 already installed
    ;;
  messenger)
    echo "Installing Messenger packages..."
    pip3 install --break-system-packages paho-mqtt 2>&1 | tail -3 || true
    ;;
  voice)
    echo "Installing Voice packages..."
    sudo apt install -y -qq espeak-ng alsa-utils sox pulseaudio-utils 2>&1 | tail -3
    echo "Testing voice..."
    espeak-ng "Voice node $NODE_NAME online." 2>/dev/null && echo "Voice OK" || echo "Voice WARN"
    ;;
  watchtower)
    echo "Installing Watchtower packages..."
    sudo apt install -y -qq nmap iputils-ping traceroute lm-sensors 2>&1 | tail -3
    ;;
esac

# 10. Summary
echo ""
echo "=== Setup Complete ==="
echo "Hostname: $NODE_NAME"
echo "Role: $ROLE"
echo "IP: $(hostname -I | awk '{print $1}')"
echo "mDNS: $NODE_NAME.local"
echo "SSH: $(sudo systemctl is-active ssh)"
echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "Storage: $(df -h / | tail -1 | awk '{print $3 " used / " $2 "}')"
echo ""
echo "Next: register in /library/society/devices.json"