#!/usr/bin/env bash

set -euo pipefail

DMENU=${DMENU:-rofi -dmenu -i -p Bluetooth}

if ! bluetoothctl show >/dev/null 2>&1; then
  notify-send -u normal "Bluetooth" "No controller found"
  exit 0
fi

mapfile -t devices < <(bluetoothctl devices | awk '{print $2 " " substr($0, index($0,$3))}')
((${#devices[@]}==0)) && { notify-send -u low "Bluetooth" "No paired devices"; exit 0; }

choice="$(printf '%s\n' "${devices[@]}" | ${DMENU})" || exit 0
mac="${choice%% *}"

info="$(bluetoothctl info "$mac" 2>/dev/null || true)"
name="$(awk -F': ' '/Name/ {print $2}' <<<"$info")"
connected="no"
grep -q "Connected: yes" <<<"$info" && connected="yes"

if [[ "$connected" == "yes" ]]; then
  bluetoothctl disconnect "$mac" && notify-send -u low "Bluetooth" "Disconnected: ${name:-$mac}"
else
  bluetoothctl connect "$mac" && notify-send -u low "Bluetooth" "Connected: ${name:-$mac}"
fi
