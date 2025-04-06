return {
  {
    'stevearc/conform.nvim',
    version = '^8.0.0',
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
      format_on_save = {
        -- format on save can block for a max of 1 second
        timeout_ms = 1000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylelua' },
        javascript = { { 'eslint_d', 'prettier' }, 'biome' },
        typescript = { { 'eslint_d', 'prettier' } },
        typescriptreact = { { 'eslint_d', 'prettier' } },
        javascriptreact = { { 'eslint_d', 'prettier' } },
        terraform = { 'tofu_fmt' },
        -- Don't format scss
        scss = {},
      },
    },
  },
}
