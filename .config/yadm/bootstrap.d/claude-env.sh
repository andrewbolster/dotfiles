#!/bin/bash
#
# Claude Environment-Specific Configuration
# Creates environment variables and shell integration
#

set -e

echo "🌍 Setting up Claude Code environment integration..."

# Add Claude Code to shell PATH if not already there
CLAUDE_PATH_EXPORT='export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"'

# Add to .zshrc if not present
if ! grep -q "claude" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Claude Code CLI integration
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
export CLAUDE_CONFIG_DIR="$HOME/.claude"

# Claude Code MCP Environment Variables
# Get your Tavily API key from: https://app.tavily.com/home
export TAVILY_API_KEY="${TAVILY_API_KEY}"

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
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
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

# Configure Claude MCP servers if claude command is available
if command -v claude &> /dev/null; then
    echo "🔧 Configuring Claude MCP servers..."
    
    
    # Add service-mcp with authentication if token is available
    if [[ -n "${MCP_STATIC_ACCESS_TOKEN:-}" ]]; then
        echo "🔑 MCP_STATIC_ACCESS_TOKEN found, configuring authenticated service-mcp..."
        claude mcp add service-mcp \
            --transport http \
            --scope user \
            --header "Authorization: Bearer ${MCP_STATIC_ACCESS_TOKEN}" \
            "https://service-mcp-app.nicefield-9cf5f7f2.eastus.azurecontainerapps.io/mcp/" || echo "⚠️  Failed to add service-mcp (may already exist)"
        echo "✅ service-mcp configured with authentication"
    else
        echo "⚠️  MCP_STATIC_ACCESS_TOKEN not found"
        echo "   To configure service-mcp with authentication, set:"
        echo "   export MCP_STATIC_ACCESS_TOKEN=<your-token>"
        echo "   Then re-run: yadm bootstrap"
        echo ""
        echo "🔓 Adding development service-mcp without authentication..."
        claude mcp add service-mcp-dev \
            --transport http \
            --scope user \
            "https://mcp.labs.blackduck.com/mcp/" || echo "⚠️  Failed to add service-mcp-dev (may already exist)"
        echo "✅ service-mcp-dev configured (no authentication)"
    fi
    
    # Add other MCP servers (these don't require special tokens)
    echo "📦 Adding standard MCP servers..."

    # Memory server
    claude mcp add memory --scope user -- \
        npx -y @modelcontextprotocol/server-memory || echo "⚠️  Failed to add memory server (may already exist)"

    # Filesystem server (platform-agnostic)
    claude mcp add filesystem --scope user -- \
        npx -y @modelcontextprotocol/server-filesystem "$HOME" || echo "⚠️  Failed to add filesystem server (may already exist)"

    # Tavily web search server (requires TAVILY_API_KEY)
    if [[ -n "${TAVILY_API_KEY:-}" ]]; then
        claude mcp add tavily --scope user \
            -e "TAVILY_API_KEY=${TAVILY_API_KEY}" -- \
            npx -y tavily-mcp || echo "⚠️  Failed to add tavily server (may already exist)"
        echo "✅ tavily configured with API key"
    else
        echo "⚠️  TAVILY_API_KEY not set, skipping tavily server"
        echo "   Set TAVILY_API_KEY in your environment and re-run bootstrap"
    fi

    # Vantage cloud cost management server (OAuth authentication)
    claude mcp add vantage --scope user \
        --transport sse https://mcp.vantage.sh/sse || echo "⚠️  Failed to add vantage server (may already exist)"

    # Atlassian server (SSE transport)
    claude mcp add atlassian --scope user \
        --transport sse https://mcp.atlassian.com/v1/sse || echo "⚠️  Failed to add atlassian server (may already exist)"
    
    echo "✅ MCP servers configuration complete"
    echo "🔍 Run 'claude mcp list' to see configured servers"
else
    echo "⚠️  Claude command not found in PATH"
    echo "   MCP servers will not be auto-configured"
    echo "   Ensure Claude Code is properly installed and in PATH"
fi

echo "✅ Claude environment integration complete!"
echo "🔄 Restart your shell or run 'source ~/.zshrc' to load new aliases"