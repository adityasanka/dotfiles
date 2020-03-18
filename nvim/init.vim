" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

"----------------------------------------------
" General plugins
"----------------------------------------------
Plug 'bling/vim-airline'					" Lightweight status bar
Plug 'junegunn/goyo.vim'					" Distraction free editing
Plug 'junegunn/limelight.vim'					" Hyperfocus on the current paragraph
Plug 'bronson/vim-trailing-whitespace'				" Highlight unwanted whitespace
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }		" Code formatting
Plug 'vim-scripts/vim-gitgutter'				" Show a git diff in the gutter
Plug 'jiangmiao/auto-pairs'					" Brackets, parens, quotes in pair.
Plug 'scrooloose/nerdtree'					" Tree explorer
Plug 'scrooloose/nerdcommenter'					" Nerdy commenting powers
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }	" Aynchronous text completion
Plug 'dense-analysis/ale'					" Aynchronous lint engine

"----------------------------------------------
" Language support
"----------------------------------------------
Plug 'kylef/apiblueprint.vim'                  		   		" API Blueprint syntax highlighting
Plug 'ekalinin/dockerfile.vim'				   		" Dockerfile syntax highlighting
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }	   		" Go IDE
Plug 'zchee/deoplete-go', { 'do': 'make'}      		   		" Go auto completion
Plug 'lifepillar/pgsql.vim'                    		   		" PostgreSQL syntax highlighting
Plug 'plasticboy/vim-markdown'				   		" Markdown syntax highlighting
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  } " Markdown live preview

"----------------------------------------------
" Color schemes
"----------------------------------------------
Plug 'dracula/vim', { 'as': 'dracula' }			" Dracula

" Initialize plugin system
call plug#end()

"----------------------------------------------
" General settings
"----------------------------------------------
syntax enable			  " enable syntax highlighting
set autoindent                    " take indent for new line from previous line
set smartindent                   " enable smart indentation
set autoread                      " reload file if the file changes on the disk
set autowrite                     " write when switching buffers
set autowriteall                  " write on :quit
set number 			  " set line numbers
set cursorline 			  " highlight current line
set cursorcolumn		  " Highlight current column
set noerrorbells                  " No bells!
set novisualbell                  " I said, no bells!
set title                         " let vim set the terminal title
set updatetime=100                " redraw the status bar often
set autochdir

"----------------------------------------------
" Color scheme
"----------------------------------------------
set background=dark
set t_Co=256
color dracula

"----------------------------------------------
" Plugin: Shougo/deoplete.vim
"----------------------------------------------
let g:deoplete#enable_at_startup = 1

let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#source_importer = 1

call deoplete#custom#option({
\ 'auto_complete_delay': 0,
\ 'auto_refresh_delay': 10,
\})

" close preview window after done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"----------------------------------------------
" Plugin: zchee/deoplete-go
"----------------------------------------------
" Enable completing of go pointers
let g:deoplete#sources#go#pointer = 1

" Enable autocomplete of unimported packages
let g:deoplete#sources#go#unimported_packages = 0

"----------------------------------------------
" Plugin: bling/vim-airline
"----------------------------------------------
" Show status bar by default.
set laststatus=2

" Enable top tabline.
let g:airline#extensions#tabline#enabled = 1

" Disable showing tabs in the tabline. This will ensure that the buffers are
" what is shown in the tabline at all times.
let g:airline#extensions#tabline#show_tabs = 0

" Enable powerline fonts.
let g:airline_powerline_fonts = 0

" Explicitly define some symbols that did not work well for me in Linux.
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.branch = '⎇'
let g:airline_symbols.maxlinenr = ' L'

"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggle<cr>

" Files to ignore
let NERDTreeIgnore = [
    \ '\~$',
    \ '\.pyc$',
    \ '^\.DS_Store$',
    \ '^node_modules$',
    \ '^.ropeproject$',
    \ '^__pycache__$'
\]

" Close vim if NERDTree is the only opened window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Show hidden files by default.
let NERDTreeShowHidden = 1

" Allow NERDTree to change session root.
let g:NERDTreeChDirMode = 2

"----------------------------------------------
" Plugin: dense-analysis/ale
"----------------------------------------------
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" Enable integration with airline.
let g:airline#extensions#ale#enabled = 1

" Write this in your vimrc file
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" format message
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

"----------------------------------------------
" Plugin: junegunn/goyo
"----------------------------------------------
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

"----------------------------------------------
" Plugin: plasticboy/vim-markdown
"----------------------------------------------
" key bindings
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" Disable text folding
let g:vim_markdown_folding_disabled = 1

"----------------------------------------------
" Language: apiblueprint
"----------------------------------------------
au FileType apiblueprint set expandtab
au FileType apiblueprint set shiftwidth=4
au FileType apiblueprint set softtabstop=4
au FileType apiblueprint set tabstop=4

"----------------------------------------------
" Language: Golang
"----------------------------------------------

" Configure indentation
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" Code highlighting
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" Highlight variable usage within viewport
" let g:go_auto_sameids = 1

" Show type information in status line
let g:go_auto_type_info = 1

" Auto import dependencies
let g:go_fmt_command = "goimports"

" Use camelcase for JSON tags
let g:go_addtags_transform = "camelcase"

"----------------------------------------------
" Language: SQL
"----------------------------------------------
let g:sql_type_default = 'pgsql'	" Use lifepillar/pgsql for SQL by default

"----------------------------------------------
" Language: gitcommit
"----------------------------------------------
au FileType gitcommit setlocal spell
au FileType gitcommit setlocal textwidth=80
au FileType gitcommit set expandtab
au FileType gitcommit set shiftwidth=4
au FileType gitcommit set softtabstop=4
au FileType gitcommit set tabstop=4

"----------------------------------------------
" Language: SQL
"----------------------------------------------
au FileType sql set expandtab
au FileType sql set shiftwidth=2
au FileType sql set softtabstop=2
au FileType sql set tabstop=2

"----------------------------------------------
" Language: Markdown
"----------------------------------------------
au FileType markdown set expandtab
au FileType markdown set shiftwidth=4
au FileType markdown set softtabstop=4
au FileType markdown set tabstop=4

"----------------------------------------------
" Language: YAML
"----------------------------------------------
au FileType yaml set expandtab
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2
au FileType yaml set tabstop=2
