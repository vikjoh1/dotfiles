#!/bin/bash
out=$(playerctl metadata --format "{{artist}} - {{title}}" 2>/dev/null)
if [ -n "$out" ]; then
    echo "$out"
else
    echo "No music playing"
fi
