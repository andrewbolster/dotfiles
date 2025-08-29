# ZSH Aliases - Andrew Bolster
# Modern location for zsh-specific aliases

# System shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts (zsh-specific improvements)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias nv='nvim'
alias vim='nvim'

# Docker shortcuts
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

# System monitoring
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'

# Network
alias ping='ping -c 5'
alias wget='wget -c'

# Tmux/Byobu
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session'

# Claude Code shortcuts
alias claude='claude -c --dangerously-skip-permissions'
alias claude-logs='find ~/.claude -name "*.log" -exec tail -f {} +'

# yadm shortcuts
alias ys='yadm status'
alias ya='yadm add'
alias yc='yadm commit'
alias yp='yadm push'
alias yl='yadm log --oneline'

# Safety aliases (require confirmation)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory jumping (if you use autojump or z)
# alias j='autojump'

# Platform-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific
    alias brew-update='brew update && brew upgrade'
    alias o='open'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific
    alias apt-update='sudo apt update && sudo apt upgrade'
    alias o='xdg-open'
fi