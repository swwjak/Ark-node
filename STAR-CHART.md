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
   │  (APERTURE)      │  │  (CITY+HUB)     │  │  (ARCHIVE)      │
   │                  │  │                 │  │                 │
   │ Ollama: Qwen3:4B │  │ Ollama: Qwen3:4B│  │ Status: ONLINE  │
   │ Archive: ~/ARCH/ │  │ SSD: 465GB      │  │ Storage: SSD    │
   │ Cellular: 2x IP  │  │ Hermes: :8642   │  │ Ethernet       │
   └────────┬─────────┘  └────────┬────────┘  └────────┬────────┘
            │                     │                    │
            │ WiFi (ScottNet)     │ Ethernet           │ Ethernet
            │                     │                    │
            └──────────┬──────────┘                    │
                       │                               │
              ┌────────▼───────────────────────────────▼──┐
              │              HUB OF LOVE = ADAM            │
              │                                            │
              │ Bridges: Phone ↔ Ethernet                   │
              │ Runs: Ollama, Hermes, DNS, DHCP             │
              │ Stores: SSD 465GB                           │
              └────────────────────────────────────────────┘

   ┌──────────────────┐     ┌──────────────────┐
   │  AQUA X570       │     │  ARCHIVE         │
   │  (FORGE)         │     │  (TEMPLE)        │
   │                  │     │                  │
   │ Status: STANDBY  │     │ Location: Phone  │
   │ PSU: pending     │     │ ~/ARCHIVE/       │
   │ 64GB RAM         │     │                  │
   │ 2x GTX 1080      │     │ Backup target:   │
   │ Ryzen 9 5900X    │     │ Adam's SSD       │
   └──────────────────┘     └──────────────────┘
```

## Relationship Matrix

| | Phone | Adam | Eve | Aqua | Archive |
|---|-------|------|-----|------|---------|
| **Phone** | — | WiFi+SSH | Ethernet | — | LOCAL |
| **Adam** | WiFi+SSH | — | Ethernet | — | CAN STORE |
| **Eve** | Ethernet | Ethernet | — | — | — |
| **Aqua** | — | — | — | — | — |
| **Archive** | LOCAL | CAN COPY | — | FUTURE | — |

## Active Roads
1. Phone ↔ Adam (WiFi, SSH, DNS) — WORKING
2. Adam ↔ Eve (Ethernet) — WORKING
3. Phone → Cellular (2x interfaces) — WORKING
4. Adam → Ethernet hub — LINKED

## Missing Roads
1. Adam → Internet — NO NAT
2. Aqua X570 → Any node — NOT CONNECTED
3. Archive → Adam's SSD — NOT YET COPIED

## Key Insight
**Adam IS the Hub of Love.** It bridges Phone ↔ Eve and runs all services. Eve provides archive redundancy on Ethernet.
