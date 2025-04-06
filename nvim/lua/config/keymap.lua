local function map(mode, lhs, rhs)
  local options = { noremap = true, silent = true }

  for m in mode:gmatch '' do
    vim.keymap.set(m, lhs, rhs, options)
  end
end

-- Clear search highlighting after pressing enter or esc
map('n', '<CR>', ':noh<CR><CR>:<backspace>')
map('n', '<ESC>', ':noh<CR><CR>:<backspace>')

-- Copy paste
map('nv', '<leader>y', '"+y')
map('nv', '<leader>p', '"+p')

-- Window movement
-- TODO: we should be able to convert this to a lua function
vim.cmd [[
" Moves to window. if not exist, create one
function! WindowMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key, '[jk]'))
        wincmd v
    else
        wincmd s
    endif
    " move to newly created window
    exec "wincmd ".a:key
endif
endfunction
]]
map('n', '<C-w>h', ":call WindowMove('h')<CR>")
map('n', '<C-w>j', ":call WindowMove('j')<CR>")
map('n', '<C-w>k', ":call WindowMove('k')<CR>")
map('n', '<C-w>l', ":call WindowMove('l')<CR>")
-- <C-w>c closes by default
