----------------------------------------------
-- icons
----------------------------------------------
require("circles").setup()

----------------------------------------------
-- colorscheme
----------------------------------------------
vim.cmd('colorscheme github_dark_high_contrast')

----------------------------------------------
-- zen mode
----------------------------------------------
vim.keymap.set('n', '<leader>z', ':ZenMode<CR>')

----------------------------------------------
-- status bar
----------------------------------------------
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
