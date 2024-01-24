----------------------------------------------
-- git integration for buffers
----------------------------------------------
require('gitsigns').setup()

----------------------------------------------
-- code comments
----------------------------------------------
require('Comment').setup()

----------------------------------------------
-- autoclose brackets
----------------------------------------------
require("autoclose").setup()

----------------------------------------------
-- improve code highlighting
----------------------------------------------
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "rust", "ruby", "vim", "html" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}

----------------------------------------------
-- lsp integration
----------------------------------------------

-- easily install and manage lsp servers
require('mason').setup()

-- closes gap between mason and lspconfig
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'gopls' },
})

-- quickstart configs for neovim lsp
local lspconfig = require('lspconfig')

-- extend auto-complete candidates
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- attach keybindings
vim.api.nvim_create_augroup("LspSettings", {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspSettings',
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, noremap = true, silent = true }

        -- apply code action if there is just one action
        vim.keymap.set('n', '<space>ca', function()
            vim.lsp.buf.code_action({ apply = true })
        end, opts)

        -- format buffer
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- jump to definition
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<space>.', vim.lsp.buf.definition, opts)
        -- jump to definition of the type of symbol under cursor
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        -- jump back
        vim.keymap.set('n', '<space>,', '<C-O>', opts)

        -- show information about the symbol under cursor
        vim.keymap.set('n', '<space>h', vim.lsp.buf.hover, opts)

        -- show implementations for the symbol under cursor
        vim.keymap.set('n', '<space>i', vim.lsp.buf.implementation, opts)

        -- renames all references to the symbol under the cursor.
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

        -- lists all the references to the symbol under the cursor
        vim.keymap.set('n', '<space>rf', vim.lsp.buf.references, opts)

        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
    end,
})

----------------------------------------------
-- lua ide
----------------------------------------------
require("lspconfig").lua_ls.setup {
    capabilities = lsp_defaults.capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

vim.api.nvim_create_augroup("LuaSettings", {})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    group = 'LuaSettings',
    callback = function()
        -- autoformat on save
        vim.lsp.buf.format({ async = false })
    end,
})

----------------------------------------------
-- go ide
----------------------------------------------
local gopls_exec = 'gopls'
if vim.fn.executable(gopls_exec) == 0 then
    vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', gopls_exec))
    return
end

require("lspconfig").gopls.setup {
    capabilities = lsp_defaults.capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}

vim.api.nvim_create_augroup("GoSettings", {})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    group = 'GoSettings',
    callback = function()
        -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end

        -- autoformat on save
        vim.lsp.buf.format({ async = false })
    end,
})

-- install golang ci lsp server
-- go install github.com/nametake/golangci-lint-langserver@latest

local configs = require 'lspconfig/configs'

if not configs.golangcilsp then
    configs.golangcilsp = {
        default_config = {
            cmd = { 'golangci-lint-langserver' },
            root_dir = require('lspconfig').util.root_pattern('.git', 'go.mod'),
            init_options = {
                command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
            }
        },
    }
end

-- golangci-lint language server
require('lspconfig').golangci_lint_ls.setup {
    filetypes = { 'go', 'gomod' }
}

----------------------------------------------
-- autocomplete
----------------------------------------------
local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-o>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
})

----------------------------------------------
-- pretty diagnostics
----------------------------------------------
local trouble = require("trouble")

-- set keybindings
vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end)
vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end)
vim.keymap.set("n", "gR", function() trouble.toggle("lsp_references") end)
