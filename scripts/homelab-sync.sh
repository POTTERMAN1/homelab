#!/bin/nash

REPO_DIR="/home/potterman/git/homelab"
BRANCH="main"

cd "$REPO_DIR" || exit

# Fetch metadata to see if changes exist
git fetch origin "$BRANCH"

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Updating repository: $LOCAL -> $REMOTE"
    git pull origin "$BRANCH"
else
    echo "No changes detected. Stayed at $LOCAL"
fi