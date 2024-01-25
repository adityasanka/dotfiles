----------------------------------------------
-- file tree explorer
----------------------------------------------
local circles = require('circles')

circles.setup({ icons = { empty = '', filled = '', lsp_prefix = '' } })

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
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

vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<CR>')

----------------------------------------------
-- fuzzy finder
----------------------------------------------
local telescope = require("telescope")

-- install ripgrep using `brew install ripgrep`
-- telescope will automatically pick it up
-- extremely fast search
-- ignores everything in .gitignore
telescope.setup {
    { file_ignore_patterns = { "node%_modules/.*" } }
}

local builtin = require('telescope.builtin')

local project_root = function()
    local root_names = { '.git', 'go.mod', 'Makefile' }

    -- get path to current buffer
    local fname = vim.api.nvim_buf_get_name(0)
    if fname == '' then return end

    -- get current working directory
    local cwd = vim.fs.dirname(fname)

    -- searching upward for root directory
    local root_file = vim.fs.find(root_names, { path = cwd, upward = true })[1]
    -- if root_names not found, return cwd
    if root_file == nil then
        return cwd
    end

    return vim.fs.dirname(root_file)
end

local find_in_project = function()
    builtin.find_files({ cwd = project_root() })
end

vim.keymap.set('n', '<leader>ff', find_in_project, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
