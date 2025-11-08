#!/usr/bin/env bash

set -euo pipefail

ICON_SPK_LOW=""
ICON_SPK_MED=""
ICON_SPK_HIGH=""
ICON_BT=""
ICON_MIC_MUTE=""
ICON_MUTE=""

ICON_PLAY=""; ICON_PAUSE=""; ICON_STOP=""

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | sed -n 's/.* \([0-9]\{1,3\}\)%.*$/\1/p' | head -n1
}

get_muted() {
  pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

is_bt_sink() {
  pact list sinks | awk '
    BEGIN{RS="Sink #"; bt="no"}
    NR>1{
      if ($0 ~ /Name: .*bluez|device\.api = "bluez"/) { bt="yes" }
      if ($0 ~ /Default Sink: yes/ || $0 ~ /^\s*$/) {}
    }
    END{print bt}
  ' 2>/dev/null || echo "no"
}

vol="$(get_volume 2>/dev/null || echo 0)"
muted="$(get_muted 2>/dev/null || echo no)"
btflag="$(is_bt_sink 2>/dev/null || echo no)"

if [[ "$muted" == "yes" ]]; then
  spk="$ICON_MUTE"
else
  if (( vol < 34 )); then spk="$ICON_SPK_LOW"
  elif (( vol < 67 )); then spk="$ICON_SPK_MED"
  else spk="$ICON_SPK_HIGH"
  fi
fi
[[ "$btflag" == "yes" ]] && spk="$spk $ICON_BT"

meta="$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || true)"
state="$(playerctl status 2>/dev/null || echo "Stopped")"
case "$state" in
  Playing) picon="$ICON_PAUSE" ;;
  Paused)  picon="$ICON_PLAY" ;;
  *)       picon="$ICON_PLAY" ;;
esac
[[ -z "${meta// }" ]] && meta="No media"

classes=()
[[ "$muted" == "yes" ]] && classes+=("muted")
case "$state" in
  Playing|Paused|Stopped) classes+=("$state");;
esac
[[ "$btflag" == "yes" ]] && classes+=("bluetooth")

text="$vol% $spk | $picon $meta"

sink_name="$(pactl info 2>/dev/null | awk -F': ' '/Default Sink/ {print $2}')"
tooltip_lines=()
tooltip_lines+=("Volume: $vol%  (Muted: $muted)")
tooltip_lines+=("Sink: ${sink_name:-unknown}")
tooltip_lines+=("Player: $state")
tooltip_lines+=("$meta")
tooltip="$(printf "%s\n" "${tooltip_lines[@]}")"

jq -cn --arg text "$text" \
       --arg tooltip "$tooltip" \
       --arg class "$(IFS=' '; echo "${classes[*]}")" \
  '{text:$text, tooltip:$tooltip, class:($class|split(" ")|map(select(.!="")))}'
