return {
    -- status bar
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lazy_status = require("lazy.status")

        require('lualine').setup({
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
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
            }
        })
    end
}
