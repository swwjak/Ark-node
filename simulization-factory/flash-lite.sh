#!/bin/bash
# flash-lite.sh — Flash Raspberry Pi OS Lite to SD card
# Run on phone with SD card inserted via OTG

set -e

echo "=== Raspberry Pi OS Lite Flasher ==="
echo "Date: $(date)"

# Check for SD card
echo ""
echo "--- Detecting SD card ---"
lsblk -o NAME,SIZE,TYPE,TRAN -d 2>/dev/null | grep -E "mmc|sd"
echo ""
echo "Which device is the SD card? (e.g., /dev/sdb or /dev/mmcblk1)"
echo "DO NOT select the phone's internal storage."
read -p "SD card device: " SD_DEV

if [ -z "$SD_DEV" ]; then
    echo "No device specified. Exiting."
    exit 1
fi

# Confirm
echo ""
echo "WARNING: This will ERASE all data on $SD_DEV"
read -p "Type YES to continue: " CONFIRM
if [ "$CONFIRM" != "YES" ]; then
    echo "Aborted."
    exit 1
fi

# Download base image
IMAGE_URL="https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios-bookworm-arm64-lite/2025-05-03/2025-05-03-raspios-bookworm-arm64-lite.img.xz"
IMAGE_FILE="/sdcard/Download/raspios-lite.img.xz"

echo ""
echo "--- Downloading Raspberry Pi OS Lite ---"
if [ ! -f "$IMAGE_FILE" ]; then
    wget -O "$IMAGE_FILE" "$IMAGE_URL" 2>&1 | tail -3
else
    echo "Image already downloaded: $(ls -lh $IMAGE_FILE | awk '{print $5}')"
fi

# Unmount any existing partitions
echo ""
echo "--- Unmounting ---"
sudo umount ${SD_DEV}* 2>/dev/null || true

# Flash
echo ""
echo "--- Flashing to $SD_DEV ---"
echo "This will take 5-15 minutes..."
sudo dd if="$IMAGE_FILE" of="$SD_DEV" bs=4M status=progress conv=fsync 2>&1

echo ""
echo "=== Flash complete ==="
echo "Insert SD card into Pi and boot."
echo "Default user: pi / raspberry"
echo "Enable SSH: create empty 'ssh' file in boot partition"