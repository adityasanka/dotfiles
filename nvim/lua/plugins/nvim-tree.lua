return {
    -- file tree explorer
    'nvim-tree/nvim-tree.lua',
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "projekt0n/circles.nvim",
    },
    config = function()
        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local circles = require('circles')
        circles.setup({
            icons = {
                empty = '',
                filled = '',
                lsp_prefix = '' 
            } 
        })

        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                width = 40,
                relativenumber = true,
            },
            renderer = {
                group_empty = true,
                icons = {
                    glyphs = circles.get_nvimtree_glyphs(),
            },
            },
            filters = {
                dotfiles = true,
            },
        })

        -- set keymaps
        local keymap = vim.keymap
        keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) 
  end
}
