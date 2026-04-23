#!/usr/bin/env bash
# install - set up toolcit for the current user
#
# Adds `source .../bin/addpath` to all found shell rc files and registers
# the bin/ directory at the front of the persistent PATH store.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$REPO_DIR/bin"
SHELL_INIT="$REPO_DIR/shell-init"

"$BIN_DIR/perm" -f "$SHELL_INIT"

# Register bin/ at the front of the persistent PATH store
"$BIN_DIR/addpath" --prepend "$BIN_DIR" 2>/dev/null

# Offer git-clone wrapper (copies init.templateDir .gitignore into cloned repos)
echo ""
echo "toolcit includes 'git clone' and 'git init' wrappers that copy your init.templateDir"
echo ".gitignore into repos that don't already have one. The git init wrapper is always enabled."
echo "Requires init.templateDir to be configured, e.g.:"
echo "  git config --global init.templateDir ~/.config/git/template"
echo "  mkdir -p ~/.config/git/template && cp /path/to/.gitignore ~/.config/git/template/"
read -r -p "Enable the git clone wrapper? (git init is already enabled) [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    git config --global toolcit.wrapClone true
    echo "install: enabled git clone wrapper. To disable later:"
    echo "  git config --global toolcit.wrapClone false"
else
    echo "install: skipped. To enable later:"
    echo "  git config --global toolcit.wrapClone true"
fi

echo ""
echo "install: done. Open a new shell or run:"
echo "  source $SHELL_INIT"
