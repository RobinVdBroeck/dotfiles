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
    Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.1.1' }
    Plug 'junegunn/fzf', {'do' : { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'lambdalisue/suda.vim'
    Plug 'dracula/vim', { 'as': 'dracula' }

    " General programming plugins
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    let g:coc_global_extensions = [
                \ 'coc-css',
                \ 'coc-ember',
                \ 'coc-eslint',
                \ 'coc-git',
                \ 'coc-html',
                \ 'coc-json',
                \ 'coc-prettier',
                \ 'coc-tsserver',
                \ 'coc-vimlsp',
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
let mapleader = "\<SPACE>"
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g ' . shellescape('!.git') " This makes :Files behave like :GFiles but with untracked files (but not ignored)
let g:suda_smart_edit = 1

"""""""""""
" Theming "
"""""""""""
if has('termguicolors')
    set termguicolors
    syntax enable
    colorscheme dracula
endif

"""""""
" COC "
"""""""
"" see: https://github.com/neoclide/coc.nvim
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set signcolumn=yes

" Use tab for triggering autocompleting
" See: https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Refactoring
nmap <leader>rn <Plug>(coc-rename) 

" Format code
nmap <leader>f <Plug>(coc-format)
xmap <leader>f <Plug>(coc-format-selected)

" GoTo code naviation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Code documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add commands
command! -nargs=0 Format          :call CocAction('format')
command! -nargs=0 Fold            :call CocAction('fold', <f-args>)
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')

" other stuff
autocmd CursorHold * silent call CocActionAsync('highlight')


"""
""" other shortcuts
""" 
nnoremap <leader>of :Files<CR> 
