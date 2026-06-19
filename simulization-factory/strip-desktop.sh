#!/bin/bash
# strip-desktop.sh — Remove desktop overhead from Adam
# Run on Adam only

set -e

echo "=== Stripping desktop from Adam ==="

# 1. Stop and disable desktop services
echo "Stopping desktop services..."
sudo systemctl stop lightdm 2>/dev/null || true
sudo systemctl disable lightdm 2>/dev/null || true
sudo systemctl stop wf-panel-pi 2>/dev/null || true
sudo systemctl stop xdg-desktop-portal-gtk 2>/dev/null || true

# 2. Kill existing session processes
echo "Killing desktop processes..."
killall -u pi labwc Xwayland wf-panel-pi xdg-desktop-portal-gtk 2>/dev/null || true

# 3. Wait for cleanup
sleep 3

# 4. Check what's left
echo ""
echo "=== After cleanup ==="
echo "Memory:"
free -h | head -2
echo ""
echo "Top processes:"
ps aux --sort=-%mem | head -10
echo ""
echo "Ollama runner CPU:"
ps aux | grep "ollama runner" | grep -v grep | awk '{print $3"%"}'

echo ""
echo "=== Desktop stripped ==="
echo "Ollama should now have more CPU and RAM available."