#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"

NS="${NS:-media}"
TERMINAL="${TERMINAL:-kitty}"

menu() {
  pods="$(kubectl get pods -n "$NS" -o json 2>/dev/null | jq -r '.items[].metadata.name | split("-")[0]' || true)"
  [ -z "$pods" ] && exit 0

  if command -v wofi >/dev/null 2>&1; then
    choice="$(printf '%s\n' "$pods" | wofi --dmenu -p "Pods ($NS)")"
  else
    choice="$(printf '%s\n' "$pods" | rofi -dmenu -p "Pods ($NS)")"
  fi
  [ -z "${choice:-}" ] && exit 0

  exec "$TERMINAL" -e k9s -n "$NS" -c pod
}

status() {
  raw="$(kubectl get pods -n "$NS" -o json 2>/dev/null || echo '{"items":[]}')"

  count="$(jq -r '.items | length' <<<"$raw" 2>/dev/null || echo 0)"
  tooltip="$(jq -r '[.items[]? | "\(.metadata.name) - \(.status.phase // "Unknown")"] | join("\n")' \
             <<<"$raw" 2>/dev/null || echo "")"
  [ -z "$tooltip" ] && tooltip="No pods"

  jq -nc --arg c "$count" --arg t "$tooltip" \
    '{text: (" " + $c), tooltip: $t}'
}

case "${1:-}" in
  --menu) menu ;;
  *)      status ;;
esac
