#!/bin/bash
#
# Install Neovim from _somewhere_
#
#

system_type=$(uname -s)
arch=$(uname -m)

if [ "$system_type" = "Darwin" ]; then
	brew install neovim
elif [ "$system_type" = "Linux" ]; then
	if [ "$arch" = "aarch64" ]; then
		echo "No installation target for $system_type:$arch for Neovim; check https://github.com/MordechaiHadad/bob/issues/181 for updates"
	else
		curl https://sh.rustup.rs -sSf | sh -s -- -y
		 ~/.cargo/bin/cargo install bob-nvim
		 ~/.cargo/bin/bob install latest
	fi

else
	echo "No installation target for $system_type for NeoVim"
fi
