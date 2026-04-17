local M = {}

function M.setup()
  require('arborist').setup()

  -- Disable treesitter highlighting for very large files.
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
      if ok and stats and stats.size > 2 * 1024 * 1024 then
        vim.treesitter.stop(args.buf)
      end
    end,
  })
end

return M
