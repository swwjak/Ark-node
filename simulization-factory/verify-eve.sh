#!/bin/bash
# verify-eve.sh — Full node verification of Eve
# Run from Adam via: ssh -t pi@10.98.79.63 'bash -s' < verify-eve.sh

echo "=== EVE NODE VERIFICATION ==="
echo "Date: $(date)"

echo ""
echo "=== 1. IP Address ==="
ip addr show | grep "inet " | grep -v 127.0.0.1

echo ""
echo "=== 2. Hostname ==="
hostname
cat /etc/hostname

echo ""
echo "=== 3. System ==="
uname -a

echo ""
echo "=== 4. Storage ==="
df -h | grep -E "Filesystem|/dev/"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT 2>/dev/null

echo ""
echo "=== 5. Memory ==="
free -h

echo ""
echo "=== 6. CPU ==="
nproc
cat /proc/cpuinfo | grep "Model name" | head -1 2>/dev/null
uptime

echo ""
echo "=== 7. Running Services ==="
systemctl list-units --type=service --state=running --no-pager 2>/dev/null | head -20

echo ""
echo "=== 8. Open Ports ==="
ss -tlnp 2>/dev/null | head -20

echo ""
echo "=== 9. Ollama ==="
which ollama 2>/dev/null && ollama --version 2>&1 || echo "Ollama not installed"
ollama list 2>&1 || true

echo ""
echo "=== 10. Network ==="
ip route show | head -5
cat /etc/resolv.conf

echo ""
echo "=== 11. Users ==="
cat /etc/passwd | grep -E "pi|root" | head -5

echo ""
echo "=== 12. SSH ==="
sudo systemctl is-active ssh 2>/dev/null || echo "SSH not active"

echo ""
echo "=== 13. OS Release ==="
cat /etc/os-release | head -3

echo ""
echo "=== VERIFICATION COMPLETE ==="