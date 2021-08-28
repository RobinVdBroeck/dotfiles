-- Bootstrap if packer does not yet exist
-- From: https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Recompile packer whenever plugins.lua changes
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function()
   -- Let packer manage itself, so it can update.
   use 'wbthomason/packer.nvim' 

   -- General 
   use 'editorconfig/editorconfig-vim'
   
   -- UI
   use {'dracula/vim', as = 'dracula'}
   use 'vim-airline/vim-airline'
    
   -- Navigation 
   use 'ctrlpvim/ctrlp.vim'
   use 'preservim/nerdtree'

   -- Syntax highlighting
   -- TODO: should use treesitter
   use 'sheerun/vim-polyglot' 

   -- LSP
   -- TODO: should uses nvim builtin LSP
   use {'neoclide/coc.nvim', branch='release'}
   
   -- Web development
   use 'mattn/emmet-vim'
   use 'leafOfTree/vim-vue-plugin'
end)
