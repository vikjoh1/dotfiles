#!/bin/zsh

mkdir -p "$HOME/.local/share/fonts/NerdFonts"

curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.tar.xz

tar -xvf "Meslo.tar.xz" -C "$HOME/.local/share/fonts/NerdFonts"

rm "Meslo.tar.xz"

fc-cache -fv



