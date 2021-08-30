-- Bootstrap if packer does not yet exist
-- From: https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Recompile packer whenever plugins.lua changes
vim.cmd 'autocmd BufWritePost plugins.lua source <afile> | PackerCompile'

return require('packer').startup(function()
   -- Let packer manage itself, so it can update.
   use 'wbthomason/packer.nvim'
   
   -- General
   use 'editorconfig/editorconfig-vim'
 
   -- UI
   use {'dracula/vim', as = 'dracula'}
   use 'vim-airline/vim-airline'

   -- Keybindings
   use {
      'AckslD/nvim-whichkey-setup.lua',
      requires = {'liuchengxu/vim-which-key'},
   }

   -- Navigation
   use {
       'kyazdani42/nvim-tree.lua',
       requires = 'kyazdani42/nvim-web-devicons'
   }

   -- Syntax highlighting
   -- TODO: should use treesitter
   use 'sheerun/vim-polyglot'
   
   -- LSP
   use { 
      'neovim/nvim-lspconfig',
      config = function()
         require('plugins.lspconfig.rust')
      end
   }

   -- Autocompletion
   use {
     'hrsh7th/nvim-cmp',
     requires = {
       'hrsh7th/cmp-buffer',
       'hrsh7th/cmp-nvim-lsp',
     },
     config = function()
        vim.o.completeopt = 'menuone,noselect'

        local fn = vim.fn
        local replace_termcodes = vim.api.nvim_replace_termcodes

        local check_back_space = function()
           local col = fn.col('.') - 1
           return col == 0 or fn.getline('.').sub(col,col):match('%s')
        end
        
        local cmp = require('cmp')
        cmp.setup {
           mapping = {
             ['<C-p>'] = cmp.mapping.select_prev_item(),
             ['<C-n>'] = cmp.mapping.select_next_item(),
             ['<C-d>'] = cmp.mapping.scroll_docs(-4),
             ['<C-f>'] = cmp.mapping.scroll_docs(4),
             ['<C-Space>'] = cmp.mapping.complete(),
             ['<C-e>'] = cmp.mapping.close(),
             ['<CR>'] = cmp.mapping.confirm {
               behavior = cmp.ConfirmBehavior.Replace,
               select = true,
             },
             ['<Tab>'] = function(fallback)
                if fn.pumvisible() == 1 then
                   fn.feedkeys(replace_termcodes('<C-n>', true, true, true),'n')
                elseif check_back_space() then
                   fn.feedkeys(replace_termcodes('<Tab>', true, true, true),'n')
                else
                  fallback()
                end
              end
           },
           sources = {
             { name = 'nvim_lsp' },
             { name = 'buffer' }
           }
        }
     end
   }
   
   -- Web development
   use 'mattn/emmet-vim'
   use 'leafOfTree/vim-vue-plugin'
end)
