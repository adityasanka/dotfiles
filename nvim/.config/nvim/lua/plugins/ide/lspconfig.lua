return {
	{
		"mason-org/mason.nvim",
		dependencies = {
			-- automatically update the tools
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- bridges mason and nvim-lspconfig
			-- automatically sets up LSP servers
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- install and update non-LSP tools (formatters, linters, utilities)
			-- LSP servers are managed by mason-lspconfig below
			-- find available packages at https://mason-registry.dev/registry/list
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- lua
					"stylua",
					-- go
					"gofumpt",
					"goimports",
					"golines",
					"gomodifytags",
					"json-to-struct",
					"impl",
					"staticcheck",
					"gotests",
					"golangci-lint",
					-- bash
					"shellcheck",
					"shfmt",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local keymaps = {
				{
					"n",
					"<leader>cR",
					"<cmd>Telescope lsp_references<CR>",
					{ desc = "Show LSP references" },
				},
				{
					"n",
					"<leader>.",
					vim.lsp.buf.definition,
					{ desc = "Go to definition" },
				},
				{
					"n",
					"<leader>cd",
					"<cmd>Telescope lsp_definitions<CR>",
					{ desc = "Show LSP definitions" },
				},
				{
					"n",
					"<leader>ci",
					"<cmd>Telescope lsp_implementations<CR>",
					{ desc = "Show LSP implementations" },
				},
				{
					"n",
					"<leader>ct",
					"<cmd>Telescope lsp_type_definitions<CR>",
					{ desc = "Show LSP type definitions" },
				},
				{
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ desc = "See available code actions" },
				},
				{
					"n",
					"<leader>cr",
					vim.lsp.buf.rename,
					{ desc = "Smart rename" },
				},
				{
					"n",
					"<leader>D",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					{ desc = "Show buffer diagnostics" },
				},
				{
					"n",
					"<leader>d",
					vim.diagnostic.open_float,
					{ desc = "Show line diagnostics" },
				},
				{
					"n",
					"K",
					vim.lsp.buf.hover,
					{ desc = "Show documentation for what is under cursor" },
				},
				{
					"n",
					"<leader>rs",
					"<cmd>LspRestart<CR>",
					{ desc = "Restart LSP" },
				},
			}

			for _, map in ipairs(keymaps) do
				local mode, lhs, rhs, opts = unpack(map)
				opts = vim.tbl_extend("keep", opts or {}, { silent = true })
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			-- Use blink's lsp capabilities for better autocompletion
			-- assign capabilities to every lsp server config
			-- https://cmp.saghen.dev/installation#lsp-capabilities
			local lsp_capabilities = require("blink.cmp").get_lsp_capabilities(
				-- lsp default capabilities
				-- lspconfig.util.default_config
				vim.lsp.protocol.make_client_capabilities()
			)

			-- Default config for all servers
			local default_config = {
				capabilities = lsp_capabilities,
			}

			-- Special configs
			local server_configs = {
				lua_ls = {
					capabilities = lsp_capabilities,
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
				gopls = {
					cmd = { "gopls", "serve" },
					capabilities = lsp_capabilities,
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
					on_attach = function()
						vim.api.nvim_create_augroup("GoSettings", { clear = true })
						vim.api.nvim_create_autocmd("BufWritePre", {
							pattern = "*.go",
							group = "GoSettings",
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
								if not result then
									return
								end
								for cid, res in pairs(result) do
									if type(res) ~= "table" or res.error then
										goto continue
									end
									for _, r in pairs(res.result or {}) do
										if r.edit then
											local client = vim.lsp.get_client_by_id(cid)
											local enc = client and client.offset_encoding or "utf-16"
											vim.lsp.util.apply_workspace_edit(r.edit, enc)
										end
									end
									::continue::
								end

								-- autoformat on save
								vim.lsp.buf.format({ async = false })
							end,
						})
					end,
				},
				golangci_lint_ls = {
					filetypes = { "go", "gomod" },
				},
			}

			-- Setup LSP servers using mason-lspconfig handlers
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"bashls",
					"golangci_lint_ls",
				},
				handlers = {
					-- Default handler for all servers
					function(server_name)
						local config = vim.tbl_deep_extend("force", default_config, server_configs[server_name] or {})
						lspconfig[server_name].setup(config)
					end,
				},
			})
		end,
	},
}
