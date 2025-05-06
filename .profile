# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

sourceadd() {
    if [ -d "$1" ]; then
        source "$1"
    fi
}

pathadd() {
    if [ -d "$1" ]; then
        if [[ ":$PATH:" != *":$1:"*  ]]; then
            export PATH="$1:$PATH"
        fi
    fi
}

pathadd "/opt/homebrew/bin"
pathadd "$HOME/bin"
pathadd "$HOME/.local/bin"

sourceadd "$HOME/.cargo/env"

export PROFILE_SOURCED=1
