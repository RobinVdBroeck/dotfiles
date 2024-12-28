if vim.fn.has 'persistent_undo' == 1 then
  -- Define a path to store persistent undo files.
  local target_path = vim.fn.expand '~/.config/vim-persisted-undo/'

  -- Create the directory and any parent directories if the location does not exist.
  if vim.fn.isdirectory(target_path) == 0 then
    vim.fn.system { 'mkdir', '-p', target_path }
  end

  -- Point Neovim to the defined undo directory.
  vim.opt.undodir = target_path

  -- Enable undo persistence.
  vim.opt.undofile = true
end
