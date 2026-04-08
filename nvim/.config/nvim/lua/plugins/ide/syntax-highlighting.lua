return {
	-- better syntax highlighting
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "windwp/nvim-ts-autotag" },
	config = function()
		require("nvim-treesitter").setup()

		-- ensure these language parsers are installed
		require("nvim-treesitter").install({
			"lua",
			"go",
			"json",
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
			"vim",
			"dockerfile",
			"gitignore",
		})

		-- start highlighting + indent on supported filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype
				local lang = vim.treesitter.language.get_lang(ft) or ft
				if not (lang and pcall(vim.treesitter.start, buf, lang)) then
					return
				end
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- nvim-ts-autotag still has its own setup on the main branch
		require("nvim-ts-autotag").setup()
	end,
}
