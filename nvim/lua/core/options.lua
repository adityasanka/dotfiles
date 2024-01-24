-- use true color
vim.opt.termguicolors = true

-- show line numbers
vim.opt.number = true
-- highlight current line
vim.opt.cursorline = true

-- mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- indicate fast terminal conn for faster redraw
vim.o.ttyfast = true

-- indent settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- timings
vim.o.updatetime = 1000
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved
vim.wo.signcolumn = "yes"

-- show line numbers
vim.opt.backspace = 'indent,eol,start'
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
vim.o.pumheight = 10
