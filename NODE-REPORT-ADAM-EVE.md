# NODE REPORT — Adam and Eve
## Discovery Date: 2026-06-18

---

## ADAM (rpi4-1)

### Identity
- **Hostname:** rpi4-1
- **Role:** CITY (inferred — runs services, AP mode, DHCP server)
- **Hardware:** Raspberry Pi 4 Model B (4 GB RAM)
- **OS:** Debian 12 (bookworm), Kernel 6.12.87+rpt-rpi-v8, aarch64
- **Uptime:** 6h35m (as of 00:40 AKDT)
- **Load:** 0.96, 0.62, 0.38

### Network Interfaces
| Interface | IP | MAC | Role |
|-----------|-----|-----|------|
| lo | 127.0.0.1 | — | Loopback |
| eth0 | 10.42.0.1/24 (shared) | dc:a6:32:7f:95:76 | Ethernet hub (100M full) |
| eth0 (link-local) | 169.254.54.136/16 | dc:a6:32:7f:95:76 | — |
| wlan0 | 10.98.79.63/24 (DHCP) | dc:a6:32:7f:95:77 | WiFi AP (ScottNet) |

### Storage
| Device | Size | Type | Mount | Used |
|--------|------|------|-------|------|
| sda (SSD) | 465.8 GB | SSD | / (sda2) | 82% (354G/458G) |
| sda1 | 512 MB | SSD | /boot/firmware | 19% |
| mmcblk0 | 119.4 GB | SD card | /media/pi/ROOTFS | 12% (13G/118G) |
| mmcblk0p1 | 255 MB | SD card | /media/pi/BOOT | 34% |
| zram5 | 14.8 GB | RAM disk | /zram | 0% |

### Memory
- **Total:** 3.7 GB
- **Used:** 1.2 GB
- **Available:** 2.5 GB
- **Swap:** 14 GB (zram, 0% used)

### Running Services
| Service | Port | Notes |
|---------|------|-------|
| Ollama | 127.0.0.1:11434 | Qwen3:4B loaded, not serving |
| ADB | 127.0.0.1:5037 | Android debug bridge |
| Hermes Gateway | 127.0.0.1:8642 | AI agent gateway |
| SSH | 0.0.0.0:22 | OpenSSH |
| DNSMASQ | 10.42.0.1:53 | DHCP for eth0 subnet |
| DNSMASQ | 127.0.0.1:53 | Local DNS |
| kdeconnectd | *:1716 | KDE Connect |
| NetworkManager | — | Manages all connections |
| connman | — | Connection manager |
| lightdm | — | Display manager (GUI) |
| udisks2 | — | Disk manager |
| upower | — | Power management |

### AI Services
- **Ollama:** v0.23.2 installed, running
- **Models:** qwen3:4b (2.5 GB GGUF)
- **Status:** Model loaded but no active inference process
- **Hermes Gateway:** Running on port 8642

### Network Connections
- **ScottNet-AP:** WiFi AP on wlan0, SSID "ScottNet", WPA-PSK, channel auto
  - AP IP: 10.0.0.1/24 (configured in NM, but actual DHCP gives 10.98.79.x)
  - Phone connected at 10.98.79.83
