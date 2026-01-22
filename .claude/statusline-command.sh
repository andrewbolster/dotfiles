#!/bin/bash
# Starship-inspired statusline for Claude Code
# Uses JSON input from Claude Code via stdin

# Read JSON input from Claude Code
input=$(cat)

# Colors (dimmed for status line display)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

# Get basic info
USER=$(whoami)
HOST=$(hostname -s)

# Get directory from JSON input
DIR=$(echo "$input" | jq -r '.workspace.current_dir // .cwd' | sed "s|$HOME|~|")

# Git info (with git config --global core.filesRefLockTimeout 0 for speed)
GIT_BRANCH=""
GIT_DIRTY=""
if git -c core.filesRefLockTimeout=0 rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git -c core.filesRefLockTimeout=0 branch --show-current 2>/dev/null || git -c core.filesRefLockTimeout=0 rev-parse --short HEAD 2>/dev/null)
    if [[ -n $GIT_BRANCH ]]; then
        # Check for uncommitted changes (skip locks)
        if ! git -c core.filesRefLockTimeout=0 diff --quiet 2>/dev/null || ! git -c core.filesRefLockTimeout=0 diff --cached --quiet 2>/dev/null; then
            GIT_DIRTY="*"
        fi
    fi
fi

# Get model display name from JSON
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Get proxy URL from environment
PROXY_URL=${ANTHROPIC_BASE_URL:-"direct"}
# Extract hostname from URL using parameter expansion
temp=${PROXY_URL#*://}
PROXY_HOST=${temp%%/*}

# Get output style from JSON
OUTPUT_STYLE=$(echo "$input" | jq -r '.output_style.name // empty')

# Build statusline similar to Starship default
printf "${GREEN}${BOLD}${USER}@${HOST}${RESET}"
printf " ${BLUE}${BOLD}${DIR}${RESET}"

if [[ -n $GIT_BRANCH ]]; then
    printf " ${PURPLE}on ${GIT_BRANCH}${GIT_DIRTY}${RESET}"
fi

printf " ${CYAN}via ${MODEL}${RESET}"

if [[ "$PROXY_HOST" != "direct" ]]; then
    printf " ${PURPLE}[${PROXY_HOST}]${RESET}"
fi

if [[ -n $OUTPUT_STYLE ]]; then
    printf " ${YELLOW}[${OUTPUT_STYLE}]${RESET}"
fi