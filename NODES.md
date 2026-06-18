# NODES.md — Live Node Registry

**Date:** 2026-06-17
**Last updated:** 2026-06-17

---

## Active Nodes

| Node | Role | Device | IP | Status | Notes |
|------|------|--------|-----|--------|-------|
| galaxy-s22 | APERTURE | Galaxy S22 Ultra | (mobile) | ACTIVE | This device. Termux + Ollama |
| pi4-1 | CITY | RPi 4B 4GB | 10.98.79.63 | UNREACHABLE | AP mode, no upstream internet |
| aqua-1 | FORGE | X570 Aqua | 10.162.252.10 | STANDBY | PSU replacement arriving 2026-06-18 |
| gear-s3 | APERTURE | Gear S3 Frontier | 10.144.28.8 | STANDBY | Tizen, sdb daemon not running |
| zero-1 | ARK | Pi Zero W | (USB/AP) | ACTIVE | Portable, in Ark bag |

## Standby Nodes

| Node | Role | Device | IP | Status | Notes |
|------|------|--------|-----|--------|-------|
| zero-2 | ARK (backup) | Pi Zero W | (USB/AP) | STANDBY | Off-site |
| rpi3-{1-4} | CITY | RPi 3B+ | 10.162.252.x | ACTIVE (home) | 3D printing farm |
| ardrone-1 | SCOUT | AR Drone 2.0 | (WiFi direct) | STANDBY | Deployable |
| shield-1 | APERTURE | NVIDIA Shield | (home WiFi) | ACTIVE (home) | Living room |
| rampage-1 | FORGE | Rampage IV Gene | (ethernet) | STANDBY | In storage |

## Infrastructure

| Node | Role | Device | Status |
|------|------|--------|--------|
| switch-1 | TRADE ROUTE | Managed switch | ACTIVE (home) |
| router-1 | NAVIGATOR | Router | ACTIVE (home) |

---

## Known SSH Hosts

| IP | Fingerprint (ed25519) | Device |
|----|---------------------|--------|
| 172.28.100.63 | AAAAC3NzaC1lZDI1NTE5... | Pi 4 (home network) |
| 100.91.152.6 | AAAAC3NzaC1lZDI1NTE5... | Unknown (home network) |
| 10.59.213.63 | AAAAC3NzaC1lZDI1NTE5... | Unknown (home network) |
| 10.244.188.63 | AAAAC3NzaC1lZDI1NTE5... | Unknown (home network) |
| 10.162.252.63 | AAAAC3NzaC1lZDI1NTE5... | Unknown (home network) |
| 10.144.28.147:8022 | AAAAC3NzaC1lZDI1NTE5... | Gear S3 Frontier (Tizen) |

---

## Connectivity Map

```
[Internet] ←→ [router-1/NAVIGATOR]
                  ├── [switch-1/TRADE ROUTE]
                  │     ├── pi4-1 (CITY) — 10.98.79.63 (AP mode, isolated)
                  │     ├── aqua-1 (FORGE) — 10.162.252.10
                  │     ├── rpi3-{1-4} (CITY) — 3D printers
                  │     ├── shield-1 (APERTURE)
                  │     └── rampage-1 (FORGE) — standby
                  └── [WiFi] ←→ [galaxy-s22] (when on home network)

[galaxy-s22] ←→ [gear-s3] via WiFi Direct (10.144.28.x)
[galaxy-s22] ←→ [ardrone-1] via WiFi Direct (when deployed)
[galaxy-s22] ←→ [zero-1] via USB Ethernet or WiFi AP

CRITICAL GAP: Pi 4 AP has no upstream internet.
Phone loses cellular when connected to Pi AP.
This blocks remote access to Pi 4's Ollama instance.
```
