----------------------------------------------
-- colorscheme
----------------------------------------------
vim.cmd('colorscheme github_dark_high_contrast')

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
