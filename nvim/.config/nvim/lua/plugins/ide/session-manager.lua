return {
	"rmagatti/auto-session",
	config = function()
		-- recommended sessionoptions config
		-- https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config
		--
		-- preserve window layouts, terminal states, and local options
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		local auto_session = require("auto-session")

		auto_session.setup({
			-- ignore auto session for these directories
			suppressed_dirs = { "~/", "~/Developer", "~/Downloads", "~/Desktop/" },
			-- ignore auto session for these filetypes
			bypass_save_filetypes = { "alpha", "oil" },
			-- auto save session on exit
			auto_save = true,
			-- auto restore session on start
			auto_restore = true,
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>wf", "<cmd>SessionSearch<CR>", { desc = "Find session" })
		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
		keymap.set("n", "<leader>wt", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle session autosave" })
	end,
}
