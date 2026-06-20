# University Benchmark Report
## Date: 2026-06-20

## HARDWARE
- **Hostname:** ubuntu-8gb-hel1-1
- **IP:** 204.168.176.156
- **CPU:** 4 cores (AMD EPYC-Rome)
- **RAM:** 7.6GB total
- **Storage:** 75GB total, 62GB free (15% used)
- **GPU:** None (CPU-only)
- **OS:** Ubuntu 26.04 LTS

## MODELS INSTALLED
| Model | Size | Purpose |
|-------|------|---------|
| Qwen2.5 7B Q4_K_M | 4.7GB | Primary reasoning |
| Gemma2 2B Q4_K_M | 1.7GB | Fast simple queries |

## BENCHMARK RESULTS

### Qwen2.5 7B Q4_K_M
- **Cold start (simple):** 9.8s
- **Warm (simple):** 2.3s
- **Complex reasoning:** 11.5s
- **RAM usage:** ~4.7GB
- **Quality:** Good reasoning, can handle specialist questions

### Gemma2 2B Q4_K_M
- **Cold start (simple):** 6.2s
- **RAM usage:** ~1.7GB
- **Quality:** Lower, suitable for simple queries

## VERDICT

**Qwen2.5 7B is RECOMMENDED for the University.**

Reasons:
1. Fits in 8GB RAM with headroom (~300MB free after both models loaded)
2. Warm inference 2-3 seconds — acceptable for interactive use
3. Good reasoning quality — can handle specialist questions
4. Context window sufficient for long documents

**Gemma2 2B is BACKUP for simple queries.**
- Faster for simple questions
- Lower quality reasoning
- Keep for quick lookups

## RESOURCE SUMMARY
- **Disk used by models:** ~6.4GB
- **Disk free:** ~55GB
- **RAM headroom:** ~300MB after both models loaded
- **Recommendation:** Keep Qwen2.5 7B as primary. Do NOT install larger models.

## NEXT STEPS
1. Create local knowledge store (reduce token waste)
2. Set up Ollama as primary reasoning for village questions
3. Reduce OpenRouter dependence for common queries
4. Enable Tailscale for secure village-university communication
5. Build specialist knowledge bases (marine, auto, electronics, navigation)