#!/usr/bin/env bash

cache=/tmp/hyprlock-cover

url=$(playerctl --player=spotify metadata mpris:artUrl 2>/dev/null || true)

if [[ -z $url ]]; then
  printf /usr/share/blank.png
  exit 0
fi

if [[ ! -f $cache.png ]] || [[ $(<"$cache.url") != "$url" ]]; then
    tmpjpg=$cache.jpg
    curl -fsSL "$url" -o "$tmpjpg" || exit 1
    convert "$tmpjpg" "$cache.png" 
    echo "$url" >"$cache.url"
    rm -f "$tmpjpg"
fi

printf '%s' "$cache.png"

