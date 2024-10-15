return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			styles = {
				comments = { "italic" },
				-- conditionals defaults to italics
				conditionals = {},
			},
			highlight_overrides = {
				all = function()
					return {
						-- module-related keywords
						["@module"] = { style = {} },
					}
				end,
			},
		})

		vim.cmd("colorscheme catppuccin-mocha")
	end,
}
