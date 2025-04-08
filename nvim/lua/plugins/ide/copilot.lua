return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			require("copilot").setup({
				panel = { enabled = false },
			})

			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
		},
		-- build command required for macOS/Linux only
		-- tiktoken is used for calculating token limits
		build = "make tiktoken",
		-- Add plugin-specific options here
		opts = {},
	},
}
