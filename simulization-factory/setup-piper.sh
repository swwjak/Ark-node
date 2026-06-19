#!/bin/bash
# setup-piper.sh — Install Piper TTS on Adam or Eve
# Run on each Pi after setup-sensory.sh

NODE_NAME="${1:?Usage: setup-piper.sh [adam|eve]}"

echo "=== Setting up Piper TTS on $NODE_NAME ==="

# Check if piper is already installed
if command -v piper > /dev/null 2>&1; then
    echo "Piper already installed: $(piper --version 2>&1)"
else
    echo "Installing Piper..."
    # Download Piper binary for aarch64
    PIPER_URL="https://github.com/rhasspy/piper/releases/download/v1.2.0/piper_aarch64.tar.gz"
    cd /tmp
    wget -q "$PIPER_URL" -O piper.tar.gz 2>&1
    tar xzf piper.tar.gz
    sudo mv piper /usr/local/bin/piper
    sudo chmod +x /usr/local/bin/piper
    rm -f piper.tar.gz
    echo "Piper installed: $(piper --version 2>&1)"
fi

# Download voice models
echo "Installing voice models..."
PIPER_DIR="/usr/local/share/piper"
sudo mkdir -p "$PIPER_DIR"

# Download a voice model (en_US-lessac-medium)
MODEL_URL="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US-lessac-medium/en_US-lessac-medium.onnx"
wget -q "$MODEL_URL" -O "$PIPER_DIR/en_US-lessac-medium.onnx" 2>&1

# Download voice config
CONFIG_URL="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US-lessac-medium/en_US-lessac-medium.onnx.json"
wget -q "$CONFIG_URL" -O "$PIPER_DIR/en_US-lessac-medium.onnx.json" 2>&1

echo "Voice model installed."

# Test
echo ""
echo "=== Piper Test ==="
echo "Hello, I am $NODE_NAME." | piper --model "$PIPER_DIR/en_US-lessac-medium.onnx" --output_file /tmp/voice-test.wav 2>&1
if [ -f /tmp/voice-test.wav ]; then
    aplay /tmp/voice-test.wav 2>&1 | head -3
    echo "Voice test OK"
else
    echo "Voice test FAILED"
fi

echo ""
echo "=== Piper setup complete on $NODE_NAME ==="