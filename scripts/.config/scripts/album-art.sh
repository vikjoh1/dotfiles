#!/usr/bin/env bash

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/album-art"
CACHE_FILE="$CACHE_DIR/current.jpg"

mkdir -p "$CACHE_DIR"

art_url=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -z "$art_url" ]]; then
  rm -f "$CACHE_FILE"
  exit 0
fi

if [[ "$art_url" == file://* ]]; then
  file_path="${art_url#file://}"
  if [[ -f "$file_path" ]]; then
    cp "$file_path" "$CACHE_FILE"
    echo "$CACHE_FILE"
  fi
  exit 0
fi

if [[ "$art_url" == http* ]]; then
  url_hash=$(echo -n "$art_url" | md5sum | cut -d' ' -f1)
  hash_file="$CACHE_DIR/url_hash"

  if [[ ! -f "$hash_file" ]] || [[ "$(cat "$hash_file")" != "$url_hash" ]]; then
    curl -s -o "$CACHE_FILE" "$art_url"
    echo "$url_hash" > "$hash_file"
  fi

  if [[ -f "$CACHE_FILE" ]]; then
    echo "$CACHE_FILE"
  fi
fi
