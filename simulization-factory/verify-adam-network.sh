#!/bin/bash
# verify-adam-network.sh — Test Adam's network configuration
# Run from Adam

echo "=== Adam Network Verification ==="
echo "Date: $(date)"

# 1. Can Adam reach itself?
echo ""
echo "--- Self-test ---"
ping -c 1 -W 1 127.0.0.1 > /dev/null 2>&1 && echo "[OK] Loopback" || echo "[FAIL] Loopback"
ping -c 1 -W 1 $(hostname -I | awk '{print $1}') > /dev/null 2>&1 && echo "[OK] Self IP" || echo "[FAIL] Self IP"

# 2. Can Adam reach the phone?
echo ""
echo "--- Phone test ---"
ping -c 1 -W 2 10.98.79.83 > /dev/null 2>&1 && echo "[OK] Phone (10.98.79.83)" || echo "[FAIL] Phone"

# 3. Can Adam reach internet?
echo ""
echo "--- Internet test ---"
ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1 && echo "[OK] Internet (8.8.8.8)" || echo "[FAIL] Internet"
ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1 && echo "[OK] Internet (1.1.1.1)" || echo "[FAIL] Internet (1.1.1.1)"

# 4. DNS resolution
echo ""
echo "--- DNS test ---"
dig +short google.com > /dev/null 2>&1 && echo "[OK] DNS (google.com)" || echo "[FAIL] DNS"
dig +short github.com > /dev/null 2>&1 && echo "[OK] DNS (github.com)" || echo "[FAIL] DNS (github.com)"

# 5. SSH to self
echo ""
echo "--- SSH test ---"
ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no pi@localhost "echo ok" 2>/dev/null && echo "[OK] SSH to self" || echo "[FAIL] SSH to self"

# 6. SSH to phone
echo ""
echo "--- SSH to phone ---"
sshpass -p 'raspberry' ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no pi@10.98.79.83 "echo ok" 2>/dev/null && echo "[OK] SSH to phone" || echo "[FAIL] SSH to phone"

# 7. Ollama
echo ""
echo "--- Ollama test ---"
curl -s http://127.0.0.1:11434/ > /dev/null 2>&1 && echo "[OK] Ollama (:11434)" || echo "[FAIL] Ollama"

# 8. Hermes
echo ""
echo "--- Hermes test ---"
curl -s http://127.0.0.1:8642/ > /dev/null 2>&1 && echo "[OK] Hermes (:8642)" || echo "[FAIL] Hermes"

# 9. Ethernet hub
echo ""
echo "--- Ethernet test ---"
cat /sys/class/net/eth0/carrier 2>/dev/null | grep -q "1" && echo "[OK] Ethernet link" || echo "[FAIL] Ethernet link"
ethtool eth0 2>/dev/null | grep "Speed" | head -1

# 10. WiFi AP
echo ""
echo "--- WiFi AP test ---"
cat /sys/class/net/wlan0/carrier 2>/dev/null | grep -q "1" && echo "[OK] WiFi link" || echo "[FAIL] WiFi link"
iwconfig wlan0 2>/dev/null | grep "ESSID" | head -1

echo ""
echo "=== Verification Complete ==="