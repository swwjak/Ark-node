# DAY 1 SUMMARY — 2026-06-17

## What was done
1. Inventoried all hardware (10+ nodes), software (Python/Go/Rust/Node/Clang), and models
2. Started Ollama on Galaxy S22 with Qwen3:4B (2.5 GB GGUF)
3. Benchmarked local inference: 4-5 tok/s on CPU, memory pressure is the bottleneck
4. Built the Archive at ~/ARCHIVE/ with 6 documents
5. Preserved 4 reusable Knots (patterns)

## Key findings
- Qwen3:4B runs on S22 but uses 3.3 GB RAM, causing swap thrashing
- Pi 4 is unreachable (AP mode has no upstream internet)
- Aqua X570 FORGE node offline (PSU DOA, replacement tomorrow)
- All home network nodes unreachable from current location

## Archive location
~/ARCHIVE/
  README.md       — Overview
  INVENTORY.md    — Full hardware/software inventory
  MODELS.md       — Model catalog + benchmarks
  NODES.md        — Live node registry
  KNOTS.md        — 4 reusable patterns
  PROCEDURES.md   — Recovery procedures
  LOG/2026-06-17.md — Daily log

## Next priorities
1. Fix Pi 4 connectivity (routing or travel router)
2. Aqua X570 Linux install when PSU arrives
3. Create first specialist model
4. Backup Archive to Pi Zero W
