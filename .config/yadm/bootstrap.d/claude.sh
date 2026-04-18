#!/bin/bash
#
# Claude Code Configuration Bootstrap
# Sets up default Claude settings and permissions
# Note: MCP servers are configured in claude-env.sh via `claude mcp add`
#

set -e

echo "🤖 Configuring Claude Code..."

# Ensure .claude directory exists
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.claude/memory"

# Create default global settings (if it doesn't exist)
if [[ ! -f "$HOME/.claude/settings.json" ]]; then
    echo "📝 Creating default settings.json..."
    cat > "$HOME/.claude/settings.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(systemctl list-units:*)",
      "Bash(nginx:*)",
      "Bash(nvim:*)",
      "Bash(yadm status:*)",
      "Bash(yadm add:*)",
      "Bash(git status:*)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(docker ps:*)",
      "Bash(docker logs:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(which:*)",
      "Bash(ps:*)",
      "Bash(top:*)",
      "Bash(htop:*)",
      "Bash(df:*)",
      "Bash(du:*)",
      "Bash(free:*)",
      "Bash(uptime:*)",
      "Bash(whoami:*)",
      "Bash(pwd:*)",
      "Bash(echo:*)",
      "Bash(curl --version:*)",
      "Bash(python --version:*)",
      "Bash(node --version:*)",
      "Bash(npm --version:*)",
      "Bash(uv --version:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(sudo rm:*)",
      "Bash(format:*)",
      "Bash(mkfs:*)",
      "Bash(dd:*)",
      "WebSearch"
    ]
  },
  "env": {},
  "hooks": {}
}
EOF
else
    echo "⚠️  settings.json already exists, skipping creation"
fi

# Create or update settings.local.json with local-specific permissions
if [[ ! -f "$HOME/.claude/settings.local.json" ]]; then
    echo "📝 Creating settings.local.json..."
    cat > "$HOME/.claude/settings.local.json" << 'EOF'
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
EOF
else
    echo "⚠️  settings.local.json already exists, skipping creation"
fi

# Create default environment file template for MCP secrets
if [[ ! -f "$HOME/.claude/.env" ]]; then
    cat > "$HOME/.claude/.env" << 'EOF'
# Claude Code Environment Variables
# These are used by MCP servers configured via `claude mcp add`
#
# Tavily API (for web search)
# Get your key from: https://app.tavily.com/home
# TAVILY_API_KEY=your-api-key

# Service MCP (for Black Duck data products)
# MCP_STATIC_ACCESS_TOKEN=your-token

EOF
fi

# Create a helpful README for Claude configuration
cat > "$HOME/.claude/README.md" << 'EOF'
# Claude Code Configuration

This directory contains your Claude Code configuration and data.

## Configuration Files

| File | Purpose |
|------|---------|
| `settings.json` | Permissions, env vars, hooks (user scope) |
| `settings.local.json` | Local permission overrides (not in git) |
| `~/.claude.json` | MCP servers, OAuth, preferences |
| `.env` | Environment variable template |
| `CLAUDE.md` | Custom instructions and context |

## MCP Servers

MCP servers are configured via `claude mcp add` command and stored in `~/.claude.json`.

View configured servers:
```bash
claude mcp list
```

Add a new server:
```bash
claude mcp add <name> --scope user -- <command>
```

## Directories

- `memory/` - Persistent storage for memory MCP server
- `shared/` - Shared configuration files
- `agents/` - Custom subagent definitions

## Bootstrap

Configuration is managed by YADM bootstrap scripts:
- `~/.config/yadm/bootstrap.d/claude.sh` - Creates settings files
- `~/.config/yadm/bootstrap.d/claude-env.sh` - Configures MCP servers

Re-run bootstrap to reset configuration:
```bash
yadm bootstrap
```

## Documentation

- Settings reference: https://code.claude.com/docs/en/settings
- MCP servers: https://code.claude.com/docs/en/mcp
EOF

echo "✅ Claude Code configuration complete!"
echo "📁 Configuration files in ~/.claude/"
echo "🔧 MCP servers configured via claude-env.sh bootstrap"
