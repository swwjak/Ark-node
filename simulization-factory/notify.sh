#!/bin/bash
# notify.sh — Push notification to phone via Termux:API
# Usage: notify.sh "Title" "Content"

TITLE="${1:-The Tree}"
CONTENT="${2:-Notification from Hermes}"

# Method 1: termux-notification with timeout
timeout 5 termux-notification --title "$TITLE" --content "$CONTENT" 2>/dev/null &
NOTIF_PID=$!

# Method 2: Also try am broadcast as fallback
# This sends an Android broadcast that any app can pick up
am broadcast -a com.termux.NOTIFICATION --es title "$TITLE" --es content "$CONTENT" 2>/dev/null &
BROAD_PID=$!

wait $NOTIF_PID 2>/dev/null
wait $BROAD_PID 2>/dev/null

echo "Notification sent: $TITLE - $CONTENT"