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

if [ -x "$(command -v polybar)" ]; then
    echo "Linking polybar"
    mkdir -p "$HOME/.config/polybar"
    stow polybar -t "$HOME/.config/polybar"
fi

if [ -x "$(command -v xmonad)" ]; then
    echo "Linking xmonad"
    mkdir -p "$HOME/.config/xmonad"
    stow xmonad -t "$HOME/.config/xmonad"
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

