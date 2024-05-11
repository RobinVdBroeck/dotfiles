local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print 'Installing lazy'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release lazypath,
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

return require('lazy').setup {
  -- General
  'tpope/vim-commentary',
  'tpope/vim-abolish',
  'tpope/vim-sleuth',

  {
    'lukas-reineke/indent-blankline.nvim',
    version = '^3.0.0',
    main = 'ibl',
    event = 'BufReadPost',
    opts = {},
  },

  -- UI
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      local onedark = require 'onedark'
      onedark.setup {
        style = 'dark',
      }
      onedark.load()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Git
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(buffnr)
        vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { buffer = buffnr, desc = '[G]o to [P]revious hunk' })
        vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { buffer = buffnr, desc = '[G]o to [N]revious hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = buffnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  -- Keybindings
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {},
  },

  -- Navigation
  {
    'kyazdani42/nvim-tree.lua',
    priority = 999,
    dependencies = 'kyazdani42/nvim-web-devicons',
    opts = {},
    keys = {
      {
        '<leader>n',
        ':NvimTreeFocus<CR>',
        desc = 'Focus [N]vimtree',
      },
      {
        '<C-n><C-t>',
        ':NvimTreeToggle<CR>',
        desc = '[N]vimtree [T]oggle',
      },
      {
        '<C-n><C-f>',
        ':NvimTreeFindFile<CR>',
        desc = '[N]vimtree [F]ind file',
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-lua/plenary.nvim',
    },
    cmd = 'Telescope',
    keys = {
      {
        '<C-p>',
        ':Telescope find_files<CR>',
        desc = 'find files',
      },
      {
        '<leader>ff',
        ':Telescope find_files<CR>',
        desc = 'find files',
      },
      {
        '<C-b>',
        ':Telescope buffers<CR>',
        desc = 'find buffers',
      },
      {
        '<leader>ff',
        ':Telescope find_files<CR>',
        desc = 'find files',
      },
      {
        '<leader>fa',
        ':Telescope find_files follow=true no_ignore=true hidden=true<CR>',
        desc = 'find all',
      },
      {
        '<leader>fb',
        ':Telescope buffers<CR>',
        desc = 'find buffers',
      },
      {
        '<leader>fr',
        ':Telescope oldfiles<CR>',
        desc = 'find recent files',
      },
      {
        '<leader>fg',
        ':Telescope live_grep<CR>',
        desc = 'find using grep',
      },
      {
        '<leader>F',
        ':Telescope<CR>',
        desc = 'Open telescope window',
      },
      {
        '<leader>ds',
        function()
          require('telescope.builtin').lsp_document_symbols()
        end,
        desc = '[D]ocument [S]ymbols',
      },
      {
        '<leader>ws',
        function()
          require('telescope.builtin').lsp_dynamic_workspace_symbols()
        end,
        desc = '[W]orkspace [S]ymbols',
      },
      {
        '<leader>fs',
        function()
          require('telescope.builtin').lsp_dynamic_workspace_symbols()
        end,
        desc = '[F]ind workspace [S]ymbols',
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          -- Fix for memory leak in ripgrep,
          -- see: https://github.com/nvim-telescope/telescope.nvim/issues/2482
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          path_display = { 'truncate' },
          layout_config = {
            prompt_position = 'bottom',
            preview_cutoff = 0,
            horizontal = {
              width = { padding = 0.1 },
              height = { padding = 0.1 },
              preview_width = 0.25,
            },
            vertical = {
              width = { padding = 0.1 },
              height = { padding = 0.1 },
            },
          },
        },
        extentions = { 'fzf' },
      }
    end,
  },

  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        highlight = {
          enable = true,
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(_lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
        },
      }
    end,
  },

  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = {},
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    event = 'InsertEnter',
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'copilot' },
        }, {
          { name = 'buffer' },
        }),
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = false },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    event = 'InsertEnter',
    opts = {},
  },

  -- LSP
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason').setup {}

      -- Setup binding between mason and lspconfig
      local mlsp = require 'mason-lspconfig'
      local lspconfig = require 'lspconfig'
      mlsp.setup {
        ensure_installed = { 'lua_ls' },
      }
      mlsp.setup_handlers {
        function(server_name)
          if server_name == 'tsserver' then
            return
          end
          lspconfig[server_name].setup {}
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' },
                },
              },
            },
          }
        end,
      }

      -- Setup global keymapping
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfixlist' })
    end,
  },
  {
    -- Use typescript tooling instead of mason-lspconfig for typescript, since it
    -- has some nice performance optimisations
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    version = '^5.0.0',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format {
            lsp_fallback = true,
            -- blocks for maximum 5 seconds
            timeout_ms = 5000,
          }
        end,
        mode = 'n',
        desc = '[c]hange [f]ormat',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylelua' },
        javascript = { { 'eslintd', 'prettier' } },
        typescript = { { 'eslintd', 'prettier' } },
        typescriptreact = { { 'eslintd', 'prettier' } },
        javascriptreact = { { 'eslintd', 'prettier' } },
      },
    },
  },

  -- Web development
  'mattn/emmet-vim',
  'leafOfTree/vim-vue-plugin',

  -- Rust development
  {
    'mhinz/vim-crates',
    ft = 'toml',
  },

  -- Zig development
  'ziglang/zig.vim',
}
