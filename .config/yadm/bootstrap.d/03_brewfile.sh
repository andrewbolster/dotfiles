#!/bin/bash
#
# Install packages from Brewfile
#

if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
    # Install from Brewfile if it exists
    if [ -f "$HOME/installations/Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file="$HOME/installations/Brewfile"
        echo "Brewfile packages installed successfully"
    else
        echo "Warning: Brewfile not found at $HOME/installations/Brewfile"
    fi
else
    echo "Skipping Brewfile installation (not macOS or brew not available)"
fi