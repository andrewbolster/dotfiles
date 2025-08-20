# Andrew Bolster's Dotfiles

A comprehensive development environment configuration managed by [yadm](https://yadm.io/) with modern tools, AI integration, and cross-platform compatibility.

[![YADM](https://img.shields.io/badge/Managed%20by-YADM-blue)](https://yadm.io/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey)](https://github.com/andrewbolster/dotfiles)

## 🚀 Quick Start

```bash
# Install yadm
curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x /usr/local/bin/yadm

# Clone this repository
yadm clone https://github.com/andrewbolster/dotfiles.git

# Run bootstrap to configure everything
yadm bootstrap
```

## 🎯 Non-Standard Features & Customizations

### 🤖 **AI-First Development**
- **Claude Code Integration**: Automated MCP server setup with bootstrap scripts
- **Enhanced Permissions**: Curated allowlist/denylist for safe AI assistance
- **Persistent Memory**: MCP memory server for context retention across sessions
- **Project-Aware**: Filesystem MCP server with proper security boundaries

### 🖱️ **Advanced Mouse Integration**
- **tmux/byobu**: Full mouse support with modern tmux 3.x syntax
- **Click Navigation**: Pane focus, window switching, border resizing
- **Smart Scrolling**: Context-aware scroll behavior (history vs application)
- **Selection Features**: Double-click word selection, triple-click line selection
- **Clipboard Integration**: Right-click paste, seamless copy/paste workflow

### 🌍 **Cross-Platform Intelligence**
- **Adaptive Paths**: Automatic macOS/Linux path detection and configuration
- **Package Manager Detection**: Mamba vs Conda, Homebrew vs APT awareness
- **Platform-Specific Aliases**: Conditional command aliases based on OS
- **Shell Compatibility**: Unified experience across bash and zsh

### ⌨️ **Modern Vim/Neovim Configuration**
- **Dual Setup**: Legacy vim with modern neovim (LazyVim)
- **XDG Compliance**: Modern config locations (`~/.config/vim/`, `~/.config/nvim/`)
- **Mouse Excellence**: Full mouse support with relative line numbers
- **AI Integration**: Claude Code plugin for in-editor AI assistance
- **Performance Optimized**: SSH-friendly settings with local enhancements

### 🔧 **Intelligent Bootstrapping**
- **Modular Bootstrap**: Individual scripts for different tools and services
- **Idempotent Operations**: Safe to re-run, preserves existing configurations
- **Backup Strategy**: Automatic backups before configuration changes
- **Environment Detection**: Adapts to system capabilities and installed tools

## 📁 Directory Structure

```
~/
├── .config/
│   ├── nvim/                    # Modern Neovim (LazyVim)
│   ├── tmux/                    # Native tmux configuration
│   ├── vim/                     # Modern vim configuration
│   ├── zsh/                     # ZSH aliases and functions
│   └── yadm/
│       └── bootstrap.d/         # Modular bootstrap scripts
├── .claude/                     # Claude Code AI configuration
│   ├── CLAUDE.md               # Environment documentation
│   ├── settings.json           # Global Claude settings
│   └── settings.local.json     # Local overrides
├── src/configs/dotfiles/        # Legacy configuration symlinks
└── README.md                    # This file
```

## 🛠️ Tools & Technologies

### **Shell Environment**
- **zsh** with Oh My Zsh and Starship prompt
- **byobu** as primary terminal multiplexer
- **Modern aliases** with XDG-compliant organization

### **Development Tools**
- **Neovim** (LazyVim) + legacy vim support
- **Python** (Miniconda/Mamba ecosystem)
- **Node.js** (Bun package manager)
- **Ruby** (RVM/rbenv)
- **Rust** (Cargo)

### **AI Integration**
- **Claude Code** with comprehensive MCP server setup
- **Memory persistence** across sessions
- **Filesystem integration** with security boundaries
- **Service management** integration

### **Terminal Multiplexing**
- **byobu** (primary) with tmux backend
- **Native tmux** with plugin ecosystem (TPM)
- **Comprehensive mouse support** with modern bindings

## ⚡ Key Customizations

### **Shell Aliases** (`~/.config/zsh/aliases.zsh`)
```bash
# Claude Code workflow
alias claude-config='nvim ~/.claude/settings.json'
alias claude-mcp='~/.claude/start-mcp.sh'
alias claude-memory='ls -la ~/.claude/memory/'

# Development shortcuts
alias nv='nvim'                 # Neovim shortcut
alias ys='yadm status'          # yadm shortcuts
alias gs='git status'           # git shortcuts

# Platform-aware
alias o='open'                  # macOS: open, Linux: xdg-open
```

### **Mouse Features**
- **Pane Focus**: Click any pane to focus
- **Window Switching**: Click window tabs
- **Resize**: Drag pane borders
- **Selection**: Double-click words, triple-click lines
- **Clipboard**: Right-click to paste
- **Scrolling**: Intelligent wheel scrolling

### **AI Permissions**
```json
{
  "allow": [
    "Bash(git status:*)",
    "Bash(docker ps:*)",
    "Bash(systemctl list-units:*)",
    "Bash(nvim:*)"
  ],
  "deny": [
    "Bash(rm -rf:*)",
    "Bash(sudo rm:*)",
    "Bash(format:*)"
  ]
}
```

## 🔒 Security Features

- **Curated Command Permissions**: AI can only run approved safe commands
- **Backup Strategy**: All changes create backups before modification
- **Environment Isolation**: MCP servers run in controlled environments
- **Credential Management**: Separate local environment files (not tracked)

## 🎨 Customization

### **Adding New Aliases**
Edit `~/.config/zsh/aliases.zsh` and restart shell or `source ~/.zshrc`

### **Modifying AI Permissions**
Edit `~/.claude/settings.local.json` for local overrides

### **Adding Bootstrap Scripts**
Create executable scripts in `~/.config/yadm/bootstrap.d/`

### **tmux/byobu Customization**
- byobu: `~/.byobu/` (symlinked to `~/src/configs/dotfiles/.byobu/`)
- tmux: `~/.config/tmux/tmux.conf`

## 🔄 Maintenance

```bash
# Update configurations
yadm pull

# Re-run bootstrap (safe to repeat)
yadm bootstrap

# Check status
yadm status

# Commit local changes
yadm add -u && yadm commit -m "Update configuration"
```

## 📚 Documentation

- **Comprehensive Environment Docs**: `~/.claude/CLAUDE.md`
- **MCP Setup Guide**: `~/.claude/README.md`
- **Bootstrap Scripts**: Self-documenting in `~/.config/yadm/bootstrap.d/`

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork for your own use
- Submit issues for bugs
- Suggest improvements via pull requests

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

*Managed with [yadm](https://yadm.io/) • Enhanced with [Claude Code](https://claude.ai/code)*