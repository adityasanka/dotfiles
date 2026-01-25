-- GitHub Dark High Contrast color palette
-- Source: https://github.com/cdalvaro/github-vscode-theme-iterm

local M = {}

-- ANSI colors (standard terminal palette)
M.ansi_0 = "#7B828D" -- bright black / dark grey
M.ansi_1 = "#F09895" -- red
M.ansi_3 = "#E7B94D" -- yellow
M.ansi_4 = "#81B5F9" -- blue
M.ansi_5 = "#C497F9" -- magenta / purple
M.ansi_6 = "#66C2CD" -- cyan
M.ansi_7 = "#DADEDF" -- white / light grey
M.ansi_8 = "#A0A7B2" -- grey
M.ansi_9 = "#F5B5B1" -- bright red / salmon
M.ansi_10 = "#79DE76" -- green
M.ansi_11 = "#EFCB5D" -- bright yellow
M.ansi_12 = "#9DBCFB" -- bright blue
M.ansi_13 = "#D5B8FB" -- bright magenta / lavender
M.ansi_14 = "#7ACFD4" -- bright cyan / teal

-- Foreground
M.foreground = "#F1F3F6" -- white

-- Backgrounds (darkest to lightest)
M.crust = "#000000" -- pure black
M.mantle = "#020202" -- near black
M.base = "#040404" -- dark grey (main background)

-- UI backgrounds
M.bg_current_line = "#1c1c1c" -- subtle highlight
M.bg_visual_block = "#2c2c2c" -- selection highlight

-- Ghost text
M.fg_ghost_text = "#6e7681" -- muted grey

return M
