return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install { 'lua', 'vim', 'vimdoc' }

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf = args.buf
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          -- Disable treesitter highlighting for large files
          if ok and stats and stats.size > 2 * 1024 * 1024 then
            vim.treesitter.stop(buf)
            return
          end
          -- Auto-install missing parsers and enable highlighting
          local lang = vim.treesitter.language.get_lang(args.match) or args.match
          if lang and not vim.tbl_contains(ts.get_installed(), lang) and vim.tbl_contains(ts.get_available(), lang) then
            ts.install({ lang }):wait(60000)
          end
          pcall(vim.treesitter.start, buf)
        end,
      })
    end,
  },
}
