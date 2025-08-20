if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Added by `rbenv init` on Tue Jun 10 13:54:36 BST 2025
if command -v rbenv >/dev/null; then
    eval "$(rbenv init - --no-rehash zsh)"
fi
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