- **preconfigured:** WiFi client, SSID "Galaxy S20 Ultra 5G 99b5" (phone's hotspot)
  - Gets IP via DHCP from phone
- **Wired connection 1:** eth0, shared mode, DHCP server for 10.42.0.10-254
- **IP Forwarding:** Enabled (1)

### Routing
```
0.0.0.0 dev eth0 scope link
default dev eth0 scope link
default via 10.98.79.83 dev wlan0 proto dhcp src 10.98.79.63 metric 600
10.42.0.0/24 dev eth0 scope link src 10.42.0.1
10.98.79.0/24 dev wlan0 scope link src 10.98.79.63
169.254.0.0/16 dev eth0 scope link src 169.254.54.136
```

### DNS
- Primary: 10.98.79.83 (phone)
- Secondary: 2600:381:920c:bc4d::1e (phone IPv6)

### Internet Access
- **NONE.** Ping to 8.8.8.8 fails. No upstream route.
- Default route points to phone (10.98.79.83) which doesn't forward.

### Key Observations
1. **Adam IS the Hub of Love.** It bridges WiFi (phone), Ethernet (hub), and runs services.
2. **Adam has the SSD.** 465 GB at 82% full. This is the primary storage node.
3. **Adam is a DHCP server** for both wlan0 (ScottNet AP) and eth0 (Ethernet hub).
4. **Adam's routing is broken** — default route goes to phone which doesn't NAT.
5. **10.144.28.x ARP entries on eth0** — these are mDNS/Bonjour broadcasts leaking from WiFi Direct through the hub. NOT Eve.
6. **Eve (rpi4-2) is NOT on the Ethernet hub.** Adam's /etc/hosts maps 10.144.28.228 to rpi4-2, but that IP is unreachable.

---

## EVE (rpi4-2)

### Identity
- **Hostname:** rpi4 2 (from Adam's /etc/hosts)
- **Role:** Unknown — currently unreachable
- **Hardware:** Raspberry Pi 4 Model B (assumed, same as Adam)
- **OS:** Unknown
- **Last seen:** 10.144.28.228 (WiFi Direct range)

### Status: UNREACHABLE
- Not responding to ping from phone or Adam
- Not on Ethernet hub (10.42.0.0/24)
- Not on Adam's WiFi AP (10.98.79.0/24)
- Not on WiFi Direct (10.144.28.0/24) from phone's perspective
- **Likely powered off or disconnected**

### What We Know
- Adam's /etc/hosts maps `10.144.28.228` to `rpi4-2`
- 10.144.28.x is the WiFi Direct subnet (Gear S3 uses 10.144.28.8)
- Eve may have been connected via WiFi Direct previously
- No SSH key or credentials known for Eve

### What We Don't Know
- Is Eve the other Pi 4?
- Does Eve have an SSD?
- What OS does Eve run?
- Is Eve powered on?
- What is Eve's actual current IP?

---

## SSD OWNERSHIP
**Adam owns the SSD.** 465 GB Samsung (or similar) at /dev/sda.
Eve's storage is unknown (not reachable).

---

## NETWORK TOPOLOGY — Current State

```
                    ┌─────────────────────────────────────┐
                    │            PHONE (S22 Ultra)         │
                    │  swlan0: 10.98.79.83                │
                    │  rmnet_data0: 10.36.156.7 (cellular)│
                    │  rmnet_data2: 10.60.202.118 (cell)  │
                    │  Role: APERTURE                      │
                    └──────────────┬──────────────────────┘
                                   │ WiFi (ScottNet AP)
                                   │
                    ┌──────────────▼──────────────────────┐
                    │          ADAM (rpi4-1)               │
                    │  wlan0: 10.98.79.63 (AP + client)   │
                    │  eth0:  10.42.0.1 (DHCP server)     │
                    │  SSD: 465 GB (82% full)              │
                    │  RAM: 3.7 GB                         │
                    │  Ollama: Qwen3:4B                    │
                    │  Hermes Gateway: port 8642           │
                    │  Role: CITY + Hub of Love            │
                    └──────────────┬──────────────────────┘
                                   │ Ethernet (100M)
                                   │
                    ┌──────────────▼──────────────────────┐
                    │       ETHERNET HUB/SWITCH            │
                    │  Subnet: 10.42.0.0/24                │
                    │  DHCP: Adam (10.42.0.10-254)         │
                    │  Connected devices: NONE              │
                    │  (Eve is NOT here)                    │
                    └─────────────────────────────────────┘

    EVE (rpi4-2) — 10.144.28.228 — UNREACHABLE
    Possibly on WiFi Direct or powered off
    No connection to Adam or Phone
```

---

## PHYSICAL MAP

```
[Phone] ←──WiFi──→ [Adam/Pi4-1] ←──Ethernet──→ [Hub/Switch]
                       │
                    [SSD]
                    [Ollama]
                    [Hermes]
                    
[Eve/Pi4-2] ←──???──→ [NOWHERE — ISOLATED]
```

---

## CIVILIZATION MAP

```
CIVILIZATION
│
├── TEMPLE (distributed)
│   └── Archive: ~/ARCHIVE/ on Phone
│       └── Backup target: Adam's SSD
│
├── ADAM [CITY + HUB OF LOVE]
│   ├── wlan0: ScottNet AP ← Phone
│   ├── eth0: Ethernet hub ← (empty)
│   ├── SSD: 465 GB (82% full)
│   ├── Ollama: Qwen3:4B
│   └── Hermes Gateway: port 8642
│
├── EVE [UNKNOWN — OFFLINE]
│   └── Last known: 10.144.28.228 (WiFi Direct)
│
├── PHONE [APERTURE]
│   ├── Cellular: 10.36.156.7 + 10.60.202.118
│   ├── WiFi: 10.98.79.83 (Adam's AP)
│   ├── Ollama: Qwen3:4B (not running)
│   └── Archive: ~/ARCHIVE/
│
├── AQUA X570 [FORGE] — FUTURE
│   └── Not yet connected to this network
│
└── HUB OF LOVE = ADAM
    ├── Bridges Phone ↔ Ethernet
    ├── Runs services (Ollama, Hermes, DNS, DHCP)
    ├── Stores data (SSD)
    └── Currently the center of the civilization
```

---

## RELATIONSHIPS

| From | To | Via | Status |
|------|-----|-----|--------|
| Phone | Adam | WiFi (ScottNet) | ACTIVE |
| Phone | Adam | SSH (10.98.79.63) | ACTIVE |
| Phone | Eve | — | NO ROUTE |
| Adam | Phone | WiFi | ACTIVE |
| Adam | Phone | SSH | ACTIVE |
| Adam | Eve | eth0 (10.144.28.228) | FAILED |
| Adam | Internet | — | NO ROUTE |
| Adam | Ethernet hub | eth0 | LINK UP, NO DEVICES |
| Eve | Anyone | — | ISOLATED |

---

## MISSING ROADS
1. Phone → Eve: No connection
2. Adam → Eve: ARP fails, host unreachable
3. Adam → Internet: No NAT from phone
4. Ethernet hub → Any device: Nothing connected except Adam
5. Eve → Any network: Unknown

---

## RECOMMENDATIONS

### Immediate
1. **Find Eve.** Check if powered on. Check if connected to Ethernet hub.
2. **If Eve is on the hub:** She should get 10.42.0.x from Adam's DHCP. SSH in.
3. **If Eve is on WiFi Direct:** Connect phone to Eve's WiFi Direct, then SSH.
4. **Fix internet routing:** Either enable NAT on phone, or add a router.

### Role Assignment
**Adam = CITY + GATEWAY** (confirmed)
- Already the hub. Runs services, bridges networks, has SSD.
- Best suited for: Archive storage, model serving, network hub.

**EVE = ARCHIVE + SEED VAULT** (proposed, once found)
- If Eve has her own storage, she becomes the backup Archive.
- If Eve has no SSD, she becomes a compute node (specialist).
- Either way, Eve should mirror Adam's Archive.

### Archive Storage
**Adam's SSD is the best current Archive location:**
- 465 GB (82% full = ~82 GB free)
- Always on, always reachable from phone via WiFi
- Can store models, logs, backups
- **Action:** Copy ~/ARCHIVE/ from phone to Adam's SSD

---

## KNOTS DISCOVERED

### Knot 5: The Hub of Love is a Role, Not a Device
Adam is currently the Hub because it bridges all networks. But the Hub is the *role* of connecting relationships. If Adam fails, the Hub dies with it — unless Eve can take over. **Redundancy requires at least two bridges.**

### Knot 6: ARP Flooding Reveals Hidden Networks
Adam's eth0 ARP table was flooded with 10.144.28.x addresses. These were mDNS/Bonjour broadcasts from WiFi Direct devices leaking through the Ethernet hub. This tells us: (a) the hub connects to something broadcasting mDNS, and (b) WiFi Direct and Ethernet are physically close.

### Knot 7: Shared Mode vs. NAT for Pi Ethernet
Adam's eth0 is configured as "shared" mode in NetworkManager. This means it runs dnsmasq and gives out 10.42.0.x addresses, but does NOT route to the internet. For Eve to get internet through Adam, Adam needs to NAT between wlan0 and eth0, and the phone needs to forward.

### Knot 8: The Phone is the DNS Server
Adam's resolv.conf points to 10.98.79.83 (phone) for DNS. The phone is running a DNS proxy. This means the phone is already acting as infrastructure — not just an APERTURE but also a NAVIGATOR for DNS.

### Knot 9: Two Cellular Interfaces
The phone has TWO cellular interfaces (rmnet_data0 at 10.36.156.7/28 and rmnet_data2 at 10.60.202.118/30). This is likely dual-SIM or carrier aggregation. Either could provide internet if routed properly.
