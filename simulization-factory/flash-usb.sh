#!/bin/bash
# flash-usb.sh — Download image from phone and write to USB drive
# Run on Eve: bash flash-usb.sh

set -e

IMAGE_URL="http://10.98.79.83:8080/raspios-lite.img"
IMAGE_FILE="/tmp/raspios-lite.img"
USB_DEVICE="/dev/sda"

echo "=== Pi 3 USB Flasher ==="
echo "Downloading from: $IMAGE_URL"
echo "Writing to: $USB_DEVICE"
echo ""

# Kill any existing download
pkill -f "curl.*raspios-lite" 2>/dev/null || true
sleep 1

# Unmount USB drive
sudo umount ${USB_DEVICE}1 2>/dev/null || true

# Download with progress
echo "Starting download..."
curl -L -o "$IMAGE_FILE" "$IMAGE_URL" 2>&1 | tail -1
echo ""
echo "Download complete: $(ls -lh $IMAGE_FILE | awk '{print $5}')"

# Verify minimum size (should be ~5.8GB)
SIZE=$(stat -c%s "$IMAGE_FILE" 2>/dev/null || echo 0)
if [ "$SIZE" -lt 5000000000 ]; then
    echo "ERROR: Image too small ($SIZE bytes). Download may have failed."
    exit 1
fi

# Write to USB
echo "Writing to $USB_DEVICE..."
sudo dd if="$IMAGE_FILE" of="$USB_DEVICE" bs=4M conv=fsync 2>&1 | tail -3

echo ""
echo "=== Flash complete ==="
echo "USB drive is ready for Pi 3 boot."
echo "Insert into Pi 3 and power on."