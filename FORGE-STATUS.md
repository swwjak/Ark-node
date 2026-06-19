# FORGE-STATUS.md — Hardware Assessment

## Date: 2026-06-18

## Verdict: Neither platform is economically repairable. Build Forge 2.0 on AM5.

---

## ASRock X570 Aqua — DEAD

### History
- SATA data cable smoked along entire length → first SSD destroyed
- Second SSD destroyed on another SATA port
- System ran from NVMe after that
- Eventually became completely unresponsive
- Tested with new Corsair 1200W PSU — no change

### Current Status
- No standby power
- No debug display
- No visible signs of life
- Motherboard highly suspect — likely electrical damage

### Assessment
- Motherboard suffered electrical damage from SATA short
- Not economically repairable
- Replacement X570 boards expensive and scarce

---

## ASUS Rampage IV Gene — PARTIALLY ALIVE, NOT WORTH REPAIRING

### History
- Originally built by Scott, GTX 670
- Sat unused 2+ years
- Mouse damage during storage — chewed PSU modular cables
- Replacement PSU and CMOS battery installed

### POST Sequence Observed
```
Unknown code → 14 → 0C → STOPS
```

### What This Means
- Board is NOT electrically dead
- CPU is executing BIOS code
- POST progresses to code 0C (early initialization)
- Failure during CPU/memory subsystem initialization

### Likely Causes
1. LGA2011 socket pin issue
2. CPU memory controller failure
3. Motherboard memory circuitry failure
4. Age-related motherboard degradation

### Assessment
- Further diagnosis not worthwhile
- Repair effort exceeds board value
- X79 platform is end-of-life

---

## FORGE 2.0 — RECOMMENDED PATH

### Reuse (Known Good)
| Component | Status | Value |
|-----------|--------|-------|
| Corsair 1200W PSU | New, tested | ~$200 |
| RTX 2070 Super | Known good | ~$300 |
| GTX 1080 #1 | Known good | ~$100 |
| GTX 1080 #2 | Known good | ~$100 |
| NVMe drives | Known good | ~$150 |
| LoRa hardware | Known good | — |
| Peripherals | Known good | — |

### New Components Needed
| Component | Est. Cost | Notes |
|-----------|-----------|-------|
| AM5 motherboard | $200-350 | B650 or X670 |
| Ryzen 7000 CPU | $250-400 | 7700X or 7800X3D |
| DDR5 RAM | $100-200 | 32-64GB |
| **Total new** | **$550-950** | |

### Strategy
Build incrementally. Start with motherboard + CPU + RAM. Add GPUs later. Reuse PSU, storage, and all peripherals from dead platforms.

---

## PRINCIPLE

"Do not spend significant money repairing either platform."

The dead platforms are lessons, not foundations. Forge 2.0 builds on what was learned, not what was broken.
