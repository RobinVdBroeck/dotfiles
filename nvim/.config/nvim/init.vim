" Setup plugins
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

    " General programming plugins
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    let g:coc_global_extension = ['coc-json', 'coc-git', 'coc-html', 'coc-css','coc-ember', 'coc_prettier', 'coc-tsserver']

    " Javascript
    Plug 'pangloss/vim-javascript', { 'tag': 'v1.2.2' }
    Plug 'maxmellon/vim-jsx-pretty', { 'tag': 'v3.0.0' }

    " Other languages
    Plug 'joukevandermaas/vim-ember-hbs'
call plug#end()
unlet plugins_path

" source vim config
source ~/.vimrc

" plugin settings
let g:suda_smart_edit = 1

" shortcuts
let mapleader = "\<SPACE>"
nnoremap <Leader>o :Files<CR>
