#!/usr/bin/env bash
set -euo pipefail

# Entrypoint Coder's dotfiles module discovers and runs (`coder dotfiles`
# searches for this filename first, and executes it with $PWD set to this
# repo's own clone directory) — so pointing chezmoi's source straight at
# $PWD applies this repo without a second clone.
# --force: runs unattended, so a conflict prompt (e.g. a pre-existing
# .zshrc) would crash on the missing TTY instead of asking.
chezmoi --source="$PWD" init --apply --force
