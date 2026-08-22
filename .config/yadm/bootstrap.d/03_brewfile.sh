#!/bin/bash
#
# Install packages from Brewfile
#

if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
    # Install from Brewfile if it exists
    if [ -f "$HOME/installations/Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        # brew bundle exits non-zero if ANY single package fails (already
        # installed by another route, untrusted tap, stale keg, etc).
        # Those are rarely fatal, so warn and continue rather than
        # aborting the whole bootstrap run.
        if brew bundle --file="$HOME/installations/Brewfile"; then
            echo "Brewfile packages installed successfully"
        else
            echo "Warning: some Brewfile dependencies failed to install." >&2
            echo "         Review the output above; continuing bootstrap." >&2
        fi
    else
        echo "Warning: Brewfile not found at $HOME/installations/Brewfile"
    fi
else
    echo "Skipping Brewfile installation (not macOS or brew not available)"
fi
