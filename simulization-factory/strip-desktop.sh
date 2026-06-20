#!/bin/bash
# strip-desktop.sh — Remove desktop environment friction
# Run on each Pi to free resources for thinking

set -e

echo "=== Stripping desktop environment ==="

# Stop desktop services
sudo systemctl stop lightdm 2>/dev/null || true
sudo systemctl disable lightdm 2>/dev/null || true
sudo systemctl stop labwc 2>/dev/null || true
sudo systemctl stop xdg-desktop-portal-gtk 2>/dev/null || true
sudo systemctl stop xdg-desktop-portal-wlr 2>/dev/null || true

# Kill any remaining desktop processes
killall -u pi labwc Xwayland wf-panel-pi xdg-desktop-portal-gtk xdg-desktop-portal-wlr 2>/dev/null || true

# Remove snap packages (they consume RAM and CPU)
echo "Removing snaps..."
sudo snap remove --purge gnome-46-2404 2>/dev/null || true
sudo snap remove --purge mesa-2404 2>/dev/null || true
sudo snap remove --purge snap-store 2>/dev/null || true
sudo snap remove --purge gtk-common-themes 2>/dev/null || true
sudo snap remove --purge core24 2>/dev/null || true
sudo snap remove --purge core20 2>/dev/null || true
sudo snap remove --purge ttyd 2>/dev/null || true
sudo snap remove --purge bare 2>/dev/null || true
sudo snap remove --purge core 2>/dev/null || true

# Stop snapd
sudo systemctl stop snapd 2>/dev/null || true
sudo systemctl disable snapd 2>/dev/null || true

# Remove unnecessary services
sudo systemctl stop bluetooth 2>/dev/null || true
sudo systemctl disable bluetooth 2>/dev/null || true
sudo systemctl stop ofono 2>/dev/null || true
sudo systemctl disable ofono 2>/dev/null || true
sudo systemctl stop dundee 2>/dev/null || true
sudo systemctl disable dundee 2>/dev/null || true
sudo systemctl stop colord 2>/dev/null || true
sudo systemctl disable colord 2>/dev/null || true
sudo systemctl stop ipp-usb 2>/dev/null || true
sudo systemctl disable ipp-usb 2>/dev/null || true
sudo systemctl stop upower 2>/dev/null || true
sudo systemctl disable upower 2>/dev/null || true
sudo systemctl stop rtkit-daemon 2>/dev/null || true
sudo systemctl disable rtkit-daemon 2>/dev/null || true
sudo systemctl stop triggerhappy 2>/dev/null || true
sudo systemctl disable triggerhappy 2>/dev/null || true
sudo systemctl stop polkit 2>/dev/null || true
sudo systemctl disable polkit 2>/dev/null || true
sudo systemctl stop accounts-daemon 2>/dev/null || true
sudo systemctl disable accounts-daemon 2>/dev/null || true
sudo systemctl stop udisks2 2>/dev/null || true
sudo systemctl disable udisks2 2>/dev/null || true
sudo systemctl stop connman 2>/dev/null || true
sudo systemctl disable connman 2>/dev/null || true

echo ""
echo "=== Desktop stripped ==="
echo "Memory before: check with free -h"
free -h | grep Mem
echo ""
echo "Services remaining:"
systemctl list-units --type=service --state=running 2>/dev/null | grep -v "systemd\|user\|dbus\|udev\|cron\|ssh\|dhcpcd\|avahi\|wpa\|NetworkManager\|cups\|ollama" | head -10