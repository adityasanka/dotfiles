---@diagnostic disable: undefined-global

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybindingss
				-- show definition, references
				opts.desc = "Show LSP references"
				keymap.set("n", "<leader>cR", "<cmd>Telescope lsp_references<CR>", opts)

				-- go to declaration
				opts.desc = "Go to definition"
				keymap.set("n", "<leader>.", vim.lsp.buf.definition, opts)

				-- show lsp definitions
				opts.desc = "Show LSP definitions"
				keymap.set("n", "<leader>cd", "<cmd>Telescope lsp_definitions<CR>", opts)

				-- show lsp implementations
				opts.desc = "Show LSP implementations"
				keymap.set("n", "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", opts)

				-- show lsp type definitions
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "<leader>ct", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				-- see available code actions, in visual mode will apply to selection
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				-- smart rename
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

				-- show diagnostics for file
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				-- show diagnostics for line
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				-- jump to previous diagnostic in buffer
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				-- jump to next diagnostic in buffer
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				-- show documentation for what is under cursor
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- mapping to restart lsp if necessary
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Use blink's lsp capabilities for better autocompletion
		-- assign capabilities to every lsp server config
		-- https://cmp.saghen.dev/installation#lsp-capabilities
		local lsp_capabilities = require("blink.cmp").get_lsp_capabilities(
			-- lsp default capabilities
			lspconfig.util.default_config
		)

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = lsp_capabilities,
				})
			end,
			-- configure emmet language server
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = lsp_capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			-- configure lua server (with special settings)
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = lsp_capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			-- configure go server (with special settings)
			["gopls"] = function()
				local gopls_exec = "gopls"
				if vim.fn.executable(gopls_exec) == 0 then
					vim.api.nvim_err_writeln(string.format("lsp: %q is not installed", gopls_exec))
					return
				end

				lspconfig.gopls.setup({
					cmd = { gopls_exec, "serve" },
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
				})

				vim.api.nvim_create_augroup("GoSettings", {})
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
				local configs = require("lspconfig/configs")

				if not configs.golangcilsp then
					configs.golangcilsp = {
						default_config = {
							cmd = { "golangci-lint-langserver" },
							root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
							init_options = {
								command = {
									"golangci-lint",
									"run",
									"--enable-all",
									"--disable",
									"lll",
									"--out-format",
									"json",
									"--issues-exit-code=1",
								},
							},
						},
					}
				end

				-- golangci-lint language server
				lspconfig.golangci_lint_ls.setup({
					filetypes = { "go", "gomod" },
				})
			end,
		})
	end,
}
