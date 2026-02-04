return {
	{
		"mason-org/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
			-- Buffer-local keymaps via LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(args)
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
							"<leader>xD",
							"<cmd>Telescope diagnostics bufnr=0<CR>",
							{ desc = "Show buffer diagnostics" },
						},
						{
							"n",
							"<leader>xd",
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
							"<leader>cx",
							"<cmd>LspRestart<CR>",
							{ desc = "Restart LSP" },
						},
					}

					for _, map in ipairs(keymaps) do
						local mode, lhs, rhs, opts = unpack(map)
						opts = vim.tbl_extend("keep", opts or {}, { buffer = args.buf, silent = true })
						vim.keymap.set(mode, lhs, rhs, opts)
					end
				end,
			})

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

			-- Cache runtime files for lua_ls
			local nvim_runtime_files = vim.api.nvim_get_runtime_file("", true)

			-- Special configs
			local server_configs = {
				lua_ls = {
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
								library = nvim_runtime_files,
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
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
				},
			}

			-- Setup LSP servers using mason-lspconfig handlers
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"bashls",
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
