local opt = vim.opt

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Security
opt.modelines = 0

-- Title
opt.title = true
opt.titlestring = '%f%( [%M]%)'

-- Mouse
opt.mouse = 'a'

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Spelling
opt.spell = true
opt.spelllang = 'en_us'
opt.splitkeep = 'screen'

-- Visual settings
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.termguicolors = true

-- Whitespace settings
opt.wrap = false
opt.textwidth = 80
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.formatoptions = 'tcqrn1'
opt.expandtab = true
opt.shiftround = false

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Scrolling
opt.scrolloff = 5

-- Use /bin/sh instead of the user provided shell
opt.shell = '/bin/sh'

-- Completion options
opt.completeopt = 'menu,menuone,noselect'
