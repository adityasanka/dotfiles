-- This file contains the global options for the editor

-- set file tree style
vim.g.netrw_liststyle = 3

local opt = vim.opt

-- set relative line number
opt.relativenumber = true
-- show current line number
opt.number = true

-- tabs and indentation
-- expand tab to spaces
opt.expandtab = true
-- 4 spaces for tabs
opt.tabstop = 4
-- 4 spaces for indent width
opt.shiftwidth = 4
-- copy indent from current line when starting a new line
opt.autoindent = true
opt.smartindent = true
-- wrap long lines
opt.wrap = true

-- search settings
-- ignore case when searching
opt.ignorecase = true
-- if you have mixed case in your search term, assume case sensitive
opt.smartcase = true

-- highlight current line
opt.cursorline = true

-- use true color for better color scheme
opt.termguicolors = true
-- colorschemes that have both light and dark will be made dark
opt.background = "dark"

-- always show the signcolumn, otherwise it would shift the
-- text each time diagnostics appear/become resolved
opt.signcolumn = "yes"

-- allow backspace on indent, end of line or insert mode start position
opt.backspace = "indent,eol,start"

-- use system clipboard as the default register
opt.clipboard:append("unnamedplus")

-- split windows
-- split vertical window to the right
vim.opt.splitbelow = true
-- split horizontal window to the bottom
vim.opt.splitright = true

-- use true color
--[[ vim.opt.termguicolors = true

-- mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- indicate fast terminal conn for faster redraw
vim.o.ttyfast = true

-- timings
vim.o.updatetime = 1000
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

-- buffer should still exist if window is closed
vim.opt.hidden = true

-- shows the match while typing
vim.opt.hlsearch = false
-- highlight found searches
vim.opt.incsearch = true
-- search case insensitive...
vim.opt.ignorecase = true
-- ... but not it begins with upper case
vim.opt.smartcase = true

-- no beeps!
vim.o.errorbells = false
-- no bells!
vim.o.visualbell = false

-- don't use swapfile
vim.opt.swapfile = false
-- don't create annoying backup files
vim.opt.backup = false

-- show me what I'm typing
vim.o.showcmd = true

-- wait to redraw
vim.o.lazyredraw = true

-- reload file if the file changes on the disk
vim.o.autoread = true
-- automatically save before :next, :make etc. Or when switching buffers
vim.o.autowrite = true
-- automatically write before running commands and changing files

-- change cwd to directory of buffer
vim.o.autochdir = true

-- completion window max size
-- vim.o.pumheight = 10 ]]
