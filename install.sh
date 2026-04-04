#!/usr/bin/env bash
# install - set up toolcit for the current user
#
# Adds `source .../bin/addpath` to all found shell rc files and registers
# the bin/ directory at the front of the persistent PATH store.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$REPO_DIR/bin"
SHELL_INIT="$REPO_DIR/shell-init"
SOURCE_LINE="source \"$SHELL_INIT\""

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
    if grep -qF "$SHELL_INIT" "$rc" 2>/dev/null; then
        skipped+=("$rc")
        continue
    fi
    printf '\n# toolcit\n%s\n' "$SOURCE_LINE" >> "$rc"
    added_to+=("$rc")
done

# Register bin/ at the front of the persistent PATH store
"$BIN_DIR/addpath" --prepend "$BIN_DIR" 2>/dev/null

# Offer git-clone wrapper (copies init.templateDir .gitignore into cloned repos)
echo ""
echo "toolcit includes a 'git clone' wrapper that copies your init.templateDir .gitignore"
echo "into cloned repos that don't already have one."
echo "Requires init.templateDir to be configured, e.g.:"
echo "  git config --global init.templateDir ~/.config/git/template"
echo "  mkdir -p ~/.config/git/template && cp /path/to/.gitignore ~/.config/git/template/"
read -r -p "Enable the git clone wrapper? [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    git config --global toolcit.wrapClone true
    echo "install: enabled git clone wrapper. To disable later:"
    echo "  git config --global toolcit.wrapClone false"
else
    echo "install: skipped. To enable later:"
    echo "  git config --global toolcit.wrapClone true"
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
echo "  source $SHELL_INIT"
