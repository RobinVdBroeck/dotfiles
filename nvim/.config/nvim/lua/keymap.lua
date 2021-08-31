-- TODO: move this to a util
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    for m in mode:gmatch "" do
        vim.api.nvim_set_keymap(m, lhs, rhs, options)
    end
end

vim.g.mapleader = " "

-- Navigation
-- TODO: this should be moved to telescope config
map("n", "<C-p>", ":Telescope find_files<CR>")
map("n", "<leader>ff", ":Telescope find_files<CR>") -- find files
map("n", "<leader>fr", ":Telescope find_files<CR>") -- find recent files
map("n", "<leader>ffb", ":Telescope file_browser<CR>") -- find files using browser
map("n", "<leader>fg", ":Telescope live_grep<CR>") -- find grep
map("n", "<leader>fb", ":Telescope buffers<CR>") -- find in buffers
map("n", "<leader>fh", ":Telescope help_tags<CR>") -- find help -- TODO: use lsp?
map("n", "<leader>fs", ":lua require'telescope.builtin'.treesitter{}<CR>")

-- Saving
map("n", "<C-s>", ":w<CR>")
map("i", "<C-s>", ":<ESC>w<CR>")

-- Copy paste from `+` register (also known as clipboard)
map("xno", "<leader>y", '"+y')
map("xno", "<leader>p", '"+p')

-- Tabs
map("n", "<leader>nt", ":tabe<CR>")
map("n", "<TAB>", ":tabn<CR>")
map("n", "<leader>ct", ":tabclose<CR>")

-- Window movement
-- TODO: we should be able to convert this to a lua function
vim.cmd(
    [[
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
)
map("n", "<C-w>h", ":call WindowMove('h')<CR>")
map("n", "<C-w>j", ":call WindowMove('j')<CR>")
map("n", "<C-w>k", ":call WindowMove('k')<CR>")
map("n", "<C-w>l", ":call WindowMove('l')<CR>")
-- <C-w>c closes by default

-- Nvimtree
map("n", "<leader>n", ":NvimTreeFocus<CR>")
map("n", "<C-n><C-t>", ":NvimTreeToggle<CR>")
