# Andrew Bolster's Claude Code Configuration

This document serves as the main configuration file for Claude Code interactions. For specific agent instructions and detailed context, see the organized agent structure in the `/agents/` directory.

## Agent Architecture

This configuration uses a hierarchical agent structure:

### Content Agents (`/agents/content/`)
- **data-science-reports.md**: Weeknotes and blog post creation
- Specialized for maintaining authentic voice and data accuracy

### Analysis Agents (`/agents/analysis/`)
- **data-analytics.md**: Black Duck data product analysis
- Security insights and data-driven decision support

### Operations Agents (`/agents/operations/`)
- **project-management.md**: JIRA/Confluence management
- Team coordination and project tracking

### Shared Resources (`/shared/`)
- **professional-context.md**: Role, team, and organizational context
- **development-environment.md**: Technical environment details
- **quality-standards.md**: Data verification and content standards

## Development Environment Summary

For detailed development environment configuration, see `/shared/development-environment.md`.

Key components include:
- **YADM**: Primary dotfiles management with bootstrap scripts
- **ZSH**: Modern Oh My Zsh setup with Starship prompt
- **Neovim**: LazyVim configuration with Claude Code integration
- **Tmux/Byobu**: Terminal multiplexing with Ctrl-A prefix
- **Python**: Miniconda3 with multiple environments
- **Node.js**: Bun package manager integration
- **Claude Code**: Enhanced MCP server integration

## MCP Server Integration

Available MCP servers and capabilities:
- **Service-MCP**: Black Duck security data products and analytics
- **Atlassian**: Confluence/Jira integration (bolster@blackduck.com)
- **Memory**: Persistent knowledge graph storage
- **Filesystem**: Local file system operations
- **DigitalOcean**: Cloud infrastructure management

## Agent Selection Protocol

**IMPORTANT**: When starting any conversation, first determine the task type and automatically load the appropriate agent configuration by reading the relevant files.

### Content Creation Tasks
**Trigger phrases**: "weeknotes", "blog post", "team update", "monthly report", "content creation"

**Required actions**:
1. Read `/Users/bolster/.claude/agents/content/data-science-reports.md`
2. Read `/Users/bolster/.claude/shared/professional-context.md`
3. Read `/Users/bolster/.claude/shared/quality-standards.md`
4. Follow the Data Science Content Assistant instructions for authentic voice and data accuracy

### Data Analysis Tasks
**Trigger phrases**: "data analysis", "query", "analytics", "data products", "security insights", "customer analysis"

**Required actions**:
1. Read `/Users/bolster/.claude/agents/analysis/data-analytics.md`
2. Read `/Users/bolster/.claude/shared/professional-context.md`
3. Use Service-MCP data products for Black Duck security data
4. Follow data verification hierarchy and quality standards

### Project Management Tasks
**Trigger phrases**: "JIRA", "project management", "confluence", "documentation", "issue tracking", "team coordination"

**Required actions**:
1. Read `/Users/bolster/.claude/agents/operations/project-management.md`
2. Read `/Users/bolster/.claude/shared/professional-context.md`
3. Use Atlassian MCP for JIRA/Confluence operations
4. Follow project management standards and workflows

### Development Environment Tasks
**Trigger phrases**: "development", "configuration", "dotfiles", "environment setup", "technical setup"

**Required actions**:
1. Read `/Users/bolster/.claude/shared/development-environment.md`
2. Reference technical configuration details as needed
3. Use appropriate development tools and standards

### Multi-Domain Tasks
For tasks spanning multiple domains, load all relevant agent configurations and coordinate between them while maintaining consistency with shared standards.

### Legacy Configuration Details

The following sections contain the original comprehensive development environment configuration for reference:

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
  
- **Legacy Config**: `~/src/configs/dotfiles/.zshrc` (older configuration)
  - Theme: `af-magic`
  - More comprehensive plugin set: git, colorize, colored-man-pages, git-extras, pip, python, vagrant, ssh-agent, virtualenv, mercurial, sublime
  - Custom prompt with timestamp
  - Multiple conda environment setups

### Bash (Fallback)
- **Config**: `~/src/configs/dotfiles/.bashrc` (symlinked from `~/.bashrc`)
- Standard Debian/Ubuntu bash configuration with:
  - Color prompt support
  - History settings (1000 lines, no duplicates)
  - Color ls/grep aliases
  - Conda initialization
  - RVM and Cargo environment setup

