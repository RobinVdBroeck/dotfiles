#!/bin/sh

if ! [ -x "$(command -v stow)" ]; then
    echo "Please install stow first" >&2
    exit 1
fi

echo "Linking scripts"
stow scripts

if [ -x "$(command -v fish)" ]; then
    echo "Linking fish"
    stow fish -t "$HOME/.config/fish/"
fi

if [ -x "$(command -v nvim)" ]; then
    echo "Linking nvim"
    stow nvim -t "$HOME/.config/nvim/"
fi

if [ -x "$(command -v git)" ]; then
    echo "Linking git"
    stow git
fi

if [ -x "$(command -v tmux)" ]; then
    echo "Linking tmux"
    stow tmux
fi

if [ -x "$(command -v alacritty)" ]; then
    echo "Linking alacritty"
    stow alacritty
fi

