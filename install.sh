#/usr/bin/env bash

if ! [ -x "$(command -v stow)" ]; then
    echo "Please install stow first" >&2
    exit 1
fi

if [ -x "$(command -v zsh)" ]; then
    echo "Linking zsh"
    stow zsh
fi

if [ -x "$(command -v nvim)" ]; then
    echo "Linking nvim"
    stow nvim
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
if [ -x "$(command -v dmenu)" ]; then 
    echo "Linking dmenu"
    stow dmenu
fi
