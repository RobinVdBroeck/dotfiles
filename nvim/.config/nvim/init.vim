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
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " General programming plugins
    Plug 'dense-analysis/ale', { 'tag': 'v2.7.0' }

    " Javascript
    Plug 'pangloss/vim-javascript', { 'tag': 'v1.2.2' }
    Plug 'maxmellon/vim-jsx-pretty', { 'tag': 'v3.0.0' }
call plug#end()
unlet plugins_path

" source vim config
source ~/.vimrc
