return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- source for text in buffer
		"hrsh7th/cmp-buffer",
		-- source for file system paths
		"hrsh7th/cmp-path",
		-- vs-code like pictograms
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		local is_cmp_enabled = true
		vim.keymap.set("n", "<leader>cc", function()
			is_cmp_enabled = not is_cmp_enabled
			if is_cmp_enabled then
				print("Autocomplete: ON")
			else
				print("Autocomplete: OFF")
			end
		end, { desc = "Toggle Autocomplete" })

		cmp.setup({
			enabled = function()
				return is_cmp_enabled
			end,
			completion = {
				completeopt = "menu,menuone,preview,noselect",
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
			sources = cmp.config.sources(
				-- Primary sources
				{
					{ name = "copilot", max_item_count = 5 },
					{ name = "nvim_lsp", max_item_count = 5 },
				},
				-- Fallback sources
				{
					{ name = "buffer", max_item_count = 3 },
					{ name = "path", max_item_count = 3 },
				}
			),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = { Copilot = "" },
				}),
				expandable_indicator = true,
			},
		})
	end,
}
