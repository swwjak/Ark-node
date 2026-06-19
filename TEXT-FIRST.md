# TEXT-FIRST.md — Core Architecture

## Principle
Text comes first. Text is not temporary. Text is the foundation.

Faces can fail. Voices can fail. Displays can fail. Cameras can fail. Networks can fail. Text survives.

## Architecture

```
PRESENTATION LAYER (optional, built on top)
├── DSI face (expression)
├── Voice (communication)
├── Camera (observation)
├── Animation (status)
└── Web interface (remote access)

CORE Layer (required, always available)
├── Model (inference)
├── State (current condition)
├── Text messages (communication)
├── Commands (control)
├── Logs (history)
└── Inventory (observations)
```

## Rules

1. Every capability must have a text representation
2. Every state change must be visible through text
3. Face updates originate from text state
4. Voice originates from text
5. Cameras report observations through text
6. Inventory is text first
7. Text interfaces remain available even when higher interfaces exist

## Text State Format

Every inhabitant maintains a text state that is always readable:

```
STATUS: READY
MODE: IDLE
THOUGHT: None
LAST_ACTION: Boot complete
UPTIME: 2h 17m
IP: 10.98.79.10
BATTERY: N/A
ERRORS: None
```

## Text Commands

Every inhabitant accepts text commands:

```
STATUS — report current state
THINK <prompt> — run inference, return text response
SPEAK <text> — speak text aloud
OBSERVE — capture camera observation, return text description
INVENTORY — list inventory items
INVENTORY ADD <item> — add item to inventory
INVENTORY PHOTO <item> — capture photo, attach to item
MOVE <direction> — move rover (if applicable)
DOCK — return to charging station
SLEEP — enter low-power mode
WAKE — resume operation
```

## Text Inventory Format

```
ITEM: L298N motor driver
LOCATION: Workbench drawer
IMAGE: attached
NOTES: Previously used for rover experiments.
ADDED: 2026-06-19 14:30
```

## Failure Modes

If face fails: continue with text.
If audio fails: continue with text.
If display fails: continue with text.
If network fails: continue with local text.
If camera fails: continue with text-only observation.

The inhabitant remains.

## Future Principle

Meaning first. Expression second.

A speaking face without understanding is decoration.
Understanding without a face is still intelligence.

The roads come before the buildings.
