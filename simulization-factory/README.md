# Simulization Factory

## What This Is
A reproducible system for creating new Adam and Eve citizens from blank SD cards.
The Tree on Eve's SSD stores all images, seeds, and documentation.

## Tree Location
`/home/pi/TREE/` on Eve (10.98.79.63)

## Golden Images
- Adam.img — 7.8 GB (1.7 GB gzipped) — Explorer/Builder/Gateway
- Eve.img — 7.8 GB (709 MB gzipped) — Archivist/Librarian/Seed Vault

## Quick Start
```bash
# Flash Adam to SD card
sudo dd if=/home/pi/TREE/Images/Adam.img of=/dev/sdX bs=4M status=progress conv=fsync

# Flash Eve to SD card
sudo dd if=/home/pi/TREE/Images/Eve.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## Documentation
- ROLE-MANIFEST.md — Role definitions and principles
- FIRST-BOOT.md — What happens on first boot
- FLASHING.md — Complete flashing guide
- KNOTS.md — 10 reusable patterns
- MEMORY.md — Civilization memory
- INVENTORY.md — Hardware/software inventory

## Build from Scratch
If the images are lost, rebuild from the base Raspios image:
1. Download Raspberry Pi OS Lite 64-bit
2. Place in /home/pi/TREE/Seeds/
3. Run: bash /home/pi/TREE/Scripts/build-all.sh

## Design Principles
- Start clean. Preserve roles. Preload capability.
- Verify before flashing. Document every command.
- The Tree exists before the citizens.
- Citizens are temporary. Roles are persistent.
