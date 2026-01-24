# CLAUDE.md

This file provides guidance to Claude Code when working with this Neovim configuration.

## Directory Structure

```
.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin version lock
└── lua/
    ├── core/
    │   ├── init.lua            # Loads options and keymaps
    │   ├── keymaps.lua         # Global keybindings (leader = Space)
    │   └── options.lua         # Editor settings (4-space indent, relative lines, system clipboard)
    └── plugins/
        ├── plenary.lua         # Shared dependency
        ├── ui/                 # Colorscheme, statusline, which-key, zen-mode
        ├── navigation/         # Telescope, oil.nvim, vim-tmux-navigator
        └── ide/                # LSP, completion, formatting, linting, treesitter, git
```

## Plugin Pattern

Each plugin returns a lazy.nvim spec:

```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  config = function()
    -- setup
  end,
}
```

Plugins auto-load from `plugins/`, `plugins/ui/`, `plugins/navigation/`, and `plugins/ide/`.

## Language Support

Primary: **Go** (gopls, golangci-lint, gofumpt/goimports). Also: Lua, TypeScript, Python, Bash, Markdown.

## Key Integrations

- **Telescope**: Project root detection via .git, go.mod, Makefile
- **auto-session**: Session restore (suppressed in ~/, ~/Developer, ~/Downloads, ~/Desktop)
- **Zen mode**: Coordinates with tmux to hide status bar

## Keymaps

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fG` | Find text in project |
| `<leader>.` | Go to definition |
| `<leader>ca` | Code actions |
| `<leader>mp` | Format file |
| `<leader>a` | Toggle symbol outline |
| `gc` | Comment toggle |
| `-` | Open file explorer |
| `ga` | Align text (visual) |
