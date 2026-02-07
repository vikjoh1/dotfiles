#!/usr/bin/env bash

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

if [[ -n "$artist" && -n "$title" ]]; then
    echo -e "$artist - \n$title"
elif [[ -n "$title" ]]; then
    echo "$title"
fi
