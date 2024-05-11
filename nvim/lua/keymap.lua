local function map(mode, lhs, rhs)
  local options = { noremap = true, silent = true }

  for m in mode:gmatch '' do
    vim.keymap.set(m, lhs, rhs, options)
  end
end

vim.g.mapleader = ' '

-- Clear search highlighting after pressing enter
map('n', '<CR>', ':noh<CR><CR>:<backspace>')

-- Saving
map('n', '<C-s>', ':w<CR>')
map('i', '<C-s>', ':<ESC>w<CR>')

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

-- Setup keymappings based on buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = function(desc)
      return {
        buffer = ev.buf,
        desc = desc,
      }
    end
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts '[g]oto [D]eclaration')
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts '[g]oto [d]efinition')
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts 'hover')
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts '[g]oto [i]mplementation')
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts 'signature help')
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts '[w]orkspace [a]dd folder')
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts '[w]orkspace [r]emove folder')
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts '[w]orkspace [l]ist folder')
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts 'type [D]efintion')
    vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, opts '[c]hange [n]ame')
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts '[c]ode [a]ction')
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts '[g]oto [r]eferences')
  end,
})
