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
    'catppuccin/nvim',
    as = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = 'dark' -- or 'light'

      vim.cmd.colorscheme 'catppuccin'
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
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = buffnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '[h', gitsigns.prev_hunk, { desc = '[G]o to [P]revious hunk' })
        map('n', ']h', gitsigns.next_hunk, { desc = '[G]o to [N]revious hunk' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
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
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    version = '~1.9.0',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      filters = { custom = { '^.git$' } },
      filesystem_watchers = { ignore_dirs = { 'node_modules', '.git', 'build' } },
      view = {
        -- by setting this to an empty table, we allow the tree to auto-resize when opening new dirs
        width = {},
      },
    },
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
    'antosha417/nvim-lsp-file-operations',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.6',
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
      {
        '<leader>h',
        function()
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local list = vim.fn.systemlist 'git diff --name-only --merge-base master'

          pickers
            .new({}, {
              prompt_title = 'Changed files from master',
              finder = finders.new_table { results = list },
              previewer = conf.file_previewer {},
              sorter = conf.generic_sorter {},
            })
            :find()
        end,
        desc = 'Quick File picker using git',
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
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
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'lua', 'markdown', 'vim', 'vimdoc' },
        auto_install = true,
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
      'petertriho/cmp-git',
      'zbirenbaum/copilot-cmp',
    },
    event = 'InsertEnter',
    opts = function()
      local cmp = require 'cmp'
      return {
        completion = { completeopt = 'menu,menuone,noinsert' },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'copilot' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- Accept ([y]es) the selected
          -- Will auto import if the LSP supports it.
          ['<C-y>'] = cmp.mapping.confirm { select = true },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require 'cmp'
      cmp.setup(opts)
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
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
