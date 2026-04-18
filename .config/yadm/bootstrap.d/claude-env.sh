#!/bin/bash
#
# Claude Environment-Specific Configuration
# Creates shell integration and aliases.
# MCP servers are configured via ~/.claude/settings.json alternates (yadm class system).
#

set -e

echo "🌍 Setting up Claude Code environment integration..."

# Add to .zshrc if not present
if ! grep -q "CLAUDE_CONFIG_DIR" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Claude Code CLI integration
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"

# Claude Code aliases and functions
alias claude-config='nvim ~/.claude/settings.json'
alias claude-memory='ls -la ~/.claude/memory/'
alias claude-logs='tail -f ~/.claude/logs/*.log 2>/dev/null || echo "No logs found"'

claude-backup() {
    local backup_dir="$HOME/.claude/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r "$HOME/.claude"/{settings.json,memory} "$backup_dir/" 2>/dev/null
    echo "📦 Claude settings backed up to: $backup_dir"
}
EOF
fi

# Add to .bashrc if not present
if [[ -f "$HOME/.bashrc" ]] && ! grep -q "CLAUDE_CONFIG_DIR" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'EOF'

# Claude Code CLI integration
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"
alias claude-config='nvim ~/.claude/settings.json'
alias claude-memory='ls -la ~/.claude/memory/'
EOF
fi

echo "✅ Claude environment integration complete!"
echo "🔄 Restart your shell or run 'source ~/.zshrc' to load new aliases"
echo "ℹ️  MCP servers are configured via ~/.claude/settings.json (yadm class: $(yadm config local.class || echo 'default'))"
