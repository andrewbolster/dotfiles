#!/bin/bash
#
# Install Nerdfonts from _somewhere_
#
#

system_type=$(uname -s)
arch=$(uname -m)

if [ "$system_type" = "Darwin" ]; then
  brew install font-jetbrains-mono-nerd-font
	
elif [ "$system_type" = "Linux" ]; then
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

else
	echo "No installation target for $system_type for Nerdfonts"
fi
