#!/bin/bash

# Clone the Git repo (if not done already)
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/robinvdbroeck/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles" || exit

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Please install Nix first."
    exit 1
fi

# Check if there are any uncommitted changes
if [[ -n $(git diff --name-only) ]]; then
    echo "You have unstaged changes in your Git repository."
    echo "Please stage or stash your changes before proceeding."
    echo "Nix ignore all changes that are not commited"
    exit 1
fi

# Nix configuration file path
NIX_CONF_DIR="$HOME/.config/nix"
NIX_CONF_FILE="$NIX_CONF_DIR/nix.conf"

# Check if the configuration file exists and append settings if not
if [ -f "$NIX_CONF_FILE" ]; then
    # Create the configuration directory if it doesn't exist
    mkdir -p "$NIX_CONF_DIR"
    echo "Nix configuration file already exists."
else
    echo "Creating Nix configuration file..."
    echo "experimental-features = nix-command flakes" > "$NIX_CONF_FILE"
    echo "Nix configuration file created at: $NIX_CONF_FILE"
fi

# Print the current Nix configuration for verification
# echo "Current Nix configuration:"
# cat "$NIX_CONF_FILE"

# Detect the OS and set system accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Setting up macOS environment with Flakes"
    config="darwin"
elif grep -qi microsoft /proc/version; then
    # WSL (Ubuntu/Linux)
    echo "Setting up WSL environment with Flakes"
    config="wsl"
else
    echo "Unsupported system"
    exit 1
fi

# Run the Home Manager configuration using the Flake
nix run home-manager/master -- switch --flake ".#$config"

echo "Bootstrap completed."
