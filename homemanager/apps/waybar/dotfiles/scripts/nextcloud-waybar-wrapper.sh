#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash python3


# Path to the downloaded python script
PYTHON_SCRIPT="$HOME/.config/waybar/scripts/nextcloud-status.py"

# Run the script and capture output
# We use 'python3' to ensure it runs with the correct interpreter
OUTPUT=$(python "$PYTHON_SCRIPT" 2>&1)

# Determine status based on output
if [[ "$OUTPUT" == *"Syncing.."* ]]; then
    STATUS="syncing"
    ICON="🔄"
    TOOLTIP="Nextcloud: Syncing..."
elif [[ "$OUTPUT" == *"Up to date"* ]]; then
    STATUS="synced"
    ICON="☁️"
    TOOLTIP="Nextcloud: Up to date"
else
    # If there's an error or it's not running
    STATUS="error"
    ICON="⚠️"
    TOOLTIP="Nextcloud: Error or not running ($OUTPUT)"
fi

# Output JSON for Waybar
echo "{\"text\": \"$ICON\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$STATUS\"}"
