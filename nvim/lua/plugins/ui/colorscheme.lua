return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		-- Colors from iTerm2 Github Dark High Contrast color scheme
		-- for a seamless color experience across your terminal and NeoVim
		-- https://github.com/cdalvaro/github-vscode-theme-iterm
		local ansi_0 = "#7B828D"
		local ansi_1 = "#F09895"
		-- ansi_2 removed as it's unused and duplicates ansi_10
		local ansi_3 = "#E7B94D"
		local ansi_4 = "#81B5F9"
		local ansi_5 = "#C497F9"
		local ansi_6 = "#66C2CD"
		local ansi_7 = "#DADEDF"
		local ansi_8 = "#A0A7B2"
		local ansi_9 = "#F5B5B1"
		local ansi_10 = "#79DE76"
		local ansi_11 = "#EFCB5D"
		local ansi_12 = "#9DBCFB"
		local ansi_13 = "#D5B8FB"
		local ansi_14 = "#7ACFD4"

		local foreground = "#F1F3F6"

		-- The main background color.
		-- This is the primary shade used for most of the editor's background.
		local base = "#040404"
		-- A slightly darker shade than base, used to provide contrast,
		-- often for UI elements that need subtle separation.
		local mantle = "#020202"
		-- The darkest shade of the background, used for even deeper contrast,
		-- such as borders, popups, or inactive elements.
		local crust = "#000000"

		-- colors imported from GitHub Dark High Contrast color scheme
		-- https://github.com/projekt0n/github-nvim-theme

		-- background color for the current line
		local bg_current_line = "#1c1c1c"

		-- background color for visual block
		local bg_visual_block = "#2c2c2c"

		-- text color for ghost text
		-- ex: git blame inline, copilot suggestion
		local fg_ghost_text = "#6e7681"

		local function create_color_overrides()
			local color_map = {
				-- Primary colors
				rosewater = ansi_9,
				flamingo = ansi_1,
				pink = ansi_13,
				mauve = ansi_5,
				red = ansi_1,
				maroon = ansi_9,
				peach = ansi_11,
				yellow = ansi_3,
				green = ansi_10,
				teal = ansi_14,
				sky = ansi_6,
				sapphire = ansi_6,
				blue = ansi_4,
				lavender = ansi_12,
				-- Text hierarchy
				text = foreground,
				subtext1 = ansi_7,
				subtext0 = ansi_8,
				-- Overlays
				overlay2 = ansi_0,
				overlay1 = ansi_8,
				overlay0 = ansi_0,
				-- Surfaces
				surface2 = base,
				surface1 = mantle,
				surface0 = crust,
				base = base,
				mantle = mantle,
				crust = crust,
			}

			return { all = color_map }
		end

		local function create_custom_highlights(colors)
			return {
				-- Line numbers
				LineNr = { fg = colors.subtext0 },
				CursorLineNr = { fg = colors.lavender },
				CursorLine = { bg = bg_current_line },

				-- Visual selection
				Visual = { bg = bg_visual_block },
				VisualNOS = { bg = bg_visual_block },

				-- UI elements
				PmenuSel = { bg = bg_current_line },
				BlinkCmpMenuSelection = { bg = bg_current_line },
				TelescopeSelection = { bg = bg_current_line },

				-- Syntax modifications
				["@module"] = { style = {} }, -- Remove default italics

				-- Git integration
				GitSignsCurrentLineBlame = { fg = fg_ghost_text },
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
