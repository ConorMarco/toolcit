# ToolCIT — Conor's Improvements for Terminal

A personal collection of CLI tools and shell enhancements.

## Installation

```sh
./install.sh
```

Adds `source /path/to/shell-init` to your shell rc files, registers `bin/` on your PATH, and optionally enables the `git clone` wrapper.

## Tools

### Shell

**`addpath [-p] <dir>`**  
Persistently add a directory to PATH. Stored in `~/.config/addpath/paths` and loaded on shell start. `-p` prepends instead of appending.

**`perm [-f] <line>`**  
Permanently add a line to your shell rc files. `-f` adds a `source` line for the given file path.

**`yesand <a> [b...]`**  
Like `yes(1)` but cycles through multiple arguments.

### History Search

**`hs [-n N] [-i] [-c|-C] <term...>`**  
Search shell history for lines matching all terms. Returns the N most recent matches (default 10). `-i` opens interactive mode. `-c` case sensitive, `-C` case insensitive (default).

**`hsi [-n N] [-c|-C]`**  
Interactive history search TUI. Type to filter, arrow keys to navigate, Enter to insert the selected command into your prompt.

### Git

**`git cam <message>`**  
Stage all changes and commit with the given message.

**`git del [<branch>]`**  
Delete a branch locally and on the remote. Defaults to the current branch, with a confirmation prompt.

**`git edit [<message>]`**  
Amend the last commit. With a message, replaces it; without, opens your editor.

**`git reword [<message>]`**  
Amend the last commit message only, without touching staged changes. Opens your editor if no message is given.

**`git sync [<remote>]`**  
Sync all branches with the remote: fetch, fast-forward local branches, push all local branches.

**`git pick [n]`**  
Cherry-pick the last n commits (default 1) onto main.

**`git clone`**  
Wrapper that copies a `.gitignore` from `init.templateDir` into cloned repos that don't already have one. Enable with `git config --global toolcit.wrapClone true`.
