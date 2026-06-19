# ROVER-INVENTORY.md — Available Components for Minimum Viable Rover

## Principle
Build the first rover from what exists. The second rover can be improved. The third rover can teach the fourth.

---

## Available Components

### Brains
- **Pi Zero W** (ark-1) — Seed Vault role, in Ark bag. WiFi, GPIO, runs Linux.
- **Pi Zero (non-WiFi)** (key-0) — Identity role. No WiFi, needs USB or serial.

### Power
- **Ender 2 PSUs** (×4) — 12V/24V, 360W. At 3D printing farm.
- **Ender 2 heated bed PSUs** — 24V high-current. Can be repurposed.
- **Phone charger (5V/3A)** — Can power Pi Zero directly.
- **USB power banks** — Unknown availability.

### Motors
- **Ender 2 stepper motors (NEMA 17)** — 4 printers × 4 axes = 16 motors available. 1.8° step angle, ~1.5A/phase.
- **Ender 2 extruder motors** — Smaller NEMA 17s. 4 available.

### Motor Controllers
- **Ender 2 mainboards (4.2.2 or 4.2.7)** — 4 boards with TMC2209 stepper drivers. Can drive 4 motors each.
- **A4988 stepper drivers** — If available from older printers.

### Wheels and Mobility
- **Ender 2 GT2 belts (6mm)** — 4 printers worth. Can be cut to length.
- **Ender 2 GT2 pulleys (20-tooth)** — 8+ available.
- **Ender 2 linear bearings (LM8UU)** — 16+ available. Can be repurposed.
- **Ender 2 smooth rods (8mm)** — 8 rods. Can be cut for axles.
- **Printed wheels/pulleys** — Unknown existing designs.

### Chassis
- **Ender 2 aluminum extrusions (2020/2040)** — 4 printers worth. Can be cut and reassembled.
- **Ender 2 printed parts** — Various brackets, mounts, fan shrouds. Can be reprinted or repurposed.
- **3D printer filament** — Unknown remaining stock.

### Sensors
- **Ender 2 thermistors (100K)** — 8+ available. For temperature monitoring.
- **Ender 2 endstops (mechanical)** — 12 available. Can be repurposed as bump sensors.
- **Ender 2 BLTouch/CRTouch** — If equipped, can be repurposed as distance sensor.
- **AR Drone 2.0 camera** — In storage. Can be mounted on rover.
- **Pi Camera Module** — Unknown availability.

### Communication
- **Pi Zero W WiFi** — Built-in. Connects to hotspot.
- **LoRa modules** — Mentioned in Forge 2.0 plan. Unknown hardware.
- **Bluetooth** — Pi Zero W built-in.

### Connectors
- **JST-XH connectors** — From Ender 2 wiring. Many available.
- **Dupont jumper wires** — Unknown stock.
- **XT60 power connectors** — From Ender 2. 4+ available.

---

## Minimum Viable Rover (Bill of Materials)

### From Existing Parts (No Purchase Required)
| Qty | Component | Source | Notes |
|-----|-----------|--------|-------|
| 1 | Pi Zero W | Ark bag | Brain |
| 2 | NEMA 17 stepper motors | Ender 2 farm | Drive motors |
| 1 | Ender 2 mainboard | Ender 2 farm | Motor controller |
| 2 | GT2 pulleys (20T) | Ender 2 farm | Wheel hubs |
| 2 | GT2 belt (cut to length) | Ender 2 farm | Drive belts |
| 2 | Smooth rods (8mm, cut) | Ender 2 farm | Axles |
| 4 | LM8UU bearings | Ender 2 farm | Wheel bearings |
| 1 | 12V PSU | Ender 2 farm | Power |
| 1 | Buck converter (12V→5V) | Unknown | Pi power |
| 1 | Pi Camera or AR Drone camera | Unknown | Imaging |
| 2 | Mechanical endstops | Ender 2 farm | Bump sensors |
| 1 | 3D printed chassis | Print from farm | Custom design |

### Unknown / May Need Purchase
| Component | Est. Cost | Notes |
|-----------|-----------|-------|
| Buck converter (12V→5V, 3A) | $5 | If not available from Ender parts |
| Wheels (rubber, 60-80mm) | $10 | Or print with TPU |
| Ball caster (rear) | $5 | For 2WD stability |
| Pi Camera Module v2 | $15 | If AR Drone camera incompatible |
| Jumper wires, connectors | $5 | If insufficient from Ender parts |
| **Total estimated purchase** | **$25-40** | |

---

## Design Constraints

### Physical
- **Size:** Must fit under furniture (target: <15cm height, <25cm length)
- **Weight:** <500g (Pi Zero + motors + battery)
- **Ground clearance:** >2cm for carpet/thresholds

### Electrical
- **Power:** 12V from Ender PSU, buck-converted to 5V for Pi
- **Runtime:** Target 30+ minutes on battery (if battery added)
- **Motor voltage:** 12V direct from PSU

### Software
- **OS:** Raspberry Pi OS Lite (32-bit for Pi Zero W)
- **Language:** Python (gpiozero, pigpio)
- **Communication:** WiFi to hotspot, SSH for commands
- **Camera:** picamera2 or rpicam-still
- **Motor control:** Direct GPIO + step/dir signals

### Mechanical
- **Drive type:** 2WD with rear ball caster
- **Motor mounting:** 3D printed brackets from Ender 2 parts
- **Wheel mounting:** GT2 pulleys as wheels, or printed rubber wheels
- **Chassis:** 3D printed or aluminum extrusion frame

---

## Assembly Steps

### Phase 1: Chassis (1 hour)
1. Design chassis in Fusion360 or Tinkercad
2. Print on Ender 2 (if at home) or order prints
3. Mount motors to chassis
4. Install wheels and ball caster

### Phase 2: Electronics (1 hour)
1. Wire motor controller to Pi Zero GPIO
2. Connect stepper motors to driver
3. Wire power: 12V PSU → motor controller, buck converter → Pi
4. Connect endstops to GPIO
5. Mount camera

### Phase 3: Software (2 hours)
1. Flash Pi OS Lite to SD card
2. Enable SSH, configure WiFi
3. Install Python dependencies (gpiozero, picamera2)
4. Write motor control script
5. Write camera capture script
6. Write battery monitoring script
7. Write command receiver (SSH or HTTP)

### Phase 4: Test (1 hour)
1. Test motor movement (forward, reverse, turn)
2. Test camera capture
3. Test battery monitoring
4. Test WiFi communication
5. Test return-to-home behavior

---

## Rover Identity

**Name:** To be assigned
**Role:** SCOUT
**Dwelling:** Mobile (returns to village for charging/sync)
**Reports to:** Adam (Explorer/Gateway)
**Memory:** Stores observations in Tree when docked

---

## The Third Teaches the Fourth

Once the first rover is operational:
- Its design becomes the template
- Its software becomes the base
- Its failures become the lessons
- The second rover improves on the first
- The third rover teaches the fourth

Each generation is cheaper and faster to build because the knowledge compounds.

**The rover leaves the village, gathers experience, and returns.**
