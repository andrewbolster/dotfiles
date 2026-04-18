# Development Environment Context

This document contains Andrew Bolster's comprehensive development environment configuration.

## Important Process Management Lessons

### lsof and Port Management
**To kill only the server listening on a port:**
```bash
lsof -ti:3001 -sTCP:LISTEN | xargs kill
```

**Why not `lsof -ti:3001`?** That returns ALL processes connected to the port (servers AND clients like Firefox), so `kill -9` murders everything including your browser tabs.

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

#### Python Development Standards
- **Preferred**: UV scripts with frontmatter for standalone scripts
- **Fallback**: Click CLI commands via `uv run` when UV scripts aren't suitable
- **Rationale**: Modern dependency management with explicit environment isolation
- **Prohibited**: `sys.path.append()` hacks - use proper package management instead

**Exception Handling:**
- **Use `logging` module** instead of `print()` statements for errors
- **Catch specific exceptions** rather than bare `except:`
- **Include contextual information** in error messages
- **Use exception chaining** with `raise ... from e` when re-raising
- **For CLI tools**: Consider Click's `echo()` or Rich library for user-facing output

**UV Script Template:**
```python
# /// script
# dependencies = ["click", "requests"]
# ///

import logging
import click

logger = logging.getLogger(__name__)

@click.command()
def main():
    """Script description."""
    try:
        # Script logic here
        pass
    except SpecificError as e:
        logger.error(f"Operation failed: {e}")
        click.echo(f"Error: {e}", err=True)
        raise click.Abort()

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()
```

**Click CLI via uv run:**
```bash
uv run --with click script.py
```

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