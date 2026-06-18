# ARCHIVE — Local AI Civilization

**Created:** 2026-06-17
**Updated:** 2026-06-18
**Location:** ~/ARCHIVE/ on Phone + /home/pi/TREE/ on Eve's SSD

---

## What This Is

The Archive is the preserved memory of the civilization.
It contains everything needed to understand, reproduce, and grow the civilization.

## Structure

### On Phone (~/ARCHIVE/)
```
ARCHIVE/
├── README.md              ← You are here
├── KNOTS.md               — 5 Articles + 10 reusable patterns
├── NODES.md               — Live node registry
├── MODELS.md              — Model catalog + benchmarks
├── INVENTORY.md           — Hardware/software inventory
├── NODE-REPORT-ADAM-EVE.md — Adam & Eve discovery report
├── STAR-CHART.md          — Civilization relationship map
├── PROCEDURES.md          — Recovery and maintenance
├── LOG/                   — Daily logs
│   ├── 2026-06-17.md
│   └── 2026-06-18.md
└── simulization-factory/  — Image factory documentation
    ├── README.md          — Factory overview
    ├── ROLE-MANIFEST.md   — Role definitions
    ├── FIRST-BOOT.md      — First boot behavior
    ├── FLASHING.md        — How to flash new citizens
    ├── adam/              — Adam seed package
    │   └── first-boot.sh
    ├── eve/               — Eve seed package
    │   └── first-boot.sh
    └── archive-seed/      — Archive templates
        ├── KNOTS.md
        ├── MEMORY.md
        └── INVENTORY.md
```

### On Eve's SSD (/home/pi/TREE/)
```
TREE/
├── Adam/first-boot.sh      — Adam first-boot automation
├── Eve/first-boot.sh       — Eve first-boot automation
├── Images/
│   ├── Adam.img            — 7.8 GB (1.7 GB gzipped)
│   ├── Adam.img.gz
│   ├── Eve.img             — 7.8 GB (709 MB gzipped)
│   └── Eve.img.gz
├── Archive/
│   ├── MEMORY.md
│   └── INVENTORY.md
├── Knots/KNOTS.md          — 10 reusable patterns
├── Seeds/
│   └── base-raspios.img.xz — 1.2 GB base image
├── Checksums/
│   ├── Adam.img.sha256
│   └── Eve.img.gz.sha256
├── Scripts/                — Build and utility scripts
├── Documentation/
│   ├── ROLE-MANIFEST.md
│   ├── FIRST-BOOT.md
│   └── FLASHING.md
└── Log/                    — Build logs
```

## Current State

### Nodes
| Node | Role | Status |
|------|------|--------|
| Phone (S22) | APERTURE | ACTIVE |
| Eve (rpi4-1) | ARCHIVE | ACTIVE — SSD at 10.98.79.63 |
| Adam (rpi4-2) | EXPLORER | UNREACHABLE — last seen 10.144.28.228 |
| Aqua X570 | FORGE | STANDBY — PSU replacement pending |

### Models
- Local: Qwen3:4B Q3_K_M (2.5 GB) — 4-5 tok/s on ARM CPU
- Cloud: owl-alpha via OpenRouter

### Images
- Adam.img: 7.8 GB (1.7 GB gzipped) — SHA256: c5df69bb...917931
- Eve.img: 7.8 GB (709 MB gzipped) — SHA256: 3b486f38...72cb2a1

## How to Create a New Citizen

1. Insert blank SD card into Eve
2. Run: `lsblk` (identify device)
3. Flash: `sudo dd if=/home/pi/TREE/Images/Adam.img of=/dev/sdX bs=4M status=progress`
4. Boot the Pi
5. First-boot runs automatically
6. Node joins civilization

## Design Principles

1. Nodes are temporary. Roles are persistent.
2. The Archive survives any single node failure.
3. Prefer working solutions over theoretical perfection.
4. Prefer simple specialists over giant general systems.
5. Preserve knots over preserving facts.
6. Verify before flashing. Document every command.
7. The Tree exists before the citizens.
