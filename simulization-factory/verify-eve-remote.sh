#!/bin/bash
# verify-eve-remote.sh — Run verification ON Eve from Adam
# Usage: ssh pi@10.98.79.63 'bash -s' < verify-eve-remote.sh
# This script SSHes into Eve from Adam

echo "=== EVE NODE VERIFICATION (via Adam) ==="
echo "Date: $(date)"

echo ""
echo "=== 1. IP Address ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'ip addr show | grep "inet " | grep -v 127.0.0.1' 2>&1

echo ""
echo "=== 2. Hostname ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'hostname; cat /etc/hostname' 2>&1

echo ""
echo "=== 3. System ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'uname -a' 2>&1

echo ""
echo "=== 4. Storage ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'df -h | grep -E "Filesystem|/dev/"' 2>&1

echo ""
echo "=== 5. Memory ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'free -h' 2>&1

echo ""
echo "=== 6. Services ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'systemctl list-units --type=service --state=running --no-pager | head -20' 2>&1

echo ""
echo "=== 7. Open Ports ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'ss -tlnp | head -20' 2>&1

echo ""
echo "=== 8. Ollama ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'which ollama 2>/dev/null && ollama --version 2>&1; ollama list 2>&1' 2>&1

echo ""
echo "=== 9. Network ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'ip route show; echo "---"; cat /etc/resolv.conf' 2>&1

echo ""
echo "=== 10. Uptime ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'uptime -p; uptime' 2>&1

echo ""
echo "=== 11. OS ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'cat /etc/os-release | head -3' 2>&1

echo ""
echo "=== 12. CPU/RAM ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'nproc; echo "---"; cat /proc/cpuinfo | grep "Hardware" | head -1' 2>&1

echo ""
echo "=== 13. Unique hardware ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'ls /dev/sd* 2>/dev/null; echo "---"; lsblk -o NAME,SIZE,TYPE,MODEL,TRAN -d 2>/dev/null | grep -v loop | head -10' 2>&1

echo ""
echo "=== 14. Reachability ==="
echo "From Adam:"
ping -c 1 -W 2 10.42.0.152 2>&1 | tail -2
echo ""
echo "From Phone (via Adam):"
echo "(Phone sees 10.42.0.152 via Adam's routing)"

echo ""
echo "=== 15. DNS resolution ==="
ssh -o ConnectTimeout=5 pi@10.42.0.152 'getent hosts github.com 2>/dev/null' 2>&1 || echo "DNS not working"

echo ""
echo "=== VERIFICATION COMPLETE ==="