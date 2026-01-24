# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Overview

This is a personal dotfiles monorepo using GNU Stow for symlink management. Each tool is a separate stow package that can be independently installed.

**Tools managed:** nvim, tmux, ghostty, git, starship, claude

## Stow Structure

Each package follows the pattern where files mirror their target location relative to `$HOME`:

```
tool/.config/tool/config  →  ~/.config/tool/config
git/.gitmessage           →  ~/.gitmessage
```

**Usage:**

- Install: `stow -t ~ <package>`
- Remove: `stow -D -t ~ <package>`
- Restow (update symlinks): `stow -R -t ~ <package>`

Always backup existing configs before stowing.

## Commit Convention

Commits follow the format: `[Tool-Name] Description`

Examples:

- `[Vim] Fix LSP config error for non-server tools`
- `[Ghostty] Add keybind and ignore backup files`
- `[Claude] Add git-commit skill for Claude Code`

## Tool Integration

These tools are configured to work together:

- **tmux + nvim**: vim-tmux-navigator enables seamless pane/split navigation
- **ghostty + tmux**: Keybinds coordinated (Alt+Left/Right passed to tmux)
- **Theme**: GitHub Dark palette shared across ghostty, tmux status bar, and nvim
