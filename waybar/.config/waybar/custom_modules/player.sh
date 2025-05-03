#!/usr/bin/env bash

ICON_PLAY="";  ICON_PAUSE="";  ICON_STOP=""

meta=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
state=$(playerctl status 2>/dev/null || echo "Stopped")

case $state in
  Playing) icon=$ICON_PLAY ;;
  Paused)  icon=$ICON_PAUSE ;;
  *)       icon=$ICON_STOP ;;
esac

printf '{"text":"%s %s","class":"%s"}' "$icon" "${meta:-No media}" "$state"
