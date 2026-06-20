#!/bin/bash
# pi3-role-voice.sh — Setup Pi 3 as Voice node
# Run after pi3-boot.sh

set -e

echo "=== Pi 3 Voice Setup ==="

# Install voice packages
sudo apt install -y -qq espeak-ng alsa-utils sox pulseaudio-utils 2>&1 | tail -3

# Create voice directory
mkdir -p /home/pi/voice/{cache,queue}

# Create speech script
cat > /home/pi/voice/speak.sh << 'SPEAKEOF'
#!/bin/bash
# Generate speech and cache it
# Usage: speak.sh <text> [output_file]
TEXT="$1"
OUTPUT="${2:-/home/pi/voice/cache/speech_$(date +%s).wav}"
if [ -z "$TEXT" ]; then
    echo "Usage: speak.sh <text> [output_file]"
    exit 1
fi
espeak-ng "$TEXT" -w "$OUTPUT" 2>/dev/null
echo "Generated: $OUTPUT"
SPEAKEOF
chmod +x /home/pi/voice/speak.sh

# Test voice
echo "Testing voice..."
espeak-ng "Voice node online." 2>/dev/null && echo "Voice OK" || echo "Voice WARN"

echo "=== Voice setup complete ==="