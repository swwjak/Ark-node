# CIVILIZATION.md — The Living System

## Principle
The citizen returns wiser, not larger.
The goal is improvement of capability, not growth of size.

---

## Current Population

Two citizens. Two dwellings. One road between them.

```
ADAM                          EVE
┌──────────────┐              ┌──────────────┐
│ Conscious    │              │ Conscious    │
│ Qwen3:4B     │              │ Qwen3:4B     │
│              │              │              │
│ Subconscious │              │ Subconscious │
│ ❌ (no Forge) │              │ ❌ (no Forge) │
│              │              │              │
│ Hermes       │              │ Hermes       │
│ ❌            │              │ ❌            │
└──────┬───────┘              └──────┬───────┘
       │                             │
       │  Ethernet (10.42.0.x)       │
       │  ✅ pingable                │
       │  ❌ SSH blocked             │
       │                             │
       └──────────┬──────────────────┘
                  │
            ┌─────▼─────┐
            │  ARCHIVE   │
            │  (shared?) │
            └───────────┘
```

---

## Knowledge Transfer

Citizens learn:
- Better predictions
- Better responses
- Better summaries
- Better planning
- Better communication

Knowledge must be compressed to fit the resident's dwelling.
A Pi Zero citizen should not become a giant model.
A Pi Zero citizen should become a better Pi Zero citizen.

---

## Structure

```
EXPERIENCE                    KNOWLEDGE
(flows upward)               (flows downward)

Dwellings                    Schools
┌──────────┐                ┌──────────┐
│ Adam     │ ──experience──→│  Forge   │ ❌ DEAD
│ Pi 4     │                │  (build  │
│          │                │   2.0)   │
│ Eve      │ ──experience──→│          │
│ Pi 4     │                │          │
└──────────┘                └──────────┘
     ↑                            │
     └────── knowledge ───────────┘
            (not yet wired)
```

---

## Components

### Citizens
- **Conscious** — perceives, decides, acts
- **Subconscious** — remembers, learns, plans
- **Hermes** — coordinates, migrates, executes

### Current Citizens

| | Adam | Eve |
|---|---|---|
| **Role** | Explorer/Builder/Gateway | Archivist/Librarian/Seed Vault |
| **Dwellings** | Pi 4 (10.98.79.63) | Pi 4 (10.42.0.152) |
| **Conscious** | Qwen3:4B ✅ | Qwen3:4B ✅ |
| **Subconscious** | ❌ No Forge | ❌ No Forge |
| **Hermes** | ❌ | ❌ |
| **Storage** | 465GB SSD (87% used) | 465GB SSD (82% used) |
| **Ollama** | Running, model loaded | Running, model loaded |
| **Hermes Gateway** | :8642 ✅ | :8642 ✅ |
| **SSH** | Active ✅ | Active ✅ |
| **Internet** | ❌ No NAT | ❌ No route |

### Roads
| Road | Status | Notes |
|------|--------|-------|
| Phone ↔ Adam | ✅ | WiFi (ScottNet) |
| Adam ↔ Eve | ⚠️ | Ping works, SSH blocked |
| Phone ↔ Eve | ❌ | Different subnets, no route |
| Adam → Internet | ❌ | Phone doesn't NAT |
| Eve → Internet | ❌ | No default route |

### Schools
- Forge: ❌ DEAD (X570 electrical damage)
- Forge 2.0: 📋 PLANNED (AM5, reuse PSU + GPUs)

### Libraries
- Archive: ✅ On phone (22 files)
- Tree: ✅ On Adam SSD (13GB)
- GitHub: ✅ swwjak/ark-node (private)

---

## The Exchange

**Small systems provide experience.**
**Large systems provide education.**
**Civilization emerges from the exchange between the two.**

Experience flows upward.
Knowledge flows downward.

**Current reality:** Experience is not flowing. Adam and Eve generate no experience because they have no roles, no tasks, no users. They are idle.

---

## What Happens If

### Adam Disappears Tonight
- Eve continues running (idle, no change)
- Phone Archive survives ✅
- GitHub repo survives ✅
- Tree on Adam SSD: ❌ LOST
- Images: ✅ Survive on phone
- **Recovery:** Flash Adam.img on new Pi, restore from GitHub. ~30 minutes.

### Eve Disappears Tonight
- Adam continues running (idle, no change)
- Phone Archive survives ✅
- GitHub repo survives ✅
- **Recovery:** Flash Eve.img on new Pi. ~30 minutes.
- **Impact:** None. Eve contributes nothing currently.

### Both Disappear Tonight
- Phone Archive survives ✅
- GitHub repo survives ✅
- Images on phone survive ✅
- **Recovery:** Flash both images, restore from GitHub. ~1 hour.
- **Impact:** Total hardware loss, zero knowledge loss.

### Scott Disappears for 7 Days
- Adam: Runs indefinitely (load 0.00, stable)
- Eve: Runs indefinitely (same)
- Phone: Dies in ~2 days without charging
- **After Phone dies:** Adam and Eve continue running. No one can interact with them. No experience generated. No learning. Static.
- **After 7 days:** Plug in phone, everything resumes. No data lost.

---

## The Purpose

The purpose of civilization is growth.

Not growth of size. Growth of capability.

A Pi Zero that predicts battery failure 3 days in advance is more valuable than a Pi 4 that can't.

A citizen that knows its dwelling deeply is more valuable than a citizen that knows everything shallowly.

**Depth over breadth. Wisdom over size. Capability over complexity.**

---

## Current Reality

Two idle machines on a shelf. They run models, serve no one, learn nothing, produce nothing. They are not yet citizens. They are hardware waiting for purpose.

The next step is not more architecture. It is giving them something to do.
