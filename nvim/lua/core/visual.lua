-- colorscheme
vim.cmd('colorscheme github_dark_high_contrast')

-- file tree explorer
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<CR>')

-- fuzzy finder
local telescope = require("telescope")

telescope.setup {
    { file_ignore_patterns = { "node%_modules/.*" } }
}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<c-p>', builtin.find_files, {})
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})

-- status bar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'github_dark_default',
    },
    sections = {
        lualine_a = {
            {
                'filename',
                path = 1,
            }
        }
    }
}
