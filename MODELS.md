# MODELS.md — Local Model Catalog

**Date:** 2026-06-17
**Last benchmarked:** 2026-06-17

---

## Active Models

### Qwen3:4B (GGUF Q3_K_M)
- **Format:** GGUF v3, Q3_K_M quantization
- **Size:** 2.5 GB on disk
- **Architecture:** Qwen3, 4B parameters
- **Context window:** 4096 (configured), likely supports 32K+
- **Template:** ChatML variant with thinking support
- **Params:** temp=0.6, top_k=20, top_p=0.95, repeat_penalty=1
- **License:** Apache 2.0
- **Source:** Ollama library (registry.ollama.ai/library/qwen3/4b)

#### Benchmark Results (Galaxy S22, Termux, CPU-only, aarch64)

| Test | Prompt tokens | Eval tokens | Eval rate | Total time |
|------|-------------|-------------|-----------|------------|
| Simple math (2+2) | 22 | 346 | 4.15 tok/s | 1m34s |
| Code gen (fibonacci) | 27 | 167 | 5.31 tok/s | 33s |
| Medium reasoning | — | — | — | TIMEOUT (60s) |
| Quick "hello" | — | — | — | TIMEOUT (60s) |

#### Analysis
- **First prompt is slow** (9s load + thinking overhead). Subsequent prompts faster.
- **Thinking mode is expensive** on mobile CPU. The model "thinks" extensively before responding.
- **Memory pressure is the bottleneck.** Model uses ~3.3 GB RAM. With Android (5.2 GB) + Hermes + Termux, only 1.6 GB available. System thrashes on swap.
- **Eval rate 4-5 tok/s** is usable for short tasks but too slow for interactive chat.
- **Recommendation:** Disable thinking mode. Use smaller context (2048). Consider Q2_K quant for lower memory.

### llama3.1 (on Pi 4)
- **Host:** pi4-1 (10.98.79.63)
- **Status:** Running on Pi 4 (4 GB RAM)
- **Quantization:** Unknown (likely Q4_K_M)
- **Benchmark:** Not yet tested (Pi currently unreachable)
- **Expected:** ~8-12 tok/s on Pi 4 CPU (Cortex-A72)

---

## Cloud Models

### owl-alpha (OpenRouter)
- **Role:** Teacher / General intelligence
- **Status:** Active (this session)
- **Strengths:** Complex reasoning, multi-step tasks, tool use
- **Weaknesses:** Requires internet, per-token cost
- **Use for:** Creating specialists, summarizing knowledge, complex reasoning

---

## Model Selection Guide

| Task | Recommended Model | Reason |
|------|------------------|--------|
| Quick Q&A | Qwen3:4B (local) | Low latency, no internet needed |
| Code generation | Qwen3:4B (local) | 5 tok/s adequate for short code |
| Complex reasoning | owl-alpha (cloud) | Better reasoning, more context |
| Specialist creation | owl-alpha (cloud) | Teacher role |
| Offline fallback | Qwen3:4B (local) | Always available |

---

## Future Models to Consider

| Model | Size | Purpose | Node |
|-------|------|---------|------|
| Qwen2.5-7B Q4_K_M | ~4.5 GB | Better reasoning | Aqua X570 (64GB) |
| phi-4 Q4_K_M | ~2.5 GB | Lightweight specialist | S22 or Pi 4 |
| codellama-7b Q4_K_M | ~4 GB | Code specialist | Aqua X570 |
| qwen3:4b Q2_K | ~1.8 GB | Low-memory local | S22 (if Q3 too slow) |
| llama3.1-8b Q4_K_M | ~4.8 GB | General purpose | Aqua X570 |
