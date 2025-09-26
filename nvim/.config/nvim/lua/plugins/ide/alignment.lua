return {
	"junegunn/vim-easy-align",
	event = "VeryLazy",
	config = function()
		-- Start interactive EasyAlign in visual mode (e.g. vipga)
		vim.keymap.set("v", "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })

		-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
		vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })
	end,
}
