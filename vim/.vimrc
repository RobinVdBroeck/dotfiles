" Setup plugins
if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin("~/.vim/plugged") 
    " General plugins
    Plug 'dense-analysis/ale', { 'tag': 'v2.7.0' }

    " Javascript
    Plug 'pangloss/vim-javascript', { 'tag': 'v1.2.2' }
    Plug 'maxmellon/vim-jsx-pretty', { 'tag': 'v3.0.0' }
call plug#end()

" Basic stuff
set nocompatible " Dont try to be compatible with vi
set modelines=0 " Don't excute modelines for security
set encoding=utf-8 "UTF-8 is the only relevant encoding, dont try to tell me otherwise

" Visual settings
set number relativenumber
set nu rnu
set ruler
set visualbell " Fuck beeping

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

" Use :W to save files as root
command W :execute ':silent w !sudo tee % > dev/null/' | :edit!

