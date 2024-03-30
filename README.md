# dotfiles
Dotfiles


## Default Steps/Notes

Mostly a sketchpad of stuff I installed/setup on the clean mac. 

* sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
* homebrew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
* brew bundle --file installations/Brewfile (See brewfile below)
* curl -sSL https://install.python-poetry.org | python3 -
* Add export PATH=$HOME/bin:$HOME/.local/bin:$HOME/local/bin:/usr/local/bin:$PATH to ~/.zshrc
* git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
* git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1
* sh ~/.vim_runtime/install_awesome_vimrc.sh

Install Nerd font as your terminal font for icon goodness
I like the [Jetbrains mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip) one
