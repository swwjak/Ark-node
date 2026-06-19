#!/bin/bash
# connect-adam-eve.sh — Establish SSH trust between Adam and Eve
# Run from Adam (10.98.79.63)

set -e

echo "=== Connecting Adam to Eve ==="
echo "Date: $(date)"

EVE_IP="10.42.0.152"
EVE_USER="pi"
EVE_PASS="kootznoowo"

# Step 1: Check if we can ping Eve
echo ""
echo "--- [1] Ping test ---"
if ping -c 1 -W 2 "$EVE_IP" 2>/dev/null | grep -q "bytes from"; then
    echo "  [OK] Eve is reachable at $EVE_IP"
else
    echo "  [FAIL] Cannot reach Eve"
    exit 1
fi

# Step 2: Check if SSH key already exists
echo ""
echo "--- [2] SSH key ---"
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "  Key exists: $(cat ~/.ssh/id_ed25519.pub | cut -c1-40)..."
else
    echo "  Generating key..."
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
    echo "  Key generated: $(cat ~/.ssh/id_ed25519.pub | cut -c1-40)..."
fi

# Step 3: Copy key to Eve
echo ""
echo "--- [3] Pushing key to Eve ---"
PUBKEY=$(cat ~/.ssh/id_ed25519.pub)

# Use sshpass to push the key
sshpass -p "$EVE_PASS" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$EVE_USER@$EVE_IP" "
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo '$PUBKEY' >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    echo 'Key installed on Eve'
" 2>&1

echo ""
echo "--- [4] Testing SSH ---"
if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$EVE_USER@$EVE_IP" "echo 'SSH_OK'; hostname; uptime -p" 2>/dev/null; then
    echo ""
    echo "=== ADAM ↔ EVE CONNECTION ESTABLISHED ==="
else
    echo ""
    echo "  [FAIL] SSH test failed. Trying password auth..."
    
    # Fallback: try sshpass
    sshpass -p "$EVE_PASS" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$EVE_USER@$EVE_IP" "echo 'SSH_PASS_OK'; hostname" 2>&1
fi