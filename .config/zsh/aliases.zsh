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

# Claude Code
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"

alias claude='claude-titled --dangerously-skip-permissions'
alias claude-config='nvim ~/.claude/settings.json'
alias claude-mcp='~/.claude/start-mcp.sh'
alias claude-memory='ls -la ~/.claude/memory/'
alias claude-logs='find ~/.claude -name "*.log" -exec tail -f {} +'

claude-project() {
    local project_dir=${1:-$(pwd)}
    cd "$project_dir"
    claude
}

claude-backup() {
    local backup_dir="$HOME/.claude/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r "$HOME/.claude"/{settings.json,mcp-global.json,memory,todos} "$backup_dir/" 2>/dev/null
    echo "Claude settings backed up to: $backup_dir"
}

claude-reset() {
    read -p "This will reset Claude settings to defaults. Continue? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        claude-backup
        ~/.config/yadm/bootstrap.d/claude.sh
        echo "Claude settings reset to defaults"
    fi
}

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

# Byobu aliases
alias byo='byobu'
alias byos='byobu new-session'
alias byol='byobu list-sessions'
alias byoa='byobu attach'

# Copilot CLI - load shared Claude instructions as additional context
export COPILOT_CUSTOM_INSTRUCTIONS_DIRS="$HOME/.claude/shared"
