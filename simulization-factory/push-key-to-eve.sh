#!/bin/bash
# Push Adam's SSH public key to Eve
# Run from Adam

ssh -o ConnectTimeout=5 pi@10.42.0.152 'mkdir -p ~/.ssh && chmod 700 ~/.ssh' 2>&1 || true

# Use sshpass to provide password, push the key
sshpass -p 'raspberry' ssh-copy-id -o ConnectTimeout=5 -o StrictHostKeyChecking=no pi@10.42.0.152 2>&1

echo "---"
# Verify
ssh -o ConnectTimeout=5 pi@10.42.0.152 'echo SSH_OK' 2>&1