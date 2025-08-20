#!/bin/bash
#
# Claude Environment-Specific Configuration
# Creates environment variables and shell integration
#

set -e

echo "🌍 Setting up Claude Code environment integration..."

# Add Claude Code to shell PATH if not already there
CLAUDE_PATH_EXPORT='export PATH="$HOME/.local/bin:$PATH"'

# Add to .zshrc if not present
if ! grep -q "claude" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Claude Code CLI integration
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"

# Claude Code aliases and functions
alias claude-config='nvim ~/.claude/settings.json'
alias claude-mcp='~/.claude/start-mcp.sh'
alias claude-memory='ls -la ~/.claude/memory/'
alias claude-logs='tail -f ~/.claude/logs/*.log 2>/dev/null || echo "No logs found"'

# Function to quickly start Claude in project mode
claude-project() {
    local project_dir=${1:-$(pwd)}
    echo "🚀 Starting Claude Code in project: $project_dir"
    cd "$project_dir"
    claude-code
}

# Function to backup Claude settings
claude-backup() {
    local backup_dir="$HOME/.claude/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r "$HOME/.claude"/{settings.json,mcp-global.json,memory,todos} "$backup_dir/" 2>/dev/null
    echo "📦 Claude settings backed up to: $backup_dir"
}

# Function to reset Claude settings to defaults
claude-reset() {
    read -p "⚠️  This will reset Claude settings to defaults. Continue? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        claude-backup
        ~/.config/yadm/bootstrap.d/claude.sh
        echo "🔄 Claude settings reset to defaults"
    fi
}
EOF
fi

# Add to .bashrc if not present  
if [[ -f "$HOME/.bashrc" ]] && ! grep -q "claude" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'EOF'

# Claude Code CLI integration
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"

# Claude Code aliases
alias claude-config='nvim ~/.claude/settings.json'
alias claude-mcp='~/.claude/start-mcp.sh'
alias claude-memory='ls -la ~/.claude/memory/'
EOF
fi

# Create systemd user service for MCP servers (optional)
mkdir -p "$HOME/.config/systemd/user"

cat > "$HOME/.config/systemd/user/claude-mcp.service" << 'EOF'
[Unit]
Description=Claude Code MCP Servers
After=network.target

[Service]
Type=simple
Environment=HOME=%h
Environment=PATH=%h/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=%h/.claude/start-mcp.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Create a desktop entry for Claude Code (if in GUI environment)
if [[ -n "${DISPLAY:-$WAYLAND_DISPLAY}" ]]; then
    mkdir -p "$HOME/.local/share/applications"
    
    cat > "$HOME/.local/share/applications/claude-code.desktop" << 'EOF'
[Desktop Entry]
Name=Claude Code
Comment=AI-powered coding assistant
Exec=gnome-terminal -- claude-code
Icon=terminal
Terminal=false
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF
fi

# Set up completion for Claude Code (if available)
if command -v claude-code &> /dev/null; then
    # Try to set up shell completion
    if claude-code completion --help &> /dev/null; then
        mkdir -p "$HOME/.local/share/zsh/site-functions"
        claude-code completion zsh > "$HOME/.local/share/zsh/site-functions/_claude-code" 2>/dev/null || true
        
        mkdir -p "$HOME/.local/share/bash-completion/completions"
        claude-code completion bash > "$HOME/.local/share/bash-completion/completions/claude-code" 2>/dev/null || true
    fi
fi

echo "✅ Claude environment integration complete!"
echo "🔄 Restart your shell or run 'source ~/.zshrc' to load new aliases"