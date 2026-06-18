# NODES.md — Live Node Registry

**Date:** 2026-06-18
**Last updated:** 2026-06-18

---

## Active Nodes

| Node | Role | Device | Status | Notes |
|------|------|--------|--------|-------|
| galaxy-s22 | APERTURE | Galaxy S22 Ultra | ACTIVE | This device. Termux + Ollama |
| pi4-1 | CITY | RPi 4B 4GB | ACTIVE | ScottNet AP, Hub of Love |
| pi4-2 | ARCHIVE | RPi 4B | ACTIVE | Ethernet, newly discovered |
| aqua-1 | FORGE | X570 Aqua | STANDBY | PSU replacement pending |
| gear-s3 | APERTURE | Gear S3 Frontier | STANDBY | Tizen, sdb daemon not running |
| zero-1 | ARK | Pi Zero W | ACTIVE | Portable, in Ark bag |

## Standby Nodes

| Node | Role | Device | Status | Notes |
|------|------|--------|--------|-------|
| zero-2 | ARK (backup) | Pi Zero W | STANDBY | Off-site |
| rpi3-{1-4} | CITY | RPi 3B+ | ACTIVE (home) | 3D printing farm |
| ardrone-1 | SCOUT | AR Drone 2.0 | STANDBY | Deployable |
| shield-1 | APERTURE | NVIDIA Shield | ACTIVE (home) | Living room |
| rampage-1 | FORGE | Rampage IV Gene | STANDBY | In storage |

## Infrastructure

| Node | Role | Device | Status |
|------|------|--------|--------|
| switch-1 | TRADE ROUTE | Managed switch | ACTIVE (home) |
| router-1 | NAVIGATOR | Router | ACTIVE (home) |

---

## Connectivity Map

```
[Internet] ←→ [router-1/NAVIGATOR]
                  ├── [switch-1/TRADE ROUTE]
                  │     ├── pi4-1 (CITY) — ScottNet AP
                  │     ├── pi4-2 (ARCHIVE) — Ethernet
                  │     ├── aqua-1 (FORGE) — standby
                  │     ├── rpi3-{1-4} (CITY) — 3D printers
                  │     ├── shield-1 (APERTURE)
                  │     └── rampage-1 (FORGE) — standby
                  └── [WiFi] ←→ [galaxy-s22] (when on home network)

[galaxy-s22] ←→ [gear-s3] via WiFi Direct
[galaxy-s22] ←→ [ardrone-1] via WiFi Direct (when deployed)
[galaxy-s22] ←→ [zero-1] via USB Ethernet or WiFi AP
```

---

## Known SSH Hosts

| Device | Fingerprint (ed25519) |
|--------|---------------------|
| Pi 4 (home network) | AAAAC3NzaC1lZDI1NTE5... |
| Unknown (home network) | AAAAC3NzaC1lZDI1NTE5... |
| Unknown (home network) | AAAAC3NzaC1lZDI1NTE5... |
| Unknown (home network) | AAAAC3NzaC1lZDI1NTE5... |
| Unknown (home network) | AAAAC3NzaC1lZDI1NTE5... |
| Gear S3 Frontier (Tizen) | AAAAC3NzaC1lZDI1NTE5... |
