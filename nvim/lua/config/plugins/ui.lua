return {
  {
    'catppuccin/nvim',
    as = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = 'dark' -- or 'light'

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
      },
    },
  },
}
