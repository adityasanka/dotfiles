-- this file contains the global options for the editor

local opt = vim.opt

------------------------------------------
-- file browser
------------------------------------------
-- display files in a tree style listing
vim.g.netrw_liststyle = 3

------------------------------------------
-- line numbers
------------------------------------------
-- set relative line number
opt.relativenumber = true
-- show current line number
opt.number = true

-- highlight current line
opt.cursorline = true

------------------------------------------
-- sane defaults for indentation
------------------------------------------
-- 4 spaces for tabs
opt.tabstop = 4
-- 4 spaces for indent width
opt.shiftwidth = 4
-- expand tab to spaces
opt.expandtab = true
-- copy indent from current line when starting a new line
opt.autoindent = true
opt.smartindent = true

-- allow backspace on indent, end of line or insert mode start position
opt.backspace = "indent,eol,start"

------------------------------------------
-- line wrapping
------------------------------------------
-- wrap long lines
opt.wrap = true
-- indent wrapped lines
opt.breakindent = true
-- avoid breaking words in the middle
opt.linebreak = true

------------------------------------------
-- search settings
------------------------------------------
-- search case insensitive...
opt.ignorecase = true
-- ... but not it begins with upper case
opt.smartcase = true

-- shows the match while typing
opt.hlsearch = false
-- highlight found searches
opt.incsearch = true

------------------------------------------
-- colors
------------------------------------------
-- use true color for better color scheme
opt.termguicolors = true
-- colorschemes that have both light and dark will be made dark
opt.background = "dark"

------------------------------------------
-- split windows
------------------------------------------
-- split vertical window to the right
opt.splitbelow = true
-- split horizontal window to the bottom
opt.splitright = true

------------------------------------------
-- sign column
------------------------------------------
-- always show the signcolumn, otherwise it would shift the
-- text each time diagnostics appear/become resolved
opt.signcolumn = "yes"

------------------------------------------
-- system clipboard
------------------------------------------
-- use system clipboard as the default register
opt.clipboard:append("unnamedplus")

------------------------------------------
-- mouse settings
------------------------------------------
opt.mouse = "a"
opt.mousefocus = true

------------------------------------------
-- beeps and bells
------------------------------------------
-- no beeps!
opt.errorbells = false
-- no bells!
opt.visualbell = false

------------------------------------------
-- backups
------------------------------------------
-- don't use swapfile
opt.swapfile = false
-- don't create annoying backup files
opt.backup = false

------------------------------------------
-- timings and responsiveness
------------------------------------------
-- indicate fast terminal conn for faster redraw
opt.ttyfast = true

opt.updatetime = 1000
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

------------------------------------------
-- buffers and files
------------------------------------------
-- buffer should still exist if window is closed
opt.hidden = true
-- reload file if the file changes on the disk
opt.autoread = true
-- automatically save before :next, :make etc. Or when switching buffers
opt.autowrite = true
-- automatically write before running commands and changing files

-- change cwd to directory of buffer
opt.autochdir = true

------------------------------------------
-- miscellaneous
------------------------------------------
-- show me what I'm typing
-- reduce errors by providing immediate feedback
opt.showcmd = true

-- always show status line
-- improve navigation and situational awareness
opt.laststatus = 2

-- compact pop up menu
opt.pumheight = 10

-- ensure some lines remain are visible above and below when scrolling
-- keeps context visible around current line
opt.scrolloff = 10
