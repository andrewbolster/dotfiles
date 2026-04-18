#!/bin/bash
#
# Fix git remotes to use SSH instead of HTTPS for authenticated operations
#

echo "Fixing git remotes to use SSH authentication..."

# Fix yadm remote
current_remote=$(yadm remote get-url origin 2>/dev/null)
if [[ "$current_remote" == https://github.com/* ]]; then
    # Convert https://github.com/user/repo.git to git@github.com:user/repo.git
    ssh_remote=$(echo "$current_remote" | sed 's|https://github.com/|git@github.com:|')
    echo "Switching yadm remote from HTTPS to SSH..."
    echo "  Old: $current_remote"
    echo "  New: $ssh_remote"
    yadm remote set-url origin "$ssh_remote"
    echo "yadm remote updated successfully"
else
    echo "yadm remote already using SSH or not a GitHub HTTPS URL"
fi

# Fix any other common git repositories that might be using HTTPS
if [[ -d ~/src ]]; then
    echo "Checking repositories in ~/src for HTTPS remotes..."
    find ~/src -name ".git" -type d 2>/dev/null | while read -r git_dir; do
        repo_dir=$(dirname "$git_dir")
        repo_name=$(basename "$repo_dir")

        # Check if this repo has an HTTPS GitHub remote
        cd "$repo_dir" 2>/dev/null || continue
        current_remote=$(git remote get-url origin 2>/dev/null)

        if [[ "$current_remote" == https://github.com/* ]]; then
            ssh_remote=$(echo "$current_remote" | sed 's|https://github.com/|git@github.com:|')
            echo "  Fixing $repo_name: $current_remote -> $ssh_remote"
            git remote set-url origin "$ssh_remote" 2>/dev/null || echo "    Warning: Failed to update $repo_name"
        fi
    done
    echo "Repository remote check completed"
fi

echo "Git remote fixes completed"