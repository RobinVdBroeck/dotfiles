local M = {}

-- catppuccin is applied in lua/config/pack.lua immediately after vim.pack.add
-- so the colorscheme is active before any buffer is drawn.
function M.setup()
  require('lualine').setup {
    options = {
      globalstatus = true,
    },
  }
end

return M
