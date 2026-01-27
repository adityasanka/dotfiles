return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>tz", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
	},
	opts = {
		window = {
			width = 0.80,
		},
		on_open = function()
			if vim.env.TMUX then
				vim.fn.system("tmux set status off")
			end
		end,
		on_close = function()
			if vim.env.TMUX then
				vim.fn.system("tmux set status on")
			end
		end,
	},
}
