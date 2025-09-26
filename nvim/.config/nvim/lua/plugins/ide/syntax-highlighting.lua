return {
	-- better syntax highlighting
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = { enable = true },
			-- automatically install missing parsers when entering buffer
			auto_install = true,
			-- install parsers asynchronously (only applied to `ensure_installed`)
			sync_install = false,
			-- ensure these language parsers are installed
			ensure_installed = {
				"lua",
				"go",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"yaml",
				"markdown",
				"markdown_inline",
				"bash",
				"vim",
				"dockerfile",
				"gitignore",
			},
			-- list of parsers to ignore installing
			ignore_install = {},
			-- modules configuration
			modules = {},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
