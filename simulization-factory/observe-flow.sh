#!/bin/bash
# observe-flow.sh — Watch information move through the Tree
# Run from Adam. Observe for 60 seconds.

echo "=== TREE FLOW OBSERVATION ==="
echo "Date: $(date)"
echo "Duration: 30 seconds"
echo ""

# 1. What queries hit Adam?
echo "--- [1] Incoming connections to Adam ---"
ss -tn state established 2>/dev/null | grep -v "127.0.0.1" | head -10

echo ""
echo "--- [2] Ollama requests ---"
ss -tn state established 2>/dev/null | grep ":11434" | head -5

echo ""
echo "--- [3] Hermes requests ---"
ss -tn state established 2>/dev/null | grep ":8642" | head -5

echo ""
echo "--- [4] DNS queries ---"
ss -tn state established 2>/dev/null | grep ":53" | head -5

echo ""
echo "--- [5] SSH sessions ---"
ss -tn state established 2>/dev/null | grep ":22" | head -5

echo ""
echo "--- [6] Adam's network connections ---"
ss -tn state established 2>/dev/null | head -15

echo ""
echo "--- [7] What Adam sends OUT ---"
ss -tn state established dport = :22 or dport = :80 or dport = :443 2>/dev/null | head -10

echo ""
echo "--- [8] Eve's connections ---"
ssh -o ConnectTimeout=5 pi@10.42.0.152 'ss -tn state established 2>/dev/null | head -15' 2>&1

echo ""
echo "--- [9] Phone's connections ---"
echo "(Phone has no SSH server — cannot observe directly)"
echo "Phone → Adam: SSH sessions from 10.98.79.83"
echo "Phone → Internet: cellular (10.36.156.7, 10.60.202.118)"

echo ""
echo "=== OBSERVATION COMPLETE ==="