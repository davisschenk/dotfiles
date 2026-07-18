# dotfiles

Personal shell/prompt config, applied via [chezmoi](https://www.chezmoi.io).

Consumed automatically by [Coder](https://coder.com)'s
[dotfiles integration](https://coder.com/docs/user-guides/workspace-dotfiles): on workspace
start, Coder clones this repo and runs `install.sh`, which points chezmoi's source straight at
the clone (`chezmoi --source="$PWD" init --apply`) — no separate clone step.

## Contents

- `dot_zshrc.tmpl` → `~/.zshrc` — history options, aliases, prompt/tool init hooks (starship,
  zoxide, atuin, fzf). The `zsh-autosuggestions`/`zsh-syntax-highlighting` plugin sources are
  conditional on `$ZSH_AUTOSUGGESTIONS_SH`/`$ZSH_SYNTAX_HIGHLIGHTING_SH` — set by the
  [Coder workspace image](https://github.com/davisschenk/nixos-homelab/blob/master/modules/nixos/coder/workspace-image.nix)
  when those plugins come from Nix; unset (and skipped) elsewhere.
- `dot_config/starship.toml` → `~/.config/starship.toml` — starship's official
  ["Pure" preset](https://starship.rs/presets/pure-preset), verbatim.

Deliberately does **not** manage `~/.gitconfig` — in the Coder workspace, git identity is set
dynamically per workspace owner by the template itself.

## Manual use

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply davisschenk/dotfiles
```