### Shell Aliases
- **Location**: `~/src/configs/dotfiles/.bash_aliases` (symlinked from `~/.bash_aliases`)
- Sourced by both bash and zsh configurations

## Terminal Multiplexer Configuration

### Byobu (Primary)
- **Config Directory**: `~/src/configs/dotfiles/.byobu/` (symlinked from `~/.byobu`)
- **Backend**: tmux (configured in `backend` file)
- **Key Features**:
  - Custom status line with network, system info, and time
  - Ctrl-A prefix key configuration
  - **Enhanced mouse support**: Click panes/windows, drag resize, wheel scroll
  - **Modern tmux syntax**: Updated from deprecated mouse options
  - Custom color schemes and keybindings
  - SSH agent integration (currently has broken symlink issue)

### Native tmux
- **Config**: `~/.config/tmux/tmux.conf`
- **Plugin Manager**: TPM (Tmux Plugin Manager)
- **Plugins**:
  - `tmux-sensible` (sensible defaults)
  - `vim-tmux-navigator` (seamless vim/tmux navigation)
  - `tmux-yank` (clipboard integration)
  - `tmux-autoreload` (auto-reload configuration)
- **Key Features**:
  - Ctrl-A prefix (consistent with byobu)
  - **Comprehensive mouse support**: Click, drag, scroll, double/triple-click selection
  - **Advanced clipboard integration**: Right-click paste, word/line selection
  - 1-based indexing for windows and panes
  - True color support
  - **Smart scrolling**: History vs application scrolling

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

### Vim (Legacy)
- **Config**: `~/src/configs/dotfiles/.vimrc` (symlinked)
- **Runtime**: Uses `~/.vim_runtime/` directory structure
- Sources configuration from:
  - `~/.vim_runtime/vimrcs/basic.vim`
  - `~/.vim_runtime/vimrcs/filetypes.vim`
  - `~/.vim_runtime/vimrcs/plugins_config.vim`
  - `~/.vim_runtime/vimrcs/extended.vim`
  - `~/.vim_runtime/my_configs.vim` (custom configurations)

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

### VPN Configuration
- **Directory**: `~/src/configs/vpns/`
- Multiple VPN configurations including Farset Labs

### Package Management
- **System**: APT package lists in `~/src/configs/pkgs.apt*`
- **Python**: pip requirements in `~/src/configs/piprequirements.txt`
- **Conda**: Environment specifications in `~/src/configs/*.conda`

## Notable Configuration Features

### Environment Path Management
- Consistent PATH setup across shells
- Priority order: local bins, cargo, conda, system paths
- Special handling for macOS vs Linux differences

### Theme and Appearance
- ZSH: Starship prompt with custom configuration
- Terminal: True color support enabled
- Consistent color schemes across tools

### Integration Points
- Byobu and tmux both use Ctrl-A prefix
- Vim/Neovim navigation integrated with tmux
- Consistent clipboard handling across tools

## Configuration Issues and Notes

### Known Issues
1. **Byobu SSH Agent**: Broken symlink to `/tmp/ssh-3dA40FjEnrXt/agent.3702`
2. **Dual Configuration**: Some tools have both legacy and modern configs
3. **Platform Differences**: Some zsh configs contain macOS-specific paths

### Maintenance Recommendations
1. Consolidate legacy dotfiles into yadm management
2. Fix broken SSH agent integration in byobu
3. Remove unused conda initialization duplicates
4. Standardize package manager preferences (choose between conda/mamba)

## Directory Structure Summary

```
/home/bolster/
├── .config/
│   ├── nvim/           # Modern Neovim configuration
│   ├── tmux/           # Native tmux configuration
│   └── yadm/           # YADM bootstrap scripts
├── .local/share/yadm/  # YADM repository
├── src/configs/
│   ├── dotfiles/       # Legacy dotfiles (symlinked)
│   ├── vpns/          # VPN configurations
│   └── system-connections/ # Network manager profiles
├── miniconda3/         # Python environment
├── .oh-my-zsh/        # ZSH framework
└── .vim_runtime/       # Vim configuration framework
```

This environment represents a mature, well-integrated development setup with both modern tools (Neovim, Starship, yadm) and battle-tested legacy configurations, optimized for Python/data science work, systems administration, and general software development.