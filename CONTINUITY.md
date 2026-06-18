# CONTINUITY.md — Surviving Loss

## Principle
The civilization survives the loss of any single node.
Identity follows role. Role does not follow hardware.

## Current Redundancy Map

```
PHONE (48 GB free)
  └── Archive: KNOTS, MEMORY, INVENTORY, NODES, MODELS, PROCEDURES, LOGS
      └── Missing: images (7.8 GB each)

ADAM SSD (82 GB free)
  └── Tree: Images, Seeds, Scripts, Documentation
      └── Missing: KNOTS, MEMORY, INVENTORY (only in image seeds)

EVE SSD (unknown — unreachable)
  └── Unknown state
```

## Single Points of Failure

| Asset | Copies | Risk |
|-------|--------|------|
| Adam.img | 1 (Adam SSD) | HIGH — SSD failure = lost |
| Eve.img | 1 (Adam SSD) | HIGH — SSD failure = lost |
| KNOTS.md | 2 (phone + Adam) | LOW |
| MEMORY.md | 2 (phone + Adam) | LOW |
| INVENTORY.md | 2 (phone + Adam) | LOW |
| first-boot.sh (Adam) | 2 (phone + Adam) | LOW |
| first-boot.sh (Eve) | 2 (phone + Adam) | LOW |
| FLASHING.md | 2 (phone + Adam) | LOW |
| Build scripts | 1 (Adam SSD) | MEDIUM — rebuildable from docs |
| Base Raspios image | 1 (Adam SSD) | LOW — downloadable |

## Minimum Viable Continuity Kit

To survive total hardware loss, you need:
1. Adam.img.gz (1.7 GB)
2. Eve.img.gz (709 MB)
3. KNOTS.md (3.5 KB)
4. MEMORY.md (1.1 KB)
5. INVENTORY.md (839 B)
6. first-boot.sh for Adam (8.2 KB)
7. first-boot.sh for Eve (9.5 KB)
8. FLASHING.md (3.6 KB)
9. ROLE-MANIFEST.md (1.1 KB)

Total: ~2.4 GB + 20 KB documentation

This fits on any SD card, USB drive, or phone.

## What Would Be Lost

If Adam's SSD dies RIGHT NOW:
- ❌ Adam.img and Eve.img — NO COPY anywhere else
- ❌ Base Raspios image — downloadable but inconvenient
- ✅ All documentation — on phone
- ✅ All scripts — on phone
- ✅ All knots — on phone

If phone dies RIGHT NOW:
- ✅ Adam.img and Eve.img — on Adam's SSD
- ✅ All documentation — on Adam's SSD
- ✅ All scripts — on Adam's SSD
- ❌ Nothing critical lost

If BOTH die:
- ❌ Images lost (no third copy)
- ✅ Documentation recoverable from GitHub (ark-node repo)
- ✅ Images rebuildable from base Raspios + seed scripts

## Recommended Actions (Priority Order)

1. **Copy images to phone** — Eliminates single point of failure
2. **Copy images to SD card** — Physical off-site backup
3. **Upload to cloud** — Survives local disaster
4. **Physical boot test** — Validates images work on real hardware
5. **Recover Eve** — Restores archive redundancy

## Rebuilding from Scratch

If everything is lost:
1. Download Raspberry Pi OS Lite 64-bit
2. Follow FLASHING.md to flash base image
3. Copy seed packages from KNOTS.md, MEMORY.md, INVENTORY.md
4. Run first-boot scripts
5. Civilization restored

The Tree provides the seeds.
The seeds create the citizens.
The citizens create experience.
Experience becomes memory.
Memory becomes civilization.
