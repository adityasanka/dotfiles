--[[ return {
     -- github color scheme
    'projekt0n/github-nvim-theme',
    priority = 1000,
    config = function()
        vim.cmd('colorscheme github_dark_high_contrast')
    end
} ]]

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd("colorscheme catppuccin-mocha")

		require("catppuccin").setup({
			styles = {
				comments = { "italic" },
			},
		})
	end,
}
