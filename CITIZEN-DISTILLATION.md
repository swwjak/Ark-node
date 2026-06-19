# CITIZEN-DISTILLATION.md — Framework for Specialized Intelligence

## Principle
A citizen does not need all knowledge. A citizen only needs the knowledge required to perform its assigned role.

---

## Architecture

```
┌─────────────────────────────────────────────┐
│              SUBCONSCIOUS LAYER              │
│                                              │
│  Large Model (Forge / Cloud)                │
│  - Long-term memory                          │
│  - Planning and coordination                 │
│  - Learning and adaptation                   │
│  - Creates citizens                          │
│  - Receives experience reports               │
│                                              │
│  Hardware: Forge (Aqua X570 → Forge 2.0)     │
│  Model: 70B+ parameter model                 │
│  Role: Teacher, Coordinator, Memory          │
└──────────────────┬──────────────────────────┘
                   │
                   │ Distillation Pipeline
                   │
                   ▼
┌─────────────────────────────────────────────┐
│              CONSCIOUS LAYER                 │
│                                              │
│  Specialized Citizens                        │
│  - Fast local response                       │
│  - Role-specific knowledge only              │
│  - Minimal resource usage                    │
│  - Reports experience upward                 │
│                                              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐     │
│  │  Boat    │ │  Drone   │ │  LoRa    │     │
│  │ Citizen  │ │ Citizen  │ │ Citizen  │     │
│  │ ~500MB   │ │ ~300MB   │ │ ~50MB    │     │
│  └──────────┘ └──────────┘ └──────────┘     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐     │
│  │ Printer  │ │  Adam    │ │  Eve     │     │
│  │ Citizen  │ │ Explorer │ │ Archivist│     │
│  │ ~200MB   │ │ ~1.5GB   │ │ ~1GB     │     │
│  └──────────┘ └──────────┘ └──────────┘     │
└─────────────────────────────────────────────┘
```

---

## Distillation Pipeline

### Phase 1: Role Definition
Define what a citizen needs to know:
- **Inputs**: What sensors/data does it receive?
- **Outputs**: What actions/decisions does it produce?
- **Constraints**: What are the latency, memory, and power limits?
- **Context**: What does it NOT need to know?

### Phase 2: Knowledge Extraction
From the parent model, extract:
- **Weights**: Which parameters are relevant to this role?
- **Patterns**: Which attention heads activate for this role's inputs?
- **Functions**: Which computational paths does this role exercise?

### Phase 3: Compression
Apply techniques in order of impact:
1. **Pruning**: Remove weights near zero for this role's inputs
2. **Quantization**: Reduce precision (FP32 → INT8 → INT4 → INT2)
3. **Distillation**: Train small model on large model's outputs for role-specific tasks
4. **Architecture search**: Find minimal architecture that preserves role performance

### Phase 4: Validation
Test the citizen:
- Does it perform its role correctly?
- Does it stay within resource limits?
- Does it know what it doesn't know (refusal capability)?
- Does it report anomalies upward?

---

## Hardware Tiers

### Tier 1: Micro (ESP32-class)
- **RAM**: 520KB
- **Storage**: 4MB flash
- **Model size**: <100KB (decision tree / lookup table)
- **Citizen type**: Sensor reader, simple actuator
- **Example**: Temperature monitor, relay controller
- **Technique**: Rule-based + tiny lookup tables distilled from parent

### Tier 2: Small (Pi Zero / Pi Zero 2W)
- **RAM**: 512MB
- **Storage**: 8-32GB SD
- **Model size**: 20-80MB
- **Citizen type**: Sensor fusion, basic classification
- **Example**: Boat monitor, simple telemetry
- **Technique**: INT8 quantized 0.5-1B parameter model
- **Inference time**: 500ms-2s per decision

### Tier 3: Medium (Pi 3B+ / Pi 4)
- **RAM**: 1-4GB
- **Storage**: 32-128GB SD
- **Model size**: 200MB-1.5GB
- **Citizen type**: Full role specialist
- **Example**: Printer controller, LoRa router, archivist
- **Technique**: INT4 quantized 1-3B parameter model
- **Inference time**: 100ms-500ms per decision

### Tier 4: Large (Pi 4 8GB / Android phone)
- **RAM**: 4-10GB
- **Storage**: 64-256GB
- **Model size**: 1.5-4GB
- **Citizen type**: Complex role with learning
- **Example**: Explorer, aperture, local coordinator
- **Technique**: INT4 quantized 3-7B parameter model
- **Inference time**: 50-200ms per decision

### Tier 5: Forge (Workstation)
- **RAM**: 32-64GB
- **Storage**: 1TB+ NVMe
- **Model size**: 14-70GB
- **Citizen type**: Parent model, teacher, coordinator
- **Example**: Forge, Hermes
- **Technique**: FP16/INT8 70B+ model
- **Inference time**: 10-50ms per token

---

## Minimum Model Sizes by Task

