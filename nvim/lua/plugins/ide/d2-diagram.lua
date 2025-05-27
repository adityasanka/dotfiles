return {
	"terrastruct/d2-vim",
	ft = "d2",
	config = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.d2",
			callback = function(args)
				require("conform").format({ bufnr = args.buf, formatters = { "d2" } })
			end,
		})
	end,
}
