_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true

if [[ $OSTYPE == darwin* ]]; then
    # Set PATH, MANPATH, etc., for Homebrew.
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
