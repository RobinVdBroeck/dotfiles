return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
          enable = true,
          -- Disable slow treesitter highlight for large files
          disable = function(_, buf)
            local kb = 1024
            local mb = 1024 * kb
            local max_filesize = 2 * mb
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
        },
      }
    end,
  },
}