| Task | Min Size | Technique | Hardware |
|------|----------|-----------|----------|
| Threshold detection | <1KB | Rule engine | ESP32 |
| Sensor classification | 5-20MB | INT8 0.5B | Pi Zero |
| GPS + battery + bilge | 20-50MB | INT8 1B | Pi Zero 2W |
| Message routing | 30-80MB | INT4 1.5B | Pi 3B+ |
| Job queue management | 50-100MB | INT4 2B | Pi 3B+ |
| Image classification | 100-300MB | INT4 3B | Pi 4 |
| Natural language | 500MB-1.5GB | INT4 7B | Pi 4 8GB |
| Multi-modal reasoning | 2-4GB | INT4 13B | Android phone |
| Role creation | 14-70GB | FP16 70B | Forge |

---

## Role Templates

### Boat Citizen
```
ROLE: Boat Monitor
INPUTS: GPS, battery voltage, bilge sensor, anchor sensor, wind
OUTPUTS: Status report, alert, anchor drag warning, bilge warning
MODEL: INT8 1B parameter model (~30MB)
HARDWARE: Pi Zero 2W + LoRA
UPDATE: Daily experience report to Archive
```

### Drone Citizen
```
ROLE: Drone Controller
INPUTS: GPS, battery, camera, IMU, mission waypoints
OUTPUTS: Navigation commands, camera triggers, status
MODEL: INT4 2B parameter model (~100MB)
HARDWARE: Pi 3B+ or Pi 4
UPDATE: Mission report to Archive
```

### LoRa Citizen
```
ROLE: Message Router
INPUTS: LoRa packets, link quality, neighbor table
OUTPUTS: Route decision, compression, store-and-forward
MODEL: INT4 1B parameter model (~40MB)
HARDWARE: Pi 3B+ + LoRa HAT
UPDATE: Link quality report hourly
```

### Printer Citizen
```
ROLE: Print Farm Controller
INPUTS: Printer status, job queue, filament sensor, temperature
OUTPUTS: Job dispatch, error alert, maintenance warning
MODEL: INT4 1.5B parameter model (~60MB)
HARDWARE: Pi 3B+
UPDATE: Job completion report
```

---

## Distillation Methodology

### Step 1: Collect Role Data
Run the parent model on role-specific tasks. Record:
- Input distribution
- Output distribution
- Activation patterns (which neurons fire)
- Attention patterns (which tokens matter)

### Step 2: Extract Sub-Network
Identify the minimal sub-network that handles this role:
- Prune attention heads that never activate for role inputs
- Prune feed-forward neurons with near-zero activation
- Measure performance after each pruning pass

### Step 3: Train Student
Train a small model to mimic the parent's outputs on role data:
- Use parent model's soft labels (not hard targets)
- Add role-specific fine-tuning data
- Validate against parent on held-out role tasks

### Step 4: Quantize
Reduce precision while monitoring role accuracy:
- FP32 → FP16 (usually lossless)
- FP16 → INT8 (minimal loss)
- INT8 → INT4 (acceptable loss for most roles)
- INT4 → INT2 (significant loss, only for simple roles)

### Step 5: Deploy and Monitor
- Deploy citizen to target device
- Monitor resource usage (RAM, CPU, latency)
- Monitor accuracy on role tasks
- Report anomalies to parent model
- Receive updates from parent when improved

---

## Current Reality (What We Can Do Now)

### Available
- **Qwen3:4B Q3_K_M** (2.5GB) — runs on Pi 4 and phone ✅
- **llama3.1** (likely 8B Q4) — runs on Pi 4 ✅
- **Ollama** — serving framework ✅
- **INT4 quantization** — available via Ollama ✅

### Not Yet Available
- **Distillation pipeline** — no tooling yet
- **Pruning** — no workflow yet
- **Role-specific training data** — not collected
- **Citizen deployment** — no framework yet

### Immediate Next Step
The first citizen should be the simplest one that provides value. That's the **LoRa Citizen** — smallest hardware, clearest role, most constrained environment.

But first: we need to prove distillation works at all. The simplest proof:
1. Take Qwen3:4B (already running on Adam)
2. Quantize to Q2_K (smaller, faster)
3. Test: does it still perform its role?
4. If yes, we have our first citizen

---

## Hierarchy

```
Forge (70B+)
  ↓ creates citizens
  ↓ receives experience
  ↓ updates citizens
Hermes (7B-13B)
  ↓ coordinates citizens
  ↓ manages local resources
  ↓ reports to Forge
Citizens (0.5B-3B)
  ↓ perform roles
  ↓ report experience
  ↓ receive updates
Devices (ESP32-Pi4)
  ↓ run citizens
  ↓ collect sensor data
  ↓ execute actions
```

---

## Key Insight

The parent model does not need to be present for citizens to function. Once a citizen is created and deployed, it operates independently. The parent is needed only to:
1. Create new citizens
2. Update existing citizens with new knowledge
3. Receive and integrate experience reports

This means the Forge can be offline for days or weeks. Citizens continue working. When Forge comes back online, it syncs experience and updates citizens.

**The civilization does not depend on any single model. It depends on the distillation pipeline.**
