return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'petertriho/cmp-git',
    },
    event = 'InsertEnter',
    opts = function()
      local cmp = require 'cmp'
      return {
        completion = { completeopt = 'menu,menuone,noinsert' },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
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
}
