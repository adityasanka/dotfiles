return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lazy_status = require("lazy.status")
		local colors = require("core.colors")

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
					{ "branch", icon = "", color = { fg = colors.ansi_8, bg = colors.base } },
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						diagnostics_color = {
							error = { fg = colors.ansi_1, bg = colors.base, gui = "none" },
							warn = { fg = colors.ansi_3, bg = colors.base, gui = "none" },
							info = { fg = colors.ansi_4, bg = colors.base, gui = "none" },
							hint = { fg = colors.ansi_4, bg = colors.base, gui = "none" },
						},
						symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
						colored = true,
						update_in_insert = true,
						always_visible = false,
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.ansi_8, bg = colors.base },
					},
				},
				lualine_y = {
					{ "progress", icon = "", color = { fg = colors.ansi_4, bg = colors.base } },
					{ "location", icon = "", color = { fg = colors.ansi_4, bg = colors.base, gui = "bold" } },
				},
				lualine_z = {
					{ "filename", path = 1, color = { fg = colors.ansi_8, bg = colors.base } },
				},
			},
		})
	end,
}
