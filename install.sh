#!/usr/bin/env bash
# install - set up toolcit for the current user
#
# Adds `source .../bin/addpath` to all found shell rc files and registers
# the bin/ directory at the front of the persistent PATH store.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$REPO_DIR/bin"
ADDPATH="$BIN_DIR/addpath"
SOURCE_LINE="source \"$ADDPATH\""

RC_FILES=(
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.profile"
    "$HOME/.kshrc"
)

added_to=()
skipped=()

for rc in "${RC_FILES[@]}"; do
    [ -f "$rc" ] || continue
    # Match any reasonable quoting style for the path
    if grep -qF "$ADDPATH" "$rc" 2>/dev/null; then
        skipped+=("$rc")
        continue
    fi
    printf '\n# toolcit\n%s\n' "$SOURCE_LINE" >> "$rc"
    added_to+=("$rc")
done

# Register bin/ at the front of the persistent PATH store
"$ADDPATH" --prepend "$BIN_DIR"

# Configure git init template (provides .gitignore for new and cloned repos)
if ! git config --global init.templateDir &>/dev/null; then
    read -r -p "Set git init template to add a default .gitignore to new/cloned repos? [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        git config --global init.templateDir "$REPO_DIR/etc/git-template"
        echo "install: set git init template to $REPO_DIR/etc/git-template"
    fi
else
    echo "install: skipped init.templateDir (already set to $(git config --global init.templateDir))"
fi

if [ ${#added_to[@]} -gt 0 ]; then
    echo "install: added source line to:"
    printf '  %s\n' "${added_to[@]}"
fi
if [ ${#skipped[@]} -gt 0 ]; then
    echo "install: already configured in:"
    printf '  %s\n' "${skipped[@]}"
fi

echo ""
echo "install: done. Open a new shell or run:"
echo "  source $ADDPATH"
