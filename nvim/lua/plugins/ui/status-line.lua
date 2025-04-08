return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lazy_status = require("lazy.status")

		-- Colors from iTerm2 Github Dark High Contrast color scheme
		-- for a seamless color experience across terminal and NeoVim
		-- https://github.com/cdalvaro/github-vscode-theme-iterm
		local color_bg = "#040404"
		local color_blue = "#81B5F9"
		local color_grey = "#A0A7B2"
		local color_red = "#F09895"
		local color_yellow = "#E7B94D"

		require("lualine").setup({
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = "auto",
				icons_enabled = true,
			},
			sections = {
				lualine_a = {
					{ "mode", color = { gui = "reverse,bold" } },
				},
				lualine_b = {
					{ "branch", icon = "", color = { fg = color_grey, bg = color_bg } },
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						diagnostics_color = {
							error = { fg = color_red, bg = color_bg, gui = "none" },
							warn = { fg = color_yellow, bg = color_bg, gui = "none" },
							info = { fg = color_blue, bg = color_bg, gui = "none" },
							hint = { fg = color_blue, bg = color_bg, gui = "none" },
						},
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						colored = true,
						update_in_insert = true,
						always_visible = false,
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = color_grey, bg = color_bg },
					},
				},
				lualine_y = {
					{ "location", icon = "", color = { fg = color_blue, bg = color_bg, gui = "bold" } },
				},
				lualine_z = {
					{ "filename", path = 1, color = { fg = color_grey, bg = color_bg } },
				},
			},
		})
	end,
}
