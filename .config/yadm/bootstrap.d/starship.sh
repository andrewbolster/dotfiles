#!/bin/bash
#
# Install starship from _somewhere_
#
#

system_type=$(uname -s)
arch=$(uname -m)

if [ "$system_type" = "Darwin" ]; then
	brew install starship
elif [ "$system_type" = "Linux" ]; then
  curl -sS https://starship.rs/install.sh | sh 
else
	echo "No installation target for $system_type:$arch for Starship.rs"
fi
