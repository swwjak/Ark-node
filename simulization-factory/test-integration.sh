#!/bin/bash
# test-integration.sh — Test Adam and Eve integration
# Run from phone

echo "=== ADAM INTEGRATION TEST ==="

# 1. Set Adam face to speaking
ssh -o ConnectTimeout=5 pi@10.98.79.10 'echo "{\"mode\":\"speaking\",\"message\":\"Testing\",\"sub\":\"Integration test\"}" > /tmp/adam_face_state.json' 2>&1

# 2. Make Adam speak
ssh -o ConnectTimeout=5 pi@10.98.79.10 'espeak-ng -v "Hello from Adam. Integration test complete." -w /tmp/adam-test.wav 2>&1; aplay /tmp/adam-test.wav 2>&1 | head -3' 2>&1

sleep 2

# 3. Set Adam face to idle
ssh -o ConnectTimeout=5 pi@10.98.79.10 'echo "{\"mode\":\"idle\",\"message\":\"adam\",\"sub\":\"Ready\"}" > /tmp/adam_face_state.json' 2>&1

echo ""
echo "=== EVE INTEGRATION TEST ==="

# 1. Set Eve face to speaking
ssh -o ConnectTimeout=5 pi@10.98.79.228 'echo "{\"mode\":\"speaking\",\"message\":\"Testing\",\"sub\":\"Integration test\"}" > /tmp/eve_face_state.json' 2>&1

# 2. Make Eve speak
ssh -o ConnectTimeout=5 pi@10.98.79.228 'espeak-ng -v "Hello from Eve. Integration test complete." -w /tmp/eve-test.wav 2>&1; aplay /tmp/eve-test.wav 2>&1 | head -3' 2>&1

sleep 2

# 3. Set Eve face to idle
ssh -o ConnectTimeout=5 pi@10.98.79.228 'echo "{\"mode\":\"idle\",\"message\":\"eve\",\"sub\":\"Ready\"}" > /tmp/eve_face_state.json' 2>&1

echo ""
echo "=== INTEGRATION TEST COMPLETE ==="