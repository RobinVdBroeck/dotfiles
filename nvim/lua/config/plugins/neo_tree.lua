local M = {}

function M.setup()
  require('neo-tree').setup {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  }

  vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
  vim.keymap.set('n', '<C-n><C-f>', ':Neotree reveal<CR>', { desc = '[N]eoTree [F]ind', silent = true })
  vim.keymap.set('n', '<C-n><C-t>', ':Neotree toggle<CR>', { desc = '[N]eoTree [T]oggle', silent = true })
end

return M
