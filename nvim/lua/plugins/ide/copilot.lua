return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			-- When integrating the blink-copilot plugin with copilot.lua in Neovim,
			-- it's recommended to disable the default Copilot suggestions and panel.
			--
			-- This is because blink-copilot serves as a custom completion source for blink.cmp,
			-- providing Copilot suggestions through this framework.
			--
			-- Enabling both the default Copilot UI and blink-copilot can lead to overlapping
			-- suggestions and conflicts in keybindings
			--
			-- By disabling the default Copilot UI components, you ensure that all Copilot
			-- suggestions are managed exclusively by blink.cmp, resulting in a more streamlined
			-- and conflict-free experience.
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
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
