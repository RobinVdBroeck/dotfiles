local js_formatters = {
  'eslint_d',
  'prettier',
  'biome',
}

return {
  {
    'stevearc/conform.nvim',
    version = '^9.0.0',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
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
      async = true,
      stop_after_first = true,
      -- lsp_format = 'prefer',
      format_on_save = function(bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        -- Disable auto format on save for scss and css
        if filetype == 'css' or filetype == 'scss' then
          return nil
        end
        return {
          -- format on save can block for a max of 5 second
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
    },
  },
}
