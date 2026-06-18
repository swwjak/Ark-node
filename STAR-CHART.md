# STAR CHART — Civilization Relationships
## Date: 2026-06-18

```
                         ┌──────────────────┐
                         │    CIVILIZATION   │
                         │  (relationships)  │
                         └────────┬─────────┘
                                  │
            ┌─────────────────────┼─────────────────────┐
            │                     │                     │
   ┌────────▼────────┐  ┌────────▼────────┐  ┌────────▼────────┐
   │     PHONE        │  │     ADAM        │  │     EVE         │
   │  (APERTURE)      │  │  (CITY+HUB)     │  │  (UNKNOWN)      │
   │                  │  │                 │  │                 │
   │ Ollama: Qwen3:4B │  │ Ollama: Qwen3:4B│  │ Status: OFFLINE │
   │ Archive: ~/ARCH/ │  │ SSD: 465GB      │  │ Last: .228      │
   │ Cellular: 2x IP  │  │ Hermes: :8642   │  │                 │
   │ DNS for Adam     │  │ DHCP: eth0+wlan │  │                 │
   └────────┬─────────┘  └────────┬────────┘  └─────────────────┘
            │                     │
            │ WiFi (ScottNet)     │ Ethernet (100M)
            │ 10.98.79.83→.63    │ 10.42.0.1
            │                     │
            └──────────┬──────────┘
                       │
              ┌────────▼─────────┐
              │   HUB OF LOVE    │
              │   = ADAM         │
              │                  │
              │ Bridges:         │
              │  Phone ↔ Ethernet│
              │ Runs: Ollama,    │
              │  Hermes, DNS,    │
              │  DHCP, ADB       │
              │ Stores: SSD 465GB│
              └──────────────────┘
                       │
              ┌────────▼─────────┐
              │  ETHERNET HUB    │
              │  10.42.0.0/24   │
              │  DHCP: Adam      │
              │  Devices: NONE   │
              │  (Eve not here)  │
              └──────────────────┘

   ┌──────────────────┐     ┌──────────────────┐
   │  AQUA X570       │     │  ARCHIVE         │
   │  (FORGE)         │     │  (TEMPLE)        │
   │                  │     │                  │
   │ Status: STANDBY  │     │ Location: Phone  │
   │ PSU: DOA→6/18    │     │ ~/ARCHIVE/       │
   │ 64GB RAM         │     │                  │
   │ 2x GTX 1080      │     │ Backup target:   │
   │ Ryzen 9 5900X    │     │ Adam's SSD       │
   └──────────────────┘     └──────────────────┘
```

## Relationship Matrix

| | Phone | Adam | Eve | Aqua | Archive |
|---|-------|------|-----|------|---------|
| **Phone** | — | WiFi+SSH | NO ROUTE | — | LOCAL |
| **Adam** | WiFi+SSH | — | FAILED | — | CAN STORE |
| **Eve** | — | — | — | — | — |
| **Aqua** | — | — | — | — | — |
| **Archive** | LOCAL | CAN COPY | — | FUTURE | — |

## Active Roads
1. Phone ↔ Adam (WiFi, SSH, DNS) — WORKING
2. Adam → Ethernet hub (link up) — NO DEVICES
3. Phone → Cellular (2x interfaces) — WORKING but not routed to Adam

## Missing Roads
1. Phone → Eve — NO ROUTE
2. Adam → Eve — HOST UNREACHABLE
3. Adam → Internet — NO NAT
4. Ethernet hub → Any device — EMPTY
5. Eve → Any network — ISOLATED
6. Aqua X570 → Any node — NOT CONNECTED
7. Archive → Adam's SSD — NOT YET COPIED

## Key Insight
**Adam IS the Hub of Love.** It is the only node that bridges multiple networks and runs services. If Adam fails, the civilization fragments. Eve's recovery is critical for redundancy.
