# FACES.md — The Visible Identity of Citizens

## Principle
A citizen should be recognizable at a glance.
Identity follows role. Role does not follow hardware.
The face reflects the role. The role reflects the purpose.

## Scale-Appropriate Faces

### Tiny House (1-2 nodes)
A light.
- On = alive
- Off = absent
- Blink = working

### Town (3-5 nodes)
A sign.
- Name
- Role
- Status (alive / unreachable / standby)

### City (6-20 nodes)
A map.
- All of the above
- Current activity
- Last event
- Connections

### Civilization (20+ nodes)
A story.
- All of the above
- History
- Patterns
- Dreams

## Current Scale: Tiny House → Town

We have 2-3 nodes. We need a sign, not a dashboard.

## The Face of Each Citizen

### ADAM (Explorer/Builder/Gateway)
```
  ╔══════════════════════════════╗
  ║  ADAM                        ║
  ║  Role: Explorer / Builder     ║
  ║  Status: 🟢 Alive             ║
  ║  Hub of Love                  ║
  ║  SSD: 465 GB (82% full)       ║
  ║  Ollama: Qwen3:4B             ║
  ║  Last: Factory built 2026-06  ║
  ╚══════════════════════════════╝
```

### EVE (Archivist/Librarian/Seed Vault)
```
  ╔══════════════════════════════╗
  ║  EVE                         ║
  ║  Role: Archivist / Librarian  ║
  ║  Status: 🔴 Unreachable       ║
  ║  Last seen: 10.144.28.228     ║
  ║  Storage: unknown             ║
  ║  Last: Disconnected 2026-06   ║
  ╚══════════════════════════════╝
```

### PHONE (Aperture)
```
  ╔══════════════════════════════╗
  ║  PHONE (S22 Ultra)           ║
  ║  Role: Aperture              ║
  ║  Status: 🟢 Alive             ║
  ║  Archive carrier              ║
  ║  Cellular: 2x IP              ║
  ║  Ollama: Qwen3:4B (loaded)    ║
  ║  Last: Image backup 2026-06  ║
  ╚══════════════════════════════╝
```

### AQUA X570 (Forge) — Future
```
  ╔══════════════════════════════╗
  ║  AQUA X570                   ║
  ║  Role: Forge                 ║
  ║  Status: 🟡 Standby           ║
  ║  PSU: Replacement pending     ║
  ║  Specs: 64GB RAM, 2x 1080    ║
  ║  Last: PSU DOA 2026-06-17    ║
  ╚══════════════════════════════╝
```

## LED Language (for future hardware)

| Pattern | Meaning |
|---------|---------|
| Solid on | Alive, idle |
| Slow pulse | Alive, working |
| Rapid pulse | Active task |
| Double blink | Communicating |
| Long blink | Waiting for something |
| Red | Attention required |
| Dark | Sleeping or absent |

## Implementation

### Phase 1: Static Face (now)
Each citizen has a text-based face file.
On boot, the node displays its face.
A traveler can `cat ~/FACE.md` to see identity.

### Phase 2: Live Face (when network works)
Each citizen runs a simple HTTP server serving their face.
A traveler can `curl http://adam.local/face` to see status.

### Phase 3: Signal Face (when hardware supports it)
Each citizen has an LED.
The LED pattern communicates state without any text.

## The Rule
Before adding complexity to a face, ask:
- Can a light communicate this?
- Can a symbol communicate this?
- Can a face communicate this?
- Can complexity be reduced?

The goal is not appearance.
The goal is recognition.
