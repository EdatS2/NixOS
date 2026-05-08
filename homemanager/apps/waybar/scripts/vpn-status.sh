#!/bin/bash
# VPN Manager - Check VPN status for Waybar

set -eEo pipefail

# Output JSON status for Waybar
output_status() {
  local status=$1
  local tooltip=$2
  local icon=""
  
  case $status in
    "connected")
      icon="󰌾"  # Locked icon when connected
      ;;
    "disconnected")
      icon="󰌿"  # Unlocked icon when disconnected
      ;;
    *)
      icon="󰌿"  # Default to unlocked
      ;;
  esac
  
  echo "{\"text\":\"${icon}\",\"alt\":\"${status}\",\"class\":\"${status}\",\"tooltip\":\"${tooltip}\"}"
}

# Source VPN configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Check if vpn.conf exists
if [[ ! -f "${CONFIG_DIR}/vpn.conf" ]]; then
  output_status "none" "VPN not configured"
  exit 0
fi

source "${CONFIG_DIR}/vpn.conf"

# Check if VPN_NAME is set
if [[ -z "${VPN_NAME}" ]]; then
  output_status "none" "VPN not configured"
  exit 0
fi

# Check if VPN is connected and output status for Waybar
if ip link show "${VPN_NAME}" &>/dev/null 2>&1; then
  output_status "connected" "VPN Connected: ${VPN_NAME}"
else
  output_status "disconnected" "VPN Disconnected"
fi
