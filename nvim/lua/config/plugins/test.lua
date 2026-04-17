local M = {}

function M.setup()
  require('neotest').setup {
    adapters = {
      require 'neotest-mocha' {},
      require 'neotest-vitest',
    },
  }
end

return M
