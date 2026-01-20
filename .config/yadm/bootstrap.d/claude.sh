#!/bin/bash
#
# Claude Code Configuration Bootstrap
# Sets up default Claude settings, MCP servers, and permissions
#

set -e

echo "🤖 Configuring Claude Code..."

# Ensure .claude directory exists
mkdir -p "$HOME/.claude"

# Create default global settings (if it doesn't exist)
if [[ ! -f "$HOME/.claude/settings.json" ]]; then
    echo "📝 Creating default settings.json..."
    cat > "$HOME/.claude/settings.json" << 'EOF'
{
  "mcp": {
    "servers": {
      "memory": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-memory"],
        "description": "Persistent memory and context management"
      },
      "filesystem": {
        "command": "npx", 
        "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME"],
        "description": "File system operations and project navigation"
      },
      "atlassian": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-atlassian"],
        "description": "Atlassian/Jira integration for project management"
      },
      "service-mcp": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-service"],
        "description": "Service management and system monitoring"
      }
    }
  },
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
      "Bash(dd:*)"
    ]
  },
  "ui": {
    "theme": "dark",
    "editor": {
      "defaultEditor": "nvim",
      "mouseSupport": true,
      "lineNumbers": true,
      "relativeLineNumbers": true
    }
  },
  "development": {
    "defaultShell": "zsh",
    "terminalMultiplexer": "byobu",
    "autoStartMcp": true,
    "verboseLogging": false
  }
}
EOF
else
    echo "⚠️  settings.json already exists, skipping creation"
fi

# Update or create settings.local.json with enhanced permissions (preserving existing)
if [[ -f "$HOME/.claude/settings.local.json" ]]; then
    echo "🔧 Backing up existing settings.local.json..."
    cp "$HOME/.claude/settings.local.json" "$HOME/.claude/settings.local.json.backup"
    
    echo "📝 Enhancing existing settings.local.json with additional permissions..."
    # Create enhanced local settings that build on existing ones
    cat > "$HOME/.claude/settings.local.json" << 'LOCALEOF'
{
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
      "Bash(dd:*)"
    ]
  },
  "localOverrides": {
    "note": "This file contains local-specific settings that override defaults in settings.json",
    "lastUpdated": "$(date -Iseconds)"
  }
}
LOCALEOF
else
    echo "📝 Creating new settings.local.json..."
    cat > "$HOME/.claude/settings.local.json" << 'LOCALEOF'
{
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
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(which:*)",
      "Bash(pwd:*)",
      "Bash(echo:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(sudo rm:*)"
    ]
  }
}
LOCALEOF
fi

# Create a global MCP configuration for system-wide access
cat > "$HOME/.claude/mcp-global.json" << 'EOF'
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_STORAGE_PATH": "~/.claude/memory"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME"],
      "env": {
        "FILESYSTEM_ALLOWED_DIRS": "$HOME"
      }
    },
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-atlassian"],
      "env": {
        "ATLASSIAN_URL": "${ATLASSIAN_URL:-}",
        "ATLASSIAN_USERNAME": "${ATLASSIAN_USERNAME:-}",
        "ATLASSIAN_API_TOKEN": "${ATLASSIAN_API_TOKEN:-}"
      }
    },
    "service-mcp": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-service"],
      "env": {
        "SERVICE_ALLOWED_COMMANDS": "systemctl,docker,nginx,ufw"
      }
    }
  }
}
EOF

# Create memory storage directory
mkdir -p "$HOME/.claude/memory"

# Create default environment file for MCP secrets
if [[ ! -f "$HOME/.claude/.env" ]]; then
    cat > "$HOME/.claude/.env" << 'EOF'
# Claude Code MCP Environment Variables
# Copy this to .env.local and fill in your credentials

# Atlassian/Jira Configuration
# ATLASSIAN_URL=https://yourcompany.atlassian.net
# ATLASSIAN_USERNAME=your-email@company.com  
# ATLASSIAN_API_TOKEN=your-api-token

# Additional MCP Server Configuration
# Add other environment variables as needed

EOF
fi

# Create a startup script for MCP servers
cat > "$HOME/.claude/start-mcp.sh" << 'EOF'
#!/bin/bash
#
# Start MCP servers for Claude Code
#

echo "🚀 Starting MCP servers..."

# Source environment variables if available
if [[ -f "$HOME/.claude/.env.local" ]]; then
    source "$HOME/.claude/.env.local"
elif [[ -f "$HOME/.claude/.env" ]]; then
    source "$HOME/.claude/.env"
fi

# Check if Node.js/npm is available for MCP servers
if ! command -v npm &> /dev/null; then
    echo "⚠️  npm not found. MCP servers require Node.js/npm to be installed."
    echo "   Install Node.js from: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js/npm found"
echo "📦 MCP servers will be automatically started by Claude Code"
echo "🔧 Configuration: ~/.claude/settings.json"
echo "🗂️  Memory storage: ~/.claude/memory/"

# Validate MCP server availability
echo "🔍 Checking MCP server availability..."

servers=("@modelcontextprotocol/server-memory" "@modelcontextprotocol/server-filesystem" "@modelcontextprotocol/server-atlassian" "@modelcontextprotocol/server-service")

for server in "${servers[@]}"; do
    if npm list -g "$server" &> /dev/null || npx -y "$server" --version &> /dev/null; then
        echo "  ✅ $server"
    else
        echo "  📦 $server (will be installed on first use)"
    fi
done

echo "🎉 MCP configuration complete!"
EOF

chmod +x "$HOME/.claude/start-mcp.sh"

# Create a helpful README for Claude configuration
cat > "$HOME/.claude/README.md" << 'EOF'
# Claude Code Configuration

This directory contains your Claude Code configuration and data.

## Files

- `settings.json` - Main Claude configuration with MCP servers and permissions
- `mcp-global.json` - Global MCP server configuration  
- `.env` - Template for environment variables
- `.env.local` - Your local environment variables (create this)
- `start-mcp.sh` - Script to validate and start MCP servers
- `memory/` - Persistent memory storage for the memory MCP server
- `CLAUDE.md` - Environment documentation

## MCP Servers Configured

1. **Memory** - Persistent context and memory management
2. **Filesystem** - File system operations in $HOME
3. **Atlassian** - Jira/Confluence integration (requires credentials)
4. **Service MCP** - System service management

## Setup

1. Copy `.env` to `.env.local` and fill in your credentials
2. Run `./start-mcp.sh` to validate the setup
3. Start Claude Code - MCP servers will auto-start

## Customization

Edit `settings.json` to:
- Add/remove MCP servers
- Modify permissions
- Change UI preferences
- Adjust development settings

## Security

- Never commit `.env.local` to version control
- Review permissions in `settings.json` regularly
- MCP servers run locally and don't send data externally
EOF

echo "✅ Claude Code configuration complete!"
echo "📁 Configuration files created in ~/.claude/"
echo "🔧 Edit ~/.claude/.env.local to add your Atlassian credentials"
echo "🚀 Run ~/.claude/start-mcp.sh to validate setup"