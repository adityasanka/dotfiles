return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"gopls",
				"tsserver",
				"html",
				"cssls",
				"pyright",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				{ "golangci-lint", auto_update = true },
				{ "gopls", auto_update = true },
				"goimports",
				"gofumpt",
				"golines",
				"gomodifytags",
				"gotests",
				"json-to-struct",
				"bash-language-server",
				"vim-language-server",
				"lua-language-server",
				"stylua", -- lua formatter
				"shellcheck",
				"shfmt",
				"editorconfig-checker",
				"impl",
				"misspell",
				"revive",
				"staticcheck",
				"prettier", -- prettier formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
			},
		})
	end,
}
