#!/bin/bash

# Path to your Nextcloud log (based on your previous find output)
LOG_FILE="/home/kusanagi/Nextcloud/.nextcloudsync.log"

# Check if Nextcloud process is running
if ! pgrep -x "nextcloud" > /dev/null; then
    echo '{"text": "☁️", "tooltip": "Nextcloud is not running", "class": "not-running"}'
    exit 0
fi

# Default status
STATUS="synced"
MESSAGE="Nextcloud: Synced"

# Check the log for recent activity or errors
# This is a heuristic approach since we can't query the GUI directly
if [ -f "$LOG_FILE" ]; then
    # Check for "error" or "failed" in the last 50 lines
    if tail -n 50 "$LOG_FILE" | grep -iqE "error|failed|critical"; then
        STATUS="error"
        MESSAGE="Nextcloud: Error detected in logs"
    # Check for "syncing" or "uploading/downloading" patterns
    elif tail -n 20 "$LOG_FILE" | grep -iqE "sync|upload|download|transfer"; then
        STATUS="syncing"
        MESSAGE="Nextcloud: Syncing..."
    fi
fi

# Output JSON for Waybar
echo "{\"text\": \"☁️\", \"tooltip\": \"$MESSAGE\", \"class\": \"$STATUS\"}"
