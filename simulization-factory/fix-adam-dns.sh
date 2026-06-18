#!/bin/bash
# fix-adam-dns.sh — Fix Adam's DNS to use phone as gateway
# The phone (10.98.79.83) is Adam's default route but doesn't forward DNS.
# Solution: Use a public DNS server instead.

echo "=== Fixing Adam DNS ==="

# Check current DNS
echo "Current DNS:"
cat /etc/resolv.conf

# Option 1: Use phone if it can forward DNS
# Option 2: Use public DNS directly
echo ""
echo "Setting DNS to 8.8.8.8 (Google)..."

# Backup current resolv.conf
sudo cp /etc/resolv.conf /etc/resolv.conf.bak

# Set public DNS
sudo tee /etc/resolv.conf << 'EOF'
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF

echo ""
echo "New DNS:"
cat /etc/resolv.conf

# Test
echo ""
echo "Testing DNS..."
dig +short google.com 2>/dev/null && echo "[OK] DNS works" || echo "[FAIL] DNS still broken"

echo ""
echo "Testing internet..."
ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1 && echo "[OK] Internet reachable" || echo "[FAIL] No internet (no NAT from phone)"

echo ""
echo "=== DNS Fix Complete ==="