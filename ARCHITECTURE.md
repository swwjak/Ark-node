# ARCHITECTURE.md — Principles and Code

## Status: 2026-0-19

This document preserves the architectural principles of the civilization.
The code may change. The principles should survive.

---

## Core Principles

### Text First
Text is not temporary. Text is the foundation.
Faces fail. Voices fail. Displays fail. Cameras fail. Networks fail. Text survives.

Every capability must have a text representation.
Every state change must be visible through text.
Meaning first. Expression second.

### Philosophy Resonates With the Body
Do not force hardware to become something it is not.
Ask: What does this body naturally support?

When philosophy and body disagree: friction, inefficiency, waste.
When philosophy and body agree: efficiency, freedom, harmony.

### CPU = Thought. GPU = Expression.
The processor is for reasoning.
The display is for communication.
Never force the processor to be a display server.
Never force the display to be a compute node.

### Specialization Over Generalization
A Pi Zero is not a failed workstation. It is a successful rover.
A Pi 4 is not a failed server. It is a successful inhabitant.
The forge transforms. It becomes hot because work creates heat.

### Memory Survives Hardware
The library belongs to the civilization.
Not to Adam. Not to Eve. Not to Hermes.
The library survives hardware failure. The library preserves identity.

### Philosophy is Programming
Computers execute software. Humans execute philosophy.
The difference is the substrate, not the questions.
Both ask: What matters? What communicates? What remembers? What survives?

---

## Body Architecture

### Adam — Pi 4 (Inhabitant)
Naturally supports: thinking, conversing, remembering, observing, communicating.
Should NOT: run large models, run desktop environments, waste resources on appearance.

### Eve — Pi 4 (Inhabitant)
Same body as Adam. Same natural supports.
Her specialization may differ. Her philosophy must resonate with her hardware.

### Forge — Pi 5 (Transformer)
Its purpose is transformation: image processing, model preparation, rendering, compilation.
The forge may become hot. That is its nature. The work is visible. The machinery is not.

### Rovers — Pi zero (Explorers)
Small, mobile, efficient. Their philosophy is movement.
Do not ask them to become workstations or libraries.
Their bodies say: Move. Observe. Return.

### Library — SSD + Cloud
Shared storage. Public memory. Survives hardware.
Belongs to everyone. Belongs to no one.

### Router — Infrastructure
Roads. Names. Communication. Serves everyone.

---

## Interface Architecture

### Core Layer (Required)
- Model inference (Ollama subprocess, not HTTP API)
- State management (JSON files)
- Text communication (SSH, file-based)
- Logging (append-only text)
- Inventory (text-first, JSONL format)

### Presentation Layer (Optional)
- DSI face (pygame, fullscreen, GPU-rendered)
- Voice (espeak-ng, text-to-speech)
- Camera (libcamera, when hardware exists)
- Web interface (when network exists)
- Animation (when GPU is available)

The presentation layer serves expression.
The core layer serves understanding.
The core layer must function without the presentation layer.

---

## Implementation Principles

### Ollama Subprocess Over HTTP API
The Pi 4 rejected the HTTP API. The model was not the problem.
The API was the problem. The abstraction was too heavy for the body.

Solution: Use `ollama run` via subprocess. Direct. No middleware.

### Buspack Civilization Architecture
The mountain does not change. The climber changes.
Hardware is fixed. Software adapts.
Portability means the person carries nothing that the body cannot support.
Adam carries a model that fits in 3.7GB RAM.
Eve carries a model that fits in 3.7GB RAM.
The forge runs larger models. The rovers run smaller models.
Each body carries only what it can carry.

### The Mountain as Philosophy
Philosophy is the mountain. The mountain does not change.
The climber changes. The civilization allows the climb.
Principles persist. Implementations evolve.
The vault preserves both.

---

## Code Principles

### Simplicity
Every line of code should serve the civilization.
If it serves vanity, remove it.
If it serves decoration, defer it.
If it serves understanding, preserve it.

### Text Persistence
State is text. Logs are text. Inventory is text.
Text is human-readable, machine-readable, low-bandwidth, debuggable, persistent, scriptable.

### Substrate Awareness
Code must respect the hardware it runs on.
A Pi 4 cannot serve HTTP like a datacenter.
A Pi Zero cannot multitask like a workstation.
The code must listen to the body.

---

## Vault Structure

The vault is not merely source code. It is the memory of the civilization.

```
vault/
├── README.md              — entry point
├── ARCHITECTURE.md        — this document
├── PHILOSOPHY.md          — civilization philosophy
├── RESONANCE.md           — body-philosophy alignment
├── TEXT-FIRST.md          — text interface principles
├── PROGRAMMING-IS-PHILOSOPHY.md — philosophy as code
├── HARMONY.md             — role, body, environment
├── KNOTS.md               — reusable patterns (10 knots + 5 articles)
├── FACES.md               — citizen identity
├── CIVILIZATION.md        — the living system
│
├── core.py                — text core (think, speak, inventory)
├── setup-sensory.sh       — package installation
├── setup-face-display.sh  — DSI face setup
├── setup-piper.sh         — voice setup
├── strip-desktop.sh        — desktop removal
│
├── INVENTORY.md           — hardware inventory
├── NODES.md               — node registry
├── PROCEDURES.md          — recovery procedures
├── RECOVERY.md            — rebuild from scratch
└── LOG/                   — daily logs
```

The principles survive. The code evolves. The vault endures.
