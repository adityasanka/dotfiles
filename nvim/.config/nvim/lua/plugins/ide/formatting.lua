return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local formatting_options = {
			lsp_format = "fallback",
			async = false,
			timeout_ms = 1000,
		}

		conform.setup({
			formatters = {
				d2 = {
					command = "d2",
					args = { "fmt", "$FILENAME" },
				},
			},
			formatters_by_ft = {
				go = { "goimports", "gofmt" },
				lua = { "stylua" },
				html = { "prettier" },
				css = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				d2 = { "d2" },
			},
			format_on_save = formatting_options,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format(formatting_options)
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
