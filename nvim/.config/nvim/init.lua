require('options')
require('plugins')

local g = vim.g
local o = vim.o

----------
--- coc  -
----------
g.coc_global_extension = {
     'coc-angular',
     'coc-clangd',
     'coc-css',
     'coc-eslint',
     'coc-git',
     'coc-html',
     'coc-json',
     'coc-prettier',
     'coc-pyright',
     'coc-rust-analyzer',
     'coc-tslint',
     'coc-tsserver',
     'coc-vimlsp',
     'coc-lua',
}

-- see: https://github.com/neoclide/coc.nvim
o.cmdheight=2
o.updatetime=300
o.shortmess = o.shortmess .. "c"
o.signcolumn="yes"

if vim.fn.has('termguicolors') == 1 then
    o.termguicolors = true
    vim.cmd("colorscheme dracula")
end

vim.cmd([[
"""""""""""""""""""
" Custom commands "
"""""""""""""""""""
command! -nargs=0 ReloadConfig :source $MYVIMRC

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

----------------
-- Keymapping --
----------------
-- TODO: use a plugin or custom api to manage these more easier
-- note: plugin specific maps can be found in their section
local set_keymap = vim.api.nvim_set_keymap
g.mapleader = "<Space>"
set_keymap("n", "<Space>", "<Nop>", { noremap = true })
-- saving
set_keymap("n", "<C-s>", ":w<CR>", { silent = true })
set_keymap("i", "<C-s>", ":<ESC>w<CR>", { silent = true })
-- copy paste from `+` register (also known as clipboard)
set_keymap("x", "<leader>y", "\"+y", {})
set_keymap("n", "<leader>y", "\"+y", {})
set_keymap("o", "<leader>y", "\"+y", {})
set_keymap("x", "<leader>p", "\"+p", {})
set_keymap("n", "<leader>p", "\"+p", {})
set_keymap("o", "<leader>p", "\"+p", {})
-- Tabs
set_keymap("n", "<leader>nt", ":tabe<CR>", { noremap = true, silent = true})
set_keymap("n", "<TAB>", ":tabn<CR>", { noremap = true, silent = true})
set_keymap("n", "<leader>ct", ":tabclose<CR>", { noremap = true, silent = true})
-- window movement
set_keymap("n", "<C-w>h", ":call WindowMove('h')<CR>", { noremap = true, silent = true})
set_keymap("n", "<C-w>j", ":call WindowMove('j')<CR>", { noremap = true, silent = true})
set_keymap("n", "<C-w>k", ":call WindowMove('k')<CR>", { noremap = true, silent = true})
set_keymap("n", "<C-w>l", ":call WindowMove('l')<CR>", { noremap = true, silent = true})
-- <C-w>c closes by default

-- nerdtree
set_keymap("n", "<leader>n", ":NERDTreeFocus<CR>", { noremap = true, silent = true})
set_keymap("n", "<C-n><C-t>", ":NERDTreeToggle<CR>", { noremap = true, silent = true})

vim.cmd([[
"""""""
" COC "
"""""""
" Use tab for triggering autocompleting
" See: https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction


inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Refactoring
nmap <leader>rn <Plug>(coc-rename) 

" Format code
nmap <leader>f <Plug>(coc-format)
xmap <leader>f <Plug>(coc-format-selected)

" GoTo code naviation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Code documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add commands
command! -nargs=0 Format          :call CocAction('format')
command! -nargs=0 Fold            :call CocAction('fold', <f-args>)
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')

" other stuff
autocmd CursorHold * silent call CocActionAsync('highlight')
]])
