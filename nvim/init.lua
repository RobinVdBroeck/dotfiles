-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require 'plugins'
require 'options'
require 'keymap'

local o = vim.o

if vim.fn.has 'termguicolors' == 1 then
  o.termguicolors = true
  vim.cmd 'colorscheme dracula'
end

vim.o.spell = true
vim.o.spelllang = 'en_us'

-- todo: we should be able to convert this to lua
vim.cmd [[
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
]]

vim.cmd [[
"""""""""""""""""""
" Custom commands "
"""""""""""""""""""
command! -nargs=0 ReloadConfig :source $MYVIMRC
]]

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('OpenNvimTreeOnStartup', {}),
  callback = function(data)
    local IGNORED_FT = {
      'gitcommit',
      'gitrebase',
    }

    local directory = vim.fn.isdirectory(data.file) == 1
    local ft = vim.bo[data.buf].ft

    if vim.tbl_contains(IGNORED_FT, ft) then
      return
    end

    if directory then
      vim.cmd.cd(data.file)
    end

    require('nvim-tree.api').tree.toggle {
      focus = directory,
    }
  end,
})
