#!/bin/bash
#
# Install uv from _somewhere_
#
#

system_type=$(uname -s)
arch=$(uname -m)

if [ "$system_type" = "Darwin" ]; then
	brew install uv
elif [ "$system_type" = "Linux" ]; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
	echo "No installation target for $system_type:$arch for UV"
fi
