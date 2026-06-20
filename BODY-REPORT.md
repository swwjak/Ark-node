# BODY-REPORT.md — What the Hardware Naturally Supports

## Date: 2026-06-19

---

## Adam (Pi 4B)

### Body
- **CPU:** 4 cores, 50.6°C, load 0.36
- **RAM:** 3.7GB total, 935MB used, 3.0GB free
- **Storage:** 458GB SSD, 86% used (367GB), 63GB free
- **Uptime:** 22 hours

### What the body says
- **Strength:** Reasoning (Ollama running, 0.6% CPU)
- **Strength:** Voice (espeak-ng working)
- **Strength:** Printing (CUPS configured, HP M207 working)
- **Friction:** Desktop environment running (labwc, Xwayland, snap packages consuming 4.1% RAM)
- **Friction:** 86% storage used — mostly OS and snaps, not library
- **Friction:** SSD is both body and library — can't separate

### Natural role
**Thinker + Scribe.** Adam reasons, speaks, and prints. He should NOT be a desktop. He should NOT be the library. He should be portable.

### What needs to happen
1. Remove desktop environment (labwc, Xwayland, snaps)
2. Migrate to USB boot drive
3. Free SSD for library

---

## Eve (Pi 4B)

### Body
- **CPU:** 4 cores, 57.0°C, load 1.06
- **RAM:** 3.7GB total, 418MB used, 2.3GB free
- **Storage:** 59GB SD, 50% used (21GB), 28GB free
- **Uptime:** 20 hours
- **USB:** 3x SanDisk Cruzer Fit (30GB each) + Logitech receiver + Ethernet adapter

### What the body says
- **Strength:** Voice (espeak-ng working)
- **Strength:** USB host (3 drives connected, all recognized)
- **Strength:** Flash station (Forge Console running, dd works)
- **Friction:** Desktop environment running (labwc, Xwayland consuming 4.7% RAM combined)
- **Friction:** Face display service running but not showing (no DSI display working)

### Natural role
**Voice + Flash Station.** Eve speaks and writes images to USB drives. She has the USB ports and the patience for long writes.

### What needs to happen
1. Remove desktop environment
2. Keep Forge Console running (it's useful)
3. Use USB drives for Pi 3 boot media

---

## Printer (HP LaserJet M207-M212)

### Body
- **Connection:** USB only (no Wi-Fi, no Ethernet)
- **Capabilities:** Print (working via CUPS)
- **Scanner:** Unsupported by HPLIP 3.2.10

### What the body says
- **Strength:** Produces physical documents
- **Limitation:** USB-only means it needs a host
- **Limitation:** Scanner doesn't work on this hardware

### Natural role
**Scribe.** The printer writes. It needs a host (Adam or any Pi). It cannot be independent.

---

## Router (Netgear, at home)

### Body
- **Status:** Unreachable (on home network)
- **USB:** 1 port (for SSD)
- **Role:** Roads + Library + Public Services

### What the body says
- **Strength:** Central location, always on, network hub
- **Limitation:** Only 1 USB port — must choose between SSD (library) and nothing else

### Natural role
**Roads + Library.** The router connects everyone. The SSD on the router becomes the public library.

---

## Summary: What Each Body Wants to Become

| Body | Natural Role | Friction to Remove |
|------|-------------|-------------------|
| Adam | Thinker + Scribe | Desktop env, SSD dependency |
| Eve | Voice + Flash Station | Desktop env, face display |
| Printer | Scribe (USB peripheral) | Needs host |
| Router | Roads + Library | SSD not yet moved |
| Pi 3s (4x) | Workers (unassigned) | Need SD cards flashed |
| Watch | Watcher | Bridge app needed |
| Drone | Scout | Needs charging, testing |

---

## Principle

The body is not a limitation. The body is information.

Adam's body says: "I can think and print, but I'm carrying too much weight."
Eve's body says: "I can speak and write, but I'm running a desktop I don't need."
The printer's body says: "I can write, but I need a host."
The router's body says: "I can connect everyone, but I need memory."

Listen to the body. Remove the friction. Let each citizen become what it naturally is.
