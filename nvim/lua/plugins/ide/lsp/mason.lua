return {
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

		-- install and update tools
		-- find available packages at https://mason-registry.dev/registry/list
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- lua
				"lua-language-server",
				"stylua",
				-- go
				"gopls",
				"gofumpt",
				"goimports",
				"golines",
				"gomodifytags",
				"json-to-struct",
				"impl",
				"staticcheck",
				"gotests",
				--
				"golangci-lint",
				"golangci-lint-langserver",
				-- bash
				"bash-language-server",
				"shellcheck",
				"shfmt",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
