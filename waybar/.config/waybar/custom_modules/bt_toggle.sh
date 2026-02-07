#!/usr/bin/env bash

set -e

if ! bluetoothctl show >/dev/null 2>&1; then
  notify-send -u normal "Bluetooth" "No controller found"
  exit 0
fi

power=$(bluetoothctl show | awk -F': ' '/Powered/ {print $2}')
if [[ "$power" == "yes" ]]; then
  bluetoothctl power off
  notify-send -u low "Bluetooth" "Powered off"
else
  bluetoothctl power on
  notify-send -u low "Bluetooth" "Powered on"
fi
