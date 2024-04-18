return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- source for text in buffer
		"hrsh7th/cmp-buffer",
		-- source for file system paths
		"hrsh7th/cmp-path",
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			-- Replace <CurrentMajor> by the latest released major (first number of latest release)
			version = "v2.*",
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		-- source for snippets
		"saadparwaiz1/cmp_luasnip",
		-- useful snippets
		"rafamadriz/friendly-snippets",
		-- vs-code like pictograms
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				-- copilot source
				{ name = "copilot", max_item_count = 5 },
				-- lsp
				{ name = "nvim_lsp", max_item_count = 5 },
				-- snippets
				{ name = "luasnip", max_item_count = 2 },
				-- text within current buffer
				{ name = "buffer", max_item_count = 3 },
				-- file system paths
				{ name = "path", max_item_count = 3 },
			}),

			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = { Copilot = "" },
				}),
			},
		})
	end,
}
