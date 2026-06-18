#!/bin/bash
# fix-eve-ssh.sh — Fix Eve's SSH to listen on all interfaces
# Run from Eve via console (or have Scott run this)

echo "=== Fixing Eve SSH ==="

# Check current SSH config
echo "--- Current SSH config ---"
grep -E "^ListenAddress|^Port" /etc/ssh/sshd_config 2>/dev/null

echo ""
echo "--- Current listening ---"
ss -tlnp | grep :22

echo ""
echo "--- Firewall ---"
sudo iptables -L INPUT -n 2>/dev/null | grep :22 | head -5

echo ""
# Fix: ensure SSH listens on all interfaces
echo "Setting ListenAddress to 0.0.0.0..."
sudo sed -i 's/^#*ListenAddress.*/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
echo "ListeningAddress 0.0.0.0" | sudo tee -a /etc/ssh/sshd_config > /dev/null

# Restart SSH
sudo systemctl restart ssh
echo "SSH restarted."

echo ""
echo "--- Verify ---"
ss -tlnp | grep :22