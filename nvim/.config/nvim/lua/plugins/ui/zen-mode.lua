return {
	"folke/zen-mode.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local zen = require("zen-mode")

		zen.setup({
			window = {
				-- 80% editor width
				width = 0.80,
			},
			on_open = function()
				-- Hide tmux status bar
				vim.fn.system("tmux set status off")
			end,
			on_close = function()
				-- Restore tmux status bar
				vim.fn.system("tmux set status on")
			end,
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })
	end,
}
