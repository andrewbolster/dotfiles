#!/bin/bash

# Byobu Bootstrap Script
# Sets up byobu configuration and ensures proper installation

echo "🖥️  Setting up Byobu configuration..."

# Check if byobu is installed
if ! command -v byobu >/dev/null 2>&1; then
    echo "⚠️  Byobu not found. Installing via Homebrew..."
    if command -v brew >/dev/null 2>&1; then
        brew install byobu
    else
        echo "❌ Homebrew not found. Please install byobu manually:"
        echo "   macOS: brew install byobu"
        echo "   Ubuntu: apt install byobu"
        exit 1
    fi
fi

# Ensure byobu configuration directory exists
mkdir -p ~/.config/byobu/bin

# Set up byobu to use tmux backend
echo "BYOBU_BACKEND=tmux" > ~/.config/byobu/backend

# Create custom status scripts directory
mkdir -p ~/.config/byobu/bin

# Create a simple git branch status indicator
cat > ~/.config/byobu/bin/10_git_branch << 'EOF'
#!/bin/bash
# Display current git branch in byobu status line
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            printf "#[fg=yellow]⎇ %s*#[default]" "$branch"
        else
            printf "#[fg=green]⎇ %s#[default]" "$branch"
        fi
    fi
fi
EOF

# Create a conda environment indicator
cat > ~/.config/byobu/bin/15_conda_env << 'EOF'
#!/bin/bash
# Display active conda environment
if [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
    printf "#[fg=blue]🐍 %s#[default]" "$CONDA_DEFAULT_ENV"
fi
EOF

# Make status scripts executable
chmod +x ~/.config/byobu/bin/*

# Enable the git and conda status indicators in statusrc
if [ -f ~/.config/byobu/statusrc ]; then
    # Add custom indicators to statusrc if not already present
    if ! grep -q "git_branch" ~/.config/byobu/statusrc; then
        echo "" >> ~/.config/byobu/statusrc
        echo "# Custom status indicators" >> ~/.config/byobu/statusrc
        echo "tmux_right=\"\$tmux_right git_branch conda_env\"" >> ~/.config/byobu/statusrc
    fi
fi

# Set up byobu aliases if not already present in zsh config
if [ -f ~/.config/zsh/aliases.zsh ]; then
    if ! grep -q "alias byo=" ~/.config/zsh/aliases.zsh; then
        echo "" >> ~/.config/zsh/aliases.zsh
        echo "# Byobu aliases" >> ~/.config/zsh/aliases.zsh
        echo "alias byo='byobu'"                  >> ~/.config/zsh/aliases.zsh
        echo "alias byos='byobu new-session'"    >> ~/.config/zsh/aliases.zsh
        echo "alias byol='byobu list-sessions'"  >> ~/.config/zsh/aliases.zsh
        echo "alias byoa='byobu attach'"         >> ~/.config/zsh/aliases.zsh
    fi
fi

echo "✅ Byobu configuration complete!"
echo "💡 Usage:"
echo "   byo         - Start byobu"
echo "   byos        - Create new session"
echo "   byol        - List sessions"
echo "   byoa        - Attach to session"
echo ""
echo "🎯 Key bindings:"
echo "   Ctrl-A      - Escape sequence (matches your tmux config)"
echo "   F2          - New window"
echo "   F3/F4       - Navigate windows"
echo "   Shift-F2    - Horizontal split"
echo "   Ctrl-F2     - Vertical split"
echo "   F6          - Detach session"
echo "   F7          - Scrollback mode"
echo "   F9          - Configuration menu"