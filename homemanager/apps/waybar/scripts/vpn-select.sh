#!/bin/bash
# VPN Manager - Select and switch between VPN configurations

set -eEo pipefail

# Configuration - use ~/.wg instead of /etc/wireguard
CONFIGS_PATH="$HOME/.wg"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Find available VPN configurations
mapfile -t configs < <(find "${CONFIGS_PATH}" -maxdepth 1 -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort)

if [[ ${#configs[@]} -eq 0 ]]; then
  notify-send "VPN Manager" "No WireGuard configurations found in ${CONFIGS_PATH}"
  exit 1
fi

# If only one config exists, no need to select
if [[ ${#configs[@]} -eq 1 ]]; then
  notify-send "VPN Manager" "Only one VPN configuration available: ${configs[0]}"
  exit 0
fi

# Present a selection menu using wofi (since you have it installed)
if command -v wofi &> /dev/null; then
  vpn_name=$(printf '%s\n' "${configs[@]}" | wofi -dmenu -p "Select VPN")
elif command -v rofi &> /dev/null; then
  vpn_name=$(printf '%s\n' "${configs[@]}" | rofi -dmenu -p "Select VPN")
elif command -v dmenu &> /dev/null; then
  vpn_name=$(printf '%s\n' "${configs[@]}" | dmenu -p "Select VPN:")
else
  # Terminal fallback
  echo "Select a VPN configuration (0 to cancel):"
  select vpn_name in "${configs[@]}"; do
    if [[ "${REPLY}" == "0" ]]; then
      echo "Selection cancelled"
      exit 0
    fi
    
    if [[ -n "${vpn_name}" ]]; then
      break
    else
      echo "Invalid selection."
    fi
  done
fi

# Exit if no selection was made
if [[ -z "${vpn_name}" ]]; then
  exit 0
fi

# Get the current VPN name
source "${CONFIG_DIR}/vpn.conf"
CURRENT_VPN="${VPN_NAME}"

# If same VPN selected, do nothing
if [[ "${vpn_name}" == "${CURRENT_VPN}" ]]; then
  notify-send "VPN Manager" "Already using ${vpn_name}"
  exit 0
fi

# Update vpn.conf
echo "VPN_NAME=\"${vpn_name}\"" > "${CONFIG_DIR}/vpn.conf"

# If a VPN is connected, switch to the new one using pkexec
if ip link show "${CURRENT_VPN}" &>/dev/null 2>&1; then
  notify-send "VPN Manager" "Switching from ${CURRENT_VPN} to ${vpn_name}..."
  
  # Stop current VPN with pkexec
  pkexec systemctl stop wg-quick@"${CURRENT_VPN}".service 2>/dev/null || {
    pkexec ip link delete "${CURRENT_VPN}" 2>/dev/null || true
  }
  
  # Start new VPN with pkexec
  pkexec systemctl start wg-quick@"${vpn_name}".service 2>/dev/null || {
    pkexec wg-quick up "${vpn_name}"
  }
  
  notify-send "VPN Manager" "Connected to ${vpn_name}"
else
  notify-send "VPN Manager" "VPN configuration changed to ${vpn_name}"
fi

# Update Waybar
pkill -RTMIN+8 waybar 2>/dev/null || true
