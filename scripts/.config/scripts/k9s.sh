#!/usr/bin/env bash

TERMINAL="${TERMINAL:-kitty}"

menu() {
  pods="$(kubectl get pods -A -o json 2>/dev/null | jq -r '.items[].metadata.name | split("-")[0] | split("-")[0]' || true)"
  [[ -z "$pods" ]] && exit 0
  exec "$TERMINAL" -e k9s -A -c pod
}

status() {
  raw="$(kubectl get pods -A -o json 2>/dev/null || echo '{"items":[]}')"

  count="$(jq -r '.items | length' <<<"$raw" 2>/dev/null || echo 0)"
  tooltip="$(jq -r '[.items[]? | "\(.metadata.name | split("-")[0]) - \(.status.phase // "Unknown")"] | join("\n")' \
             <<<"$raw" 2>/dev/null || echo "")"
  [[ -z "$tooltip" ]] && tooltip="No pods"

  jq -nc --arg c "$count" --arg t "$tooltip" \
    '{text: (" " + $c), tooltip: $t}'
}

case "${1:-}" in
  --menu) menu ;;
  *)      status ;;
esac
