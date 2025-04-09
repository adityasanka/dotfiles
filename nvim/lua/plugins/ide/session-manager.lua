return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_session_suppress_dirs = { "~/", "~/Developer", "~/Downloads", "~/Desktop/" },
			-- auto save session on exit
			auto_store_enabled = true,
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>wf", "<cmd>SessionSearch<CR>", { desc = "Find session" })
		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
		keymap.set("n", "<leader>wt", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle session autosave" })
	end,
}
