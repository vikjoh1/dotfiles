#!/usr/bin/env bash

set -euo pipefail

havectl() { command -v bluetoothctl >/dev/null 2>&1; }

if ! havectl; then
  echo '{"text":"","tooltip":"bluetoothctl not found","class":"error"}'
  exit 0
fi

if ! bluetoothctl show >/dev/null 2>&1; then
  echo '{"text":"","tooltip":"No Bluetooth controller","class":"off"}'
  exit 0
fi

power=$(bluetoothctl show | awk -F': ' '/Powered/ {print $2}')
discoverable=$(bluetoothctl show | awk -F': ' '/Discoverable/ {print $2}')

connected_names=()
while read -r _ mac _; do
  [[ -z "${mac:-}" ]] && continue
  info="$(bluetoothctl info "$mac" 2>/dev/null || true)"
  if grep -q "Connected: yes" <<<"$info"; then
    name=$(awk -F': ' '/Name/ {print $2}' <<<"$info")
    [[ -n "$name" ]] && connected_names+=("$name")
  fi
done < <(bluetoothctl devices)

icon=""
classes=()
tooltip_lines=()

if [[ "$power" == "yes" ]]; then
  classes+=("on")
  [[ "$discoverable" == "yes" ]] && classes+=("discoverable")
else
  classes+=("off")
fi

if ((${#connected_names[@]} > 0)); then
  classes+=("connected")
fi

if [[ "$power" != "yes" ]]; then
  text="$icon off"
else
  if ((${#connected_names[@]} == 0)); then
    text="$icon"
  elif ((${#connected_names[@]} == 1)); then
    text="$icon ${connected_names[0]}"
  else
    text="$icon ${connected_names[0]} +$(( ${#connected_names[@]} - 1 ))"
  fi
fi

tooltip_lines+=("Power: $power")
tooltip_lines+=("Discoverable: $discoverable")
if ((${#connected_names[@]} > 0)); then
  tooltip_lines+=("Connected:")
  for n in "${connected_names[@]}"; do tooltip_lines+=(" • $n"); done
else
  tooltip_lines+=("Connected: none")
fi
tooltip=$(printf "%s\n" "${tooltip_lines[@]}")

jq -cn --arg text "$text" --arg tooltip "$tooltip" --arg class "$(IFS=' '; echo "${classes[*]}")" \
  '{text:$text, tooltip:$tooltip, class:($class|split(" ")|map(select(.!="")))}'
