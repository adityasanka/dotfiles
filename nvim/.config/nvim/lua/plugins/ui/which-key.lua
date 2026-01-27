return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>n", group = "Clear" },
			{ "<leader>s", group = "Split" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>w", group = "Session" },
			{ "<leader>x", group = "Diagnostics" },
		},
	},
}
