#!/bin/bash
# pi3-role-messenger.sh — Setup Pi 3 as Messenger node
# Run after pi3-boot.sh

set -e

echo "=== Pi 3 Messenger Setup ==="

# Install messenger-specific packages
pip3 install --break-system-packages paho-mqtt 2>&1 | tail -3 || true

# Create messenger directory
mkdir -p /home/pi/messenger/{queue,logs,state}

# Create state relay script
cat > /home/pi/messenger/relay.sh << 'RELAYEOF'
#!/bin/bash
# Relay state messages between nodes
# Usage: ./relay.sh <target_ip> <message>
TARGET="$1"
MSG="$2"
if [ -z "$TARGET" ] || [ -z "$MSG" ]; then
    echo "Usage: relay.sh <target_ip> <message>"
    exit 1
fi
echo "[$(date -Iseconds)] $MSG" >> /home/pi/messenger/logs/relay.log
echo "Relayed to $TARGET: $MSG"
RELAYEOF
chmod +x /home/pi/messenger/relay.sh

echo "=== Messenger setup complete ==="