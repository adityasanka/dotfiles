return {
	"stevearc/aerial.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			-- Priority list of preferred backends
			backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },

			layout = {
				default_direction = "prefer_right",
				min_width = 40,
				max_width = { 80, 0.3 },
				resize_to_content = true,
			},

			show_guides = true,

			-- Auto-open for files > 100 lines, but only for specific filetypes
			open_automatic = function(bufnr)
				local line_count = vim.api.nvim_buf_line_count(bufnr)
				local filetype = vim.bo[bufnr].filetype

				local supported_filetypes = {
					"go",
					"lua",
				}

				return line_count > 100 and vim.tbl_contains(supported_filetypes, filetype)
			end,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })
		vim.keymap.set("n", "<leader>A", "<cmd>AerialNavToggle<CR>", { desc = "Toggle Aerial Nav" })
	end,
}
