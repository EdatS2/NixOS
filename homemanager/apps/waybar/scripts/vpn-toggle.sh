#!/bin/bash
# VPN Manager - Toggle VPN connection on/off

LOCK_FILE="/tmp/vpn-toggle.lock"

if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

sleep 0.3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Source config and check if VPN_NAME is set
if [ ! -f "${CONFIG_DIR}/vpn.conf" ]; then
  notify-send "VPN Error" "Configuration file not found"
  exit 1
fi

source "${CONFIG_DIR}/vpn.conf"

if [ -z "${VPN_NAME}" ]; then
  notify-send "VPN Error" "VPN_NAME not set in configuration"
  exit 1
fi

if systemctl is-active --quiet wg-quick@"${VPN_NAME}".service; then
  # Disconnect using pkexec
  pkexec systemctl stop wg-quick@"${VPN_NAME}".service 2>/dev/null || true
  sleep 0.5
  pkexec ip link delete "${VPN_NAME}" 2>/dev/null || true
  notify-send "VPN OFF" "${VPN_NAME}"
else
  # Connect using pkexec
  pkexec systemctl start wg-quick@"${VPN_NAME}".service 2>/dev/null || {
    pkexec wg-quick up "${VPN_NAME}"
  }
  sleep 0.5
  notify-send "VPN ON" "${VPN_NAME}"
fi
