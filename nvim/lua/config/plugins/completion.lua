local M = {}

function M.setup()
  require('copilot').setup {
    suggestion = { enabled = true },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  }

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  require('blink.cmp').setup {
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    sources = {
      default = { 'copilot', 'lsp', 'path', 'buffer' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },
  }
end

return M
