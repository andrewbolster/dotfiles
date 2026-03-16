
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bolster/.lmstudio/bin"
# End of LM Studio CLI section

