local opt = vim.o

-- Security
opt.modelines = 0

-- Title
opt.title = true
opt.titlestring="%f%( [%M]%)"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Visual settings
opt.relativenumber = true
opt.signcolumn = "yes"

-- Whitespace settings
opt.wrap = false
opt.textwidth = 80
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.formatoptions = "tcqrn1"
opt.expandtab = true
opt.shiftround = false

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true

-- timeout len in ms (when to show popup with possible combinations)
opt.timeoutlen = 200
