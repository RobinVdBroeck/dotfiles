" Basic stuff
set nocompatible " Dont try to be compatible with vi
syntax on " Highlight syntax
set modelines=0 " Don't excute modelines for security
set encoding=utf-8 "UTF-8 is the only relevant encoding, dont try to tell me otherwise

" Visual settings
set number relativenumber
set nu rnu
set ruler
set visualbell " Fuck beeping
colorscheme gruvbox
set background=dark

" Whitespace settings
set wrap
set textwidth=80
set tabstop=4
set shiftwidth=4
set softtabstop=4
set formatoptions=tcqrn1
set autoindent
set expandtab
set noshiftround

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Gruvbox remappings for search
nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

" Use :W to save files as root
command W :execute ':silent w !sudo tee % > dev/null/' | :edit!
