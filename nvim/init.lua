require("plugins")
require("options")
require("keymap")

local o = vim.o

if vim.fn.has("termguicolors") == 1 then
    print(test)
    o.termguicolors = true
    vim.cmd("colorscheme dracula")
end

-- todo: we should be able to convert this to lua
vim.cmd([[
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')
    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    " point Vim to the defined undo directory.
    let &undodir = target_path
    " finally, enable undo persistence.
    set undofile
endif
]])

vim.cmd([[
"""""""""""""""""""
" Custom commands "
"""""""""""""""""""
command! -nargs=0 ReloadConfig :source $MYVIMRC
]])
