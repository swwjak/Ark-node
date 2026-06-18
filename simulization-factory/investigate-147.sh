#!/bin/bash
# investigate-147.sh — Who is 10.98.79.147?
# Run from Adam

echo "=== Investigating 10.98.79.147 ==="

# Ping
echo "--- Ping ---"
ping -c 3 -W 2 10.98.79.147 2>&1

# SSH
echo ""
echo "--- SSH ---"
sshpass -p 'raspberry' ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no pi@10.98.79.147 "hostname; uname -a; cat /etc/hosts; ls /dev/sd* 2>/dev/null; ollama list 2>/dev/null; echo '---'" 2>&1 || echo "SSH failed"

# Nmap
echo ""
echo "--- Nmap ---"
nmap -sV -p 22,80,443,11434,8642 10.98.79.147 2>/dev/null | grep -E "PORT|open|closed|service" | head -15

echo ""
echo "=== Investigation complete ==="