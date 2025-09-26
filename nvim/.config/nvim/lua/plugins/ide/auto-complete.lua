return {
	"saghen/blink.cmp",
	dependencies = {
		-- reconstruct completion items and apply treesitter highlighting
		"xzbdmw/colorful-menu.nvim",
		-- optional: provides snippets for the snippet source
		"rafamadriz/friendly-snippets",
	},
	-- use a release tag to download pre-built binaries
	version = "1.*",
	config = function()
		local is_cmp_enabled = true

		vim.keymap.set("n", "<leader>ta", function()
			is_cmp_enabled = not is_cmp_enabled

			if is_cmp_enabled then
				print("Autocomplete: ON")
			else
				print("Autocomplete: OFF")
			end
		end, { desc = "Toggle Autocomplete" })

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		local opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "super-tab" },

			enabled = function()
				return is_cmp_enabled
			end,

			completion = {
				menu = {
					min_width = 40,
					border = "rounded",
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					update_delay_ms = 50,
					window = {
						max_width = math.min(80, vim.o.columns),
						border = "rounded",
					},
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		}

		require("blink.cmp").setup(opts)
	end,
}
