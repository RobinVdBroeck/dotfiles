require("plugins")
require("options")
require("keymap")

local o = vim.o

if vim.fn.has("termguicolors") == 1 then
    o.termguicolors = true
    vim.cmd("colorscheme dracula")
end

-- todo: we should be able to convert this to lua
vim.cmd([[
"""""""""""""""""""
" Custom commands "
"""""""""""""""""""
command! -nargs=0 ReloadConfig :source $MYVIMRC
]])
