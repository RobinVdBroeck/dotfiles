-- TODO: Convert to which-key
-- TODO: move this to a util
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend("force", options, opts) end

    for m in mode:gmatch "" do vim.api.nvim_set_keymap(m, lhs, rhs, options) end
end

vim.g.mapleader = " "

-- Clear search highlighting after pressing enter
map("n", "<CR>", ":noh<CR><CR>:<backspace>")

-- Saving
map("n", "<C-s>", ":w<CR>")
map("i", "<C-s>", ":<ESC>w<CR>")

-- Copy paste from `+` register (also known as clipboard)
map("xno", "<leader>y", '"+y')
map("xno", "<leader>p", '"+p')

-- Window movement
-- TODO: we should be able to convert this to a lua function
vim.cmd([[
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
]])
map("n", "<C-w>h", ":call WindowMove('h')<CR>")
map("n", "<C-w>j", ":call WindowMove('j')<CR>")
map("n", "<C-w>k", ":call WindowMove('k')<CR>")
map("n", "<C-w>l", ":call WindowMove('l')<CR>")
-- <C-w>c closes by default

-- Nvimtree
map("n", "<leader>n", ":NvimTreeFocus<CR>")
map("n", "<C-n><C-t>", ":NvimTreeToggle<CR>")
