vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('YankHightlight', {}),
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
  end,
})

-- Adjust format options to prevent automatic insertion of newlines
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'terraform', 'dockerfile' },
  callback = function()
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('c', '')
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('r', '')
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('o', '')
  end,
})
