return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"zbirenbaum/copilot-cmp",
	},
	config = function()
		require("copilot").setup({
			filetypes = {
				-- disable copilot temporarily since subscription is inactive
				-- disable for all other filetypes and ignore default `filetypes`
				["*"] = false,
			},
			suggestion = { enabled = false },
			panel = { enabled = false },
		})

		require("copilot_cmp").setup()
	end,
}
