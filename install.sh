#!/bin/sh

if ! [ -x "$(command -v stow)" ]; then
    echo "Please install stow first" >&2
    exit 1
fi

echo "Linking scripts"
mkdir -p "$HOME/.local/bin"
stow scripts

if [ -x "$(command -v fish)" ]; then
    echo "Linking fish"
    mkdir -p "$HOME/.config/fish"
    stow fish -t "$HOME/.config/fish/"
fi

if [ -x "$(command -v qtile)" ]; then
    echo "Linking qtile"
    mkdir -p "$HOME/.config/qtile"
    stow qtile -t "$HOME/.config/qtile/"
fi

if [ -x "$(command -v nvim)" ]; then
    echo "Linking nvim"
    mkdir -p "$HOME/.config/nvim"
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

