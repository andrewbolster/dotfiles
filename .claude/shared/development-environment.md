# Development Environment Context

This document contains Andrew Bolster's comprehensive development environment configuration.

## Configuration Management Strategy

### Primary Management: YADM (Yet Another Dotfiles Manager)
- **Location**: `/usr/bin/yadm`
- **Repository**: `~/.local/share/yadm/repo.git`
- **Bootstrap Script**: `~/.config/yadm/bootstrap`
  - Initializes git submodules
  - Executes bootstrap scripts from `~/.config/yadm/bootstrap.d/`

### Legacy Configuration Storage
- **Primary Location**: `/home/bolster/src/configs/dotfiles/`
- Contains older dotfiles that are symlinked to home directory
- Many configurations still reference this location via symlinks

## Shell Configuration

### ZSH (Primary Shell)
- **Current Config**: `~/.zshrc` (modern Oh My Zsh setup)
  - Framework: Oh My Zsh with `robbyrussell` theme
  - Plugins: git only (minimal setup)
  - Prompt: Starship prompt system
  - Package managers: Mamba/Conda, Bun, Bob (Neovim version manager)
  - **Platform-agnostic paths**: Fixed macOS/Linux compatibility issues
  - **Modern alias management**: XDG-compliant alias location

- **Alias Configuration**: `~/.config/zsh/aliases.zsh`
  - Comprehensive development aliases (git, docker, system)
  - Claude Code integration aliases
  - yadm shortcuts
  - Platform-specific aliases (macOS/Linux)
  - Safety aliases with confirmation prompts

### Terminal Multiplexer Configuration

#### Byobu (Primary)
- **Config Directory**: `~/src/configs/dotfiles/.byobu/` (symlinked from `~/.byobu`)
- **Backend**: tmux (configured in `backend` file)
- **Key Features**:
  - Custom status line with network, system info, and time
  - Ctrl-A prefix key configuration
  - **Enhanced mouse support**: Click panes/windows, drag resize, wheel scroll
  - **Modern tmux syntax**: Updated from deprecated mouse options
  - Custom color schemes and keybindings

#### Native tmux
- **Config**: `~/.config/tmux/tmux.conf`
- **Plugin Manager**: TPM (Tmux Plugin Manager)
- **Key Features**:
  - Ctrl-A prefix (consistent with byobu)
  - **Comprehensive mouse support**: Click, drag, scroll, double/triple-click selection
  - **Advanced clipboard integration**: Right-click paste, word/line selection
  - 1-based indexing for windows and panes
  - True color support

## Editor Configuration

### Neovim (Primary)
- **Config Directory**: `~/.config/nvim/`
- **Framework**: LazyVim
- **Package Manager**: lazy.nvim
- **Key Features**:
  - Modern Lua-based configuration
  - LazyVim plugin ecosystem
  - Recently added: claudecode.nvim plugin for AI assistance
  - Tokyo Night colorscheme with Gruvbox fallback

## Development Environment

### Python
- **Primary**: Miniconda3 installation in `~/miniconda3/`
- **Alternative**: Mamba (faster conda alternative)
- **Platform-aware initialization**: Different paths for macOS/Linux
- Multiple conda environments configured

### Node.js
- **Manager**: Bun (modern JavaScript runtime and package manager)
- Installation: `~/.bun/`
- PATH integration in zsh

### Ruby
- **Manager**: RVM (Ruby Version Manager)
- **Alternative**: rbenv (configured in bashrc)
- PATH integration in both shells

### Rust
- **Installation**: Cargo in `~/.cargo/`
- Environment sourced in bashrc

### Claude Code AI Integration
- **Bootstrap Configuration**: `~/.config/yadm/bootstrap.d/claude.sh`
- **Environment Integration**: `~/.config/yadm/bootstrap.d/claude-env.sh`
- **MCP Servers**: Memory, Filesystem, Atlassian, Service-MCP
- **Enhanced Permissions**: Safe command allowlist with dangerous command denylist
- **Shell Integration**: Custom aliases and functions for Claude Code workflow

## System Integration

### Git Configuration
- **Config**: `~/src/configs/dotfiles/.gitconfig`
- Additional git runtime config: `~/src/configs/dotfiles/.gitrc`

### SSH Configuration
- **Directory**: `~/src/configs/dotfiles/.ssh/`
- Contains SSH keys and configuration

### Package Management
- **System**: APT package lists in `~/src/configs/pkgs.apt*`
- **Python**: pip requirements in `~/src/configs/piprequirements.txt`
- **Conda**: Environment specifications in `~/src/configs/*.conda`

## Known Issues
1. **Byobu SSH Agent**: Broken symlink to `/tmp/ssh-3dA40FjEnrXt/agent.3702`
2. **Dual Configuration**: Some tools have both legacy and modern configs
3. **Platform Differences**: Some zsh configs contain macOS-specific paths