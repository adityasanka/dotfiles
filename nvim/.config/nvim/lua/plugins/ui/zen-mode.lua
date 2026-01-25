return {
	"folke/zen-mode.nvim",
	config = function()
		local zen = require("zen-mode")

		zen.setup({
			window = {
				-- 80% editor width
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
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })
	end,
}
