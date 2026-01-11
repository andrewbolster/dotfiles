#zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Load custom aliases
# Modern XDG-compliant location
if [[ -f "$HOME/.config/zsh/aliases.zsh" ]]; then
    source "$HOME/.config/zsh/aliases.zsh"
fi

# Load legacy bash aliases for compatibility
if [[ -f "$HOME/.bash_aliases" ]]; then
    source "$HOME/.bash_aliases"
fi

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Add homebrew completions if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    fpath+=/opt/homebrew/share/zsh/site-functions
fi

# Smarter completion initialization
autoload -Uz compinit
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version with BSD stat
    if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
        compinit
    else
        compinit -C
    fi
else
    # Linux version with GNU stat
    if [ "$(date +'%j')" != "$(stat -c '%Y' ~/.zcompdump 2>/dev/null | date -d @- +'%j' 2>/dev/null)" ]; then
        compinit
    else
        compinit -C
    fi
fi

SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡"

# Only load what you actually use
SPACESHIP_PROMPT_ORDER=(
    time
    user
    dir
    git
    line_sep
    char
)

eval "$(starship init zsh)"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
# Platform-agnostic mamba setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS paths
    export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
    export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
else
    # Linux paths
    export MAMBA_EXE="$HOME/miniconda3/bin/mamba"
    export MAMBA_ROOT_PREFIX="$HOME/miniconda3"
fi

if [ -f "$MAMBA_EXE" ]; then
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    fi
    unset __mamba_setup
fi
# <<< mamba initialize <<<


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bob
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
#
#zprof


# Claude Code CLI integration
export PATH="$HOME/.claude/local:$HOME/.local/bin:$PATH"
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

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/bolster/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Claude Code MCP Environment Variables
# Get your Tavily API key from: https://app.tavily.com/home
export TAVILY_API_KEY="${TAVILY_API_KEY}"

# Note: Other MCP environment variables like VANTAGE are configured via OAuth in the MCP servers
