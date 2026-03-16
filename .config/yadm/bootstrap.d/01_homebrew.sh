#!/bin/bash
#
# Install Homebrew if not present (macOS only)
#

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Check if brew is already installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        echo "Homebrew installed successfully"
    else
        echo "Homebrew already installed"
    fi
else
    echo "Skipping Homebrew installation (not macOS)"
fi