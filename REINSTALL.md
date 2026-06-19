# REINSTALL.md — Clean OS Reinstall for Both Pis

## What Needs to Happen

Both Pis need fresh Raspberry Pi OS Lite installs. Their current installs are messy — wrong passwords, no SSH trust, different subnets, no coordination.

## What Scott Needs at Home

1. A computer with an SD card reader
2. Two SD cards (or re-use existing ones)
3. Raspberry Pi Imager (https://www.raspberrypi.com/software/)

## Steps (5 minutes per Pi)

### 1. Flash Pi OS Lite
1. Download Raspberry Pi Imager
2. Select "Raspberry Pi OS Lite (64-bit)"
3. Click gear icon:
   - Hostname: `adam` (first Pi) or `eve` (second Pi)
   - Enable SSH (password auth)
   - Username: `pi`
   - Password: `kootznoowoo` (same for both)
   - Configure WiFi: SSID `ScottNet`, password `sc0ttnet`
4. Write to SD card

### 2. Boot and Find IP
1. Insert SD card, power on
2. Wait 2 minutes
3. Find IP: check router DHCP table, or `ping adam.local` / `ping eve.local`

### 3. Exchange SSH Keys
From Adam:
```bash
ssh-copy-id pi@eve.local
```
From Eve:
```bash
ssh-copy-id pi@adam.local
```

### 4. Test
```bash
# From Adam:
ssh pi@eve.local "echo OK; hostname"
# From Eve:
ssh pi@adam.local "echo OK; hostname"
```

### 5. Set Static IPs (optional but recommended)
Edit `/etc/dhcpcd.conf` on both:
```
interface wlan0
static ip_address=10.98.79.10/24
static routers=10.98.79.83
static domain_name_servers=8.8.8.8
```
(Use .10 for Adam, .11 for Eve)

### 6. Install Ollama (optional)
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3:4b
```

## After Reinstall

Both Pis will be:
- Same OS (fresh)
- Same password (kootznoowoo)
- Same WiFi (ScottNet)
- SSH trust established
- Able to ping each other
- Ready to become Adam and Eve

## Current Image

The base image is already on the phone:
`/sdcard/Download/2025-05-13-raspios-bookworm-arm64.img.xz` (1.2 GB)

This can be flashed directly with `dd` if you have a USB SD card reader:
```bash
xz -d -c /sdcard/Download/2025-05-13-raspios-bookworm-arm64.img.xz | sudo dd of=/dev/sdX bs=4M status=progress
```
