# PROCEDURES.md — Verification and Recovery

## Verification Procedures

### V1: Verify Image Integrity
```bash
# On Adam or any Pi with the Tree
cd /home/pi/TREE

# Check Adam.img
sha256sum Images/Adam.img
cat Checksums/Adam.img.sha256
# Compare — must match

# Check Eve.img
sha256sum Images/Eve.img
cat Checksums/Eve.img.sha256
# Compare — must match
```

### V2: Verify Image Structure
```bash
# Mount Adam.img
LOOP=$(sudo losetup --find --show --partscan Images/Adam.img)
sudo mount ${LOOP}p2 /mnt/test

# Check key files
ls /mnt/test/home/pi/first-boot.sh
ls /mnt/test/boot/first-boot
ls /mnt/test/boot/ssh
cat /mnt/test/etc/hostname  # Should be "adam"

sudo umount /mnt/test
sudo losetup -d $LOOP
```

### V3: Verify Boot
```bash
# Flash to SD card
sudo dd if=Images/Adam.img of=/dev/sdX bs=4M status=progress conv=fsync

# Insert into Pi, power on, wait 2 minutes
# Then from another node:
ssh pi@adam.local "cat ~/NODE-IDENTITY.json"
# Should show: {"role": "adam", ...}
```

## Recovery Procedures

### R1: Adam Fails
1. Flash Adam.img to blank SD card
2. Boot new Pi
3. First-boot runs automatically
4. Adam rejoins civilization
5. No data lost (Archive on Tree)

### R2: Eve Fails
1. Flash Eve.img to blank SD card
2. Boot new Pi
3. First-boot runs automatically
4. Eve rejoins civilization
5. Archive syncs from Adam

### R3: Adam's SSD Fails
1. Replace SSD on Adam
2. Flash new SD with Raspberry Pi OS Lite
3. Install image tools: sudo apt-get install -y parted fdisk dosfstools e2fsprogs
4. Download base Raspios image
5. Run: bash /home/pi/TREE/Scripts/build-all.sh
6. Restore Tree from phone backup (if available)

### R4: Total Loss (Only Tree Survives)
1. Connect to Adam's SSD via USB on any computer
2. Copy Tree/ to local storage
3. On new Pi: flash Adam.img or Eve.img
4. Boot new nodes
5. Copy Tree/ back to new SSD
6. Civilization restored

### R5: Total Loss (Only Phone Survives)
1. Phone has Archive at ~/ARCHIVE/
2. Download fresh Raspberry Pi OS Lite
3. Follow FLASHING.md to create new images
4. Build new Tree on new SSD
5. Civilization restored (minus build scripts)

## First-Boot Logs
After first-boot, check:
```bash
cat ~/first-boot-adam.log  # or first-boot-eve.log
journalctl -u first-boot.service
```

## Network Map
```
Phone (10.98.79.83) ←→ Adam (10.98.79.63, 10.42.0.1)
                           ↕
                    Ethernet Hub (empty)
                           ↕
                    Eve (UNKNOWN - last seen 10.144.28.228)
```

## Known Knots
See KNOTS.md for full list of 10 knots and 5 articles.
