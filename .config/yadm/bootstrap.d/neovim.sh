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

# Install tree-sitter-cli (required by nvim-treesitter)
if ! command -v tree-sitter 2>&1 /dev/null; then
    if [ "$system_type" = "Darwin" ]; then
        brew install tree-sitter
    elif [ "$system_type" = "Linux" ]; then
        if ! command -v cargo 2>&1 /dev/null; then
            curl https://sh.rustup.rs -sSf | sh -s -- -y
        fi
        ~/.cargo/bin/cargo install tree-sitter-cli
    else
        echo "No installation target for $system_type for tree-sitter-cli"
    fi
fi

# Bootstrap lazy.nvim plugin manager and install all nvim plugins
if command -v nvim 2>&1 /dev/null; then
    echo "neovim: bootstrapping lazy.nvim plugins"
    nvim --headless "+Lazy! sync" +qa
fi
