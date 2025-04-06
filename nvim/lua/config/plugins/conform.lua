return {
  {
    'stevearc/conform.nvim',
    version = '^9.0.0',
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
      async = true,
      stop_after_first = true,
      format_on_save = function(bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        -- Disable auto format on save for scss and css
        if filetype == 'css' or filetype == 'scss' then
          return nil
        end
        return {
          -- format on save can block for a max of 1 second
          timeout_ms = 1000,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'eslint_d', 'prettier', 'biome' },
        typescript = { 'eslint_d', 'prettier' },
        typescriptreact = { 'eslint_d', 'prettier' },
        javascriptreact = { 'eslint_d', 'prettier' },
        terraform = { 'tofu_fmt' },
      },
    },
  },
}
