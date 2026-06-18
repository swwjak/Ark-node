#!/bin/bash
# restore-eve.sh — Find and recover Eve
# Run from Adam. Tries every possible way to reach Eve.

set -e

echo "=== EVE RECOVERY ==="
echo "Date: $(date)"
echo ""

# 1. Check if Eve appeared on ScottNet
echo "--- [1] ScottNet scan ---"
nmap -sn 10.98.79.0/24 2>/dev/null | grep -E "Nmap scan|Host is up" | head -10

# 2. Check if Eve appeared on Ethernet
echo ""
echo "--- [2] Ethernet scan ---"
nmap -sn 10.42.0.0/24 2>/dev/null | grep -E "Nmap scan|Host is up" | head -10

# 3. Check WiFi Direct range
echo ""
echo "--- [3] WiFi Direct scan ---"
nmap -sn 10.144.28.0/24 2>/dev/null | grep -E "Nmap scan|Host is up" | head -10

# 4. Check Adam's ARP table for any new entries
echo ""
echo "--- [4] ARP table ---"
ip neigh show 2>/dev/null | grep -v "FAILED" | head -10

# 5. Check mDNS
echo ""
echo "--- [5] mDNS ---"
which avahi-browse > /dev/null 2>&1 && avahi-browse -all -t 2>/dev/null | grep -i "pi\|raspberry\|eve\|adam" | head -10 || echo "avahi-browse not available"

# 6. Try SSH to last known IPs
echo ""
echo "--- [6] SSH probes ---"
for ip in 10.144.28.228 10.144.28.1 10.144.28.8 10.144.28.147 10.144.28.128; do
    result=$(sshpass -p 'raspberry' ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no pi@$ip "hostname 2>/dev/null" 2>/dev/null)
    if [ -n "$result" ]; then
        echo "  [FOUND] $ip → $result"
    fi
done

# 7. Check if Eve responds to ping on any subnet
echo ""
echo "--- [7] Ping sweep ---"
for subnet in "10.144.28" "10.98.79" "10.42.0"; do
    for host in 1 8 63 128 147 228; do
        ip="${subnet}.${host}"
        if ping -c 1 -W 1 "$ip" 2>/dev/null | grep -q "bytes from"; then
            echo "  [UP] $ip"
        fi
    done
done

echo ""
echo "=== Recovery scan complete ==="