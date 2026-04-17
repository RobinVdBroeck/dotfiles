local M = {}

function M.setup()
  require('gitsigns').setup {
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

      map('n', '[h', gitsigns.prev_hunk, { desc = 'go to [P]revious hunk' })
      map('n', ']h', gitsigns.next_hunk, { desc = 'go to [N]revious hunk' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
    end,
  }
end

return M
