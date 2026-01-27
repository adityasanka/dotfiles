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
			{ "<leader>+", hidden = true, desc = "Increment number" },
			{ "<leader>-", hidden = true, desc = "Decrement number" },
			{ "<leader>.", hidden = true, desc = "Go to definition" },
			{ "<leader>,", hidden = true, desc = "Jump back" },
		},
	},
}
