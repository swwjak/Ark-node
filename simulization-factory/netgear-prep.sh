#!/bin/bash
# netgear-prep.sh — Prepare a node for the Netgear network
# Run this on EACH node after the Netgear is configured

set -e

echo "=== NETGEAR NETWORK PREPARATION ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"

# Step 1: Detect current network
echo ""
echo "--- [1] Current Network ---"
ip addr show | grep "inet " | grep -v 127.0.0.1
echo "Gateway: $(ip route | grep default | awk '{print $3}')"
echo "DNS: $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -1)"

# Step 2: Generate SSH key if needed
echo ""
echo "--- [2] SSH Key ---"
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
    echo "Generated new key"
else
    echo "Key exists"
fi
echo "Public key: $(cat ~/.ssh/id_ed25519.pub)"

# Step 3: Test mDNS
echo ""
echo "--- [3] mDNS Discovery ---"
for name in adam.local eve.local aqua.local rampage.local; do
    result=$(getent hosts "$name" 2>/dev/null | awk '{print $1}' | head -1)
    if [ -n "$result" ]; then
        echo "  [FOUND] $name → $result"
    fi
done

# Step 4: Test SSH to other nodes
echo ""
echo "--- [4] SSH Connectivity ---"
for ip in 10.42.0.152 192.168.1.100 192.168.1.101; do
    if ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no pi@$ip "echo ok" 2>/dev/null | grep -q ok; then
        echo "  [OK] $ip"
    fi
done

# Step 5: Record MAC address
echo ""
echo "--- [5] MAC Address ---"
ip link show eth0 2>/dev/null | grep ether | awk '{print $2}'

echo ""
echo "=== PREP COMPLETE ==="