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
    echo "Linking polybar" mkdir -p "$HOME/.config/polybar"
    stow polybar -t "$HOME/.config/polybar"
fi

# We are using stack here as an indicator that we want to have xmonad, since
# we build xmonad ourselves.
if [ -x "$(command -v stack)" ]; then
    echo "Linking xmonad"
    mkdir -p "$HOME/.config/xmonad"
    stow xmonad -t "$HOME/.config/xmonad"
fi

if [ -x "$(command -v nvim)" ]; then
    echo "Linking nvim"
    mkdir -p "$HOME/.config/nvim"
    stow nvim -t "$HOME/.config/nvim/"
fi

# Touch fake file in the git user folder so we never link the whole
# directory by accident
if [ -x "$(command -v git)" ]; then
    mkdir -p "$HOME/.config/git"
    touch "$HOME/.config/git/.no_stow_dir"
    echo "Linking git"
    stow git -t "$HOME/.config/git"
fi

if [ -x "$(command -v tmux)" ]; then
    echo "Linking tmux"
    stow tmux
fi

if [ -x "$(command -v zsh)" ]; then
    echo "Linking zsh"
    stow zsh -t $HOME
fi

if [ -x "$(command -v waybar)" ]; then
    echo "Linking waybar"
    mkdir -p "$HOME/.config/waybar"
    stow waybar -t "$HOME/.config/waybar"
fi

if [ -x "$(command -v oh-my-posh)" ]; then
    echo "Linking oh-my-posh"
    OH_MY_POSH_DIR="$HOME/.config/oh-my-posh"
    mkdir -p "$OH_MY_POSH_DIR"
    stow oh-my-posh -t "$OH_MY_POSH_DIR"
fi

# if [ -x "$(command -v kitty)" ]; then
#     echo "Linking kitty"
#     mkdir -p "$HOME/.config/kitty"
#     stow kitty -t "$HOME/.config/kitty"
# fi

# Touch fake file in the systemd user folder so we never link the whole
# directory by accident
if [ -d "$HOME/.config/systemd/user" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    touch "$HOME/.config/systemd/user/.no_stow_dir"
fi

if [ -x "$(command -v rclone)" ]; then
    echo "Linking rclone services"
    stow rclone -t "$HOME/.config"
fi
