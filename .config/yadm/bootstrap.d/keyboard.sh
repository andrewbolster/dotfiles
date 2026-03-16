#!/usr/bin/env bash

# Bootstrap script for keyboard configuration
# Sets up PC-style Home/End key behavior on macOS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/../logs/keyboard-bootstrap.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Starting keyboard configuration bootstrap..."

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log "Not on macOS, skipping keyboard configuration"
    exit 0
fi

# Ensure KeyBindings directory exists
KEYBINDINGS_DIR="$HOME/Library/KeyBindings"
if [[ ! -d "$KEYBINDINGS_DIR" ]]; then
    log "Creating KeyBindings directory: $KEYBINDINGS_DIR"
    mkdir -p "$KEYBINDINGS_DIR"
fi

# Check if Karabiner-Elements is installed
if command -v "/Applications/Karabiner-Elements.app/Contents/MacOS/Karabiner-Elements" &> /dev/null; then
    log "Karabiner-Elements found, ensuring config directory exists"

    # Ensure Karabiner config directory exists
    KARABINER_DIR="$HOME/.config/karabiner"
    if [[ ! -d "$KARABINER_DIR" ]]; then
        log "Creating Karabiner config directory: $KARABINER_DIR"
        mkdir -p "$KARABINER_DIR"
    fi

    # If karabiner.json exists in the repo, it should already be linked by yadm
    if [[ -f "$KARABINER_DIR/karabiner.json" ]]; then
        log "Karabiner configuration found, restarting Karabiner-Elements"
        # Kill and restart Karabiner to reload config
        pkill -f "Karabiner-Elements" || true
        sleep 2
        open -a "Karabiner-Elements" || log "Warning: Could not restart Karabiner-Elements"
    else
        log "Warning: Karabiner configuration not found at $KARABINER_DIR/karabiner.json"
    fi
else
    log "Karabiner-Elements not installed, relying on DefaultKeyBinding.dict only"
    log "To install Karabiner-Elements: brew install --cask karabiner-elements"
fi

# Verify DefaultKeyBinding.dict
if [[ -f "$KEYBINDINGS_DIR/DefaultKeyBinding.dict" ]]; then
    log "DefaultKeyBinding.dict found and should be active"
else
    log "Warning: DefaultKeyBinding.dict not found at $KEYBINDINGS_DIR/DefaultKeyBinding.dict"
fi

log "Keyboard configuration bootstrap completed"
log "Note: You may need to restart applications for DefaultKeyBinding changes to take effect"