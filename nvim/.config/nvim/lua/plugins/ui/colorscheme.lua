return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local colors = require("core.colors")

		local function create_color_overrides()
			local color_map = {
				-- Primary colors
				rosewater = colors.ansi_9,
				flamingo = colors.ansi_1,
				pink = colors.ansi_13,
				mauve = colors.ansi_5,
				red = colors.ansi_1,
				maroon = colors.ansi_9,
				peach = colors.ansi_11,
				yellow = colors.ansi_3,
				green = colors.ansi_10,
				teal = colors.ansi_14,
				sky = colors.ansi_6,
				sapphire = colors.ansi_6,
				blue = colors.ansi_4,
				lavender = colors.ansi_12,
				-- Text hierarchy
				text = colors.foreground,
				subtext1 = colors.ansi_7,
				subtext0 = colors.ansi_8,
				-- Overlays
				overlay2 = colors.ansi_0,
				overlay1 = colors.ansi_8,
				overlay0 = colors.ansi_0,
				-- Surfaces
				surface2 = colors.base,
				surface1 = colors.mantle,
				surface0 = colors.crust,
				base = colors.base,
				mantle = colors.mantle,
				crust = colors.crust,
			}

			return { all = color_map }
		end

		local function create_custom_highlights(catppuccin_colors)
			return {
				-- Line numbers
				LineNr = { fg = catppuccin_colors.subtext0 },
				CursorLineNr = { fg = catppuccin_colors.lavender },
				CursorLine = { bg = colors.bg_current_line },

				-- Visual selection
				Visual = { bg = colors.bg_visual_block },
				VisualNOS = { bg = colors.bg_visual_block },

				-- UI elements
				PmenuSel = { bg = colors.bg_current_line },
				BlinkCmpMenuSelection = { bg = colors.bg_current_line },
				TelescopeSelection = { bg = colors.bg_current_line },

				-- Syntax modifications
				["@module"] = { style = {} }, -- Remove default italics

				-- Git integration
				GitSignsCurrentLineBlame = { fg = colors.fg_ghost_text },
			}
		end

		require("catppuccin").setup({
			color_overrides = create_color_overrides(),
			custom_highlights = create_custom_highlights,
			styles = {
				conditionals = {},
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
