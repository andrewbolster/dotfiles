#!/bin/bash
#
# Install amix/vimrc runtime (~/.vim_runtime) required by ~/.vimrc
#

set -e

VIM_RUNTIME="$HOME/.vim_runtime"

if [[ -d "$VIM_RUNTIME" ]]; then
    echo "vim_runtime: updating"
    git -C "$VIM_RUNTIME" pull --ff-only --quiet
else
    echo "vim_runtime: cloning amix/vimrc"
    git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME"
fi
