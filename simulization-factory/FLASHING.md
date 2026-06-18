# FLASHING.md — How to Create New Citizens

## Overview
This guide explains how to flash new Adam or Eve nodes from the Tree.

## Prerequisites
- A blank SD card (8 GB minimum, 16 GB recommended)
- A computer with an SD card reader
- The Tree (on Eve's SSD or copied to a local machine)

## Method 1: Using Raspberry Pi Imager (Recommended)

### Step 1: Download Raspberry Pi OS Lite
1. Download Raspberry Pi Imager from https://www.raspberrypi.com/software/
2. Select "Raspberry Pi OS Lite (64-bit)"
3. Click the gear icon to set:
   - Hostname: `adam` or `eve`
   - Enable SSH
   - Set username/password
   - Configure WiFi (if needed)
4. Write to SD card

### Step 2: Apply Seed Package
1. After flashing, mount the SD card
2. Copy the appropriate seed to the boot partition:
   - Adam: `TREE/Adam/first-boot.sh`
   - Eve: `TREE/Eve/first-boot.sh`
3. Create a marker file: `touch /boot/first-boot`

### Step 3: Boot
1. Insert SD card into the new node
2. Connect to network (Ethernet or WiFi)
3. Power on
4. First-boot script runs automatically
5. Node configures itself and joins the civilization

## Method 2: Using dd (Advanced)

### WARNING: Verify target device before writing!
```bash
# Find the SD card device
lsblk
# It will appear as something like /dev/sdb or /dev/mmcblk1

# Unmount if mounted
sudo umount /dev/sdX* 2>/dev/null

# Flash the image
sudo dd if=TREE/Images/Adam.img of=/dev/sdX bs=4M status=progress conv=fsync

# Verify
sudo dd if=/dev/sdX bs=4M count=$(stat -c%s TREE/Images/Adam.img | awk '{print int($1/4194304)+1}') | sha256sum
# Compare with TREE/Checksums/Adam.img.sha256
```

## Method 3: Flash from Eve Directly

### Prerequisites
- Eve must be running
- SD card inserted into Eve's SD card slot
- Image files on Eve's SSD

### Step 1: Verify the target
```bash
lsblk
# Identify the SD card device (NOT the internal mmcblk0)
# External SD will appear as /dev/mmcblk1 or /dev/sdX
```

### Step 2: Confirm before writing
```bash
# Check what's on the target
sudo fdisk -l /dev/sdX
# Verify it's the correct device and size
lsblk /dev/sdX
```

### Step 3: Flash
```bash
# Unmount
sudo umount /dev/sdX* 2>/dev/null

# Flash Adam
sudo dd if=/home/pi/TREE/Images/Adam.img of=/dev/sdX bs=4M status=progress conv=fsync

# OR Flash Eve
sudo dd if=/home/pi/TREE/Images/Eve.img of=/dev/sdX bs=4M status=progress conv=fsync
```

### Step 4: Verify
```bash
# Compare checksums
IMAGE="/home/pi/TREE/Images/Adam.img"
TARGET="/dev/sdX"
EXPECTED=$(cat /home/pi/TREE/Checksums/Adam.img.sha256)
ACTUAL=$(sudo dd if="$TARGET" bs=4M count=$(stat -c%s "$IMAGE" | awk '{print int($1/4194304)+1}') 2>/dev/null | sha256sum | awk '{print $1}')
if [ "$EXPECTED" = "$ACTUAL" ]; then
    echo "VERIFIED: Flash successful"
else
    echo "ERROR: Checksum mismatch"
fi
```

## Post-Flash

### First Boot
1. Insert the flashed SD card into the target Pi
2. Connect Ethernet (preferred) or WiFi
3. Power on
4. Wait 2-3 minutes for first-boot to complete
5. Find the node: `ping adam.local` or `ping eve.local`

### Verify
```bash
# SSH into the new node
ssh pi@adam.local  # or eve.local

# Check identity
cat ~/NODE-IDENTITY.json

# Check first-boot log
cat ~/first-boot-adam.log  # or first-boot-eve.log

# Run discovery
~/bin/discover-network.sh
```

## Troubleshooting

### Node doesn't boot
- Check SD card is properly seated
- Check power supply (5V 3A minimum)
- Check green LED activity

### Node not on network
- Check Ethernet cable
- Check WiFi configuration
- Run `check-connectivity.sh`

### First-boot didn't run
- Check for `first-boot` marker in /boot
- Check logs: `journalctl -u first-boot`
- Run manually: `sudo bash /boot/first-boot.sh`
