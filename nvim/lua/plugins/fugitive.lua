return {
	"tpope/vim-fugitive",
	lazy = false, -- Load immediately (optional)
	cmd = { "Git" }, -- Load when you run the :Git command
	event = "VeryLazy", -- Load on demand
}
