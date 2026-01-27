return {
	"stevearc/aerial.nvim",
	keys = {
		{ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
		{ "<leader>A", "<cmd>AerialNavToggle<CR>", desc = "Toggle Aerial Nav" },
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
		layout = {
			default_direction = "prefer_right",
			min_width = 40,
			max_width = { 80, 0.3 },
			resize_to_content = true,
		},
		show_guides = true,
	},
}
