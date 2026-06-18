#!/bin/bash
# diagnose-eve.sh — Figure out why SSH to Eve times out
# Run from Adam

echo "=== Diagnosing Eve SSH ==="

# 1. Ping works?
echo "--- Ping ---"
ping -c 1 -W 2 10.42.0.152 2>&1 | tail -2

# 2. Nmap port 22 from Adam
echo ""
echo "--- Nmap port 22 ---"
nmap -p 22 --reason 10.42.0.152 2>/dev/null | grep -E "PORT|STATE|reason"

# 3. Try different ports
echo ""
echo "--- Nmap common ports ---"
nmap -p 22,80,443,8080,21 10.42.0.152 2>/dev/null | grep -E "open|closed|filtered"

# 4. Check if Eve's SSH is on a different port
echo ""
echo "--- Nmap top 100 ports ---"
nmap --top-ports 100 10.42.0.152 2>/dev/null | grep "open" | head -10

# 5. Traceroute
echo ""
echo "--- Traceroute ---"
traceroute -n 10.42.0.152 2>/dev/null | head -5

echo ""
echo "=== Diagnosis complete ==="