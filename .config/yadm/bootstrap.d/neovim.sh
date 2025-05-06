#!/bin/bash
#
# Install Neovim from _somewhere_
#
#

system_type=$(uname -s)
arch=$(uname -m)
if ! command -v nvim 2>&1 /dev/null; then
    if [ "$system_type" = "Darwin" ]; then
        brew install neovim
    elif [ "$system_type" = "Linux" ]; then
        if ! command -v cargo 2>&1 /dev/null; then
            curl https://sh.rustup.rs -sSf | sh -s -- -y
        fi
        ~/.cargo/bin/cargo install bob-nvim
        ~/.cargo/bin/bob install latest
    else
        echo "No installation target for $system_type for NeoVim"
    fi
fi
