return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>c", group = "Code" },
			{ "<leader>s", group = "Split" },
			{ "<leader>w", group = "Session" },
			{ "<leader>x", group = "Diagnostics" },
		},
	},
}
