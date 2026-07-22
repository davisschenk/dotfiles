#!/usr/bin/env bash
set -euo pipefail

# Entrypoint Coder's dotfiles module discovers and runs (`coder dotfiles`
# searches for this filename first, and executes it with $PWD set to this
# repo's own clone directory) — so pointing chezmoi's source straight at
# $PWD applies this repo without a second clone.

# Coder's dotfiles module runs this standalone with no guarantee chezmoi is
# already on the target machine — bootstrap it if missing instead of
# assuming it's there.
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# --force: runs unattended, so a conflict prompt (e.g. a pre-existing
# .zshrc) would crash on the missing TTY instead of asking.
chezmoi --source="$PWD" init --apply --force
