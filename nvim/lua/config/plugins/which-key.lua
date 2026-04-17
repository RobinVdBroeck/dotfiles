local M = {}

function M.setup()
  vim.o.timeout = true
  vim.o.timeoutlen = 500

  require('which-key').setup {
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
    },
  }
end

return M
