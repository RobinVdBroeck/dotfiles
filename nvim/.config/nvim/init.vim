"""""""""""""""""
" Setup plugins "
"""""""""""""""""

let autoload_plug_path = stdpath('config') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    execute '!curl -fLo ' . autoload_plug_path . ' --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

let plugins_path = stdpath('data') . '/plugged'
call plug#begin(plugins_path) 
    " General vim plugins
    Plug 'junegunn/fzf', {'do' : { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'lambdalisue/suda.vim'
    Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.1.1' }

    " General programming plugins
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    let g:coc_global_extensions = [
                \ 'coc-css',
                \ 'coc-ember',
                \ 'coc-git',
                \ 'coc-html',
                \ 'coc-json',
                \ 'coc-tsserver',
                \ 'coc-vimlsp',
                \ 'coc-prettier',
                \]
    
    " Web development
    Plug 'mattn/emmet-vim'
   
    " Syntax highlighting
    Plug 'sheerun/vim-polyglot'
call plug#end()
unlet plugins_path

""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

set modelines=0 " Don't excute modelines for security
set mouse=a
set nobackup
set nowritebackup

" Splits
set splitbelow
set splitright

" Visual settings
set number relativenumber
set nu rnu
set ruler
set visualbell " Fuck beeping

" Whitespace settings
set nowrap
set textwidth=80
set tabstop=4
set shiftwidth=4
set softtabstop=4
set formatoptions=tcqrn1
set autoindent
set expandtab
set noshiftround
set smarttab

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

" plugin settings
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g ' . shellescape('!.git') " This makes :Files behave like :GFiles but with untracked files (but not ignored)
let g:suda_smart_edit = 1
let mapleader = "\<SPACE>"

"""""""
" COC "
"""""""
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Use tab for triggering autocompleting
" See: https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction
inoremap <silent><expr> <C-Space> coc#refresh()

nmap <leader>rn <Plug>(coc-rename) 

" GoTo code naviation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"""
""" other shortcuts
""" 
nnoremap <leader>of :Files<CR> 
