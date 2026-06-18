#!/bin/bash
# identify-147.sh — Try to identify 10.98.79.147
# Run from PHONE (not Adam) since phone can ping it

echo "=== Identifying 10.98.79.147 from Phone ==="

# SSH with default pi credentials
echo "--- SSH (pi/raspberry) ---"
sshpass -p 'raspberry' ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no pi@10.98.79.147 "hostname; cat /etc/hostname; uname -m; cat /proc/cpuinfo | grep -E 'Model|Hardware' | head -3; free -h | head -2; df -h | tail -1; ls /dev/sd* 2>/dev/null; echo '---'" 2>&1 || echo "SSH failed"

# Try common Tizen passwords
echo ""
echo "--- SSH (root/1234) ---"
ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@10.98.79.147 "hostname 2>/dev/null" 2>&1 || echo "SSH failed"

echo ""
echo "--- SSH (root/root) ---"
ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@10.98.79.147 "hostname 2>/dev/null" 2>&1 || echo "SSH failed"

echo ""
echo "=== Identification complete ==="