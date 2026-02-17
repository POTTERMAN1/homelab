#!/bin/bash

REPO_DIR="/home/potterman/git/homelab"
cd "$REPO_DIR" || exit

BRANCH=$(git rev-parse --abbrev-ref HEAD)

git fetch origin "$BRANCH"

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Updating repository on branch '$BRANCH': $LOCAL -> $REMOTE"
    git pull origin "$BRANCH"
else
    echo "No changes detected on branch '$BRANCH'. Stayed at $LOCAL"
fi