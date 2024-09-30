return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"meuter/lualine-so-fancy.nvim",
	},
	config = function()
		local lazy_status = require("lazy.status")

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
			},
			sections = {
				lualine_a = {
					{ "fancy_mode", width = 3 },
				},
				lualine_b = {
					{ "fancy_branch" },
					{ "fancy_diff" },
				},
				lualine_c = {
					{ "filename", path = 1 },
					-- { "fancy_cwd", substitute_home = true },
				},
				lualine_x = {
					{ "fancy_macro" },
					{ "fancy_diagnostics" },
					{ "fancy_searchcount" },
					{ "fancy_location" },
				},
				lualine_y = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						-- color = { fg = "#ff9e64" },
					},
					{ "fancy_filetype", ts_icon = "" },
				},
				lualine_z = {
					{ "fancy_lsp_servers" },
				},
			},
		})
	end,
}
