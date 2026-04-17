local js_formatters = {
  'eslint_d',
  'prettier',
  'biome',
}

local M = {}

function M.setup()
  require('conform').setup {
    async = true,
    stop_after_first = true,
    format_on_save = function(bufnr)
      local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if filetype == 'css' or filetype == 'scss' then
        return nil
      end
      return {
        timeout_ms = 5000,
        lsp_format = 'never',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = js_formatters,
      typescript = js_formatters,
      typescriptreact = js_formatters,
      javascriptreact = js_formatters,
      terraform = { 'tofu_fmt' },
    },
  }

  vim.keymap.set('n', '<leader>cf', function()
    require('conform').format {
      lsp_fallback = true,
      timeout_ms = 5000,
    }
  end, { desc = '[c]hange [f]ormat' })
end

return M
