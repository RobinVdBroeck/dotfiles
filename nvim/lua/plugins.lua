local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

-- vim.keymap.set with default options
function keymap_set(mode, lhs, rhs, options)
    local default_options = {silent = true}
    local final_options = default_options
    for k, v in pairs(options) do final_options[k] = v end
    vim.keymap.set(mode, lhs, rhs, final_options)
end

return require("lazy").setup({
    -- General
    "editorconfig/editorconfig-vim",
    "tpope/vim-commentary",
    "tpope/vim-abolish",
    {
        "luukvbaal/stabilize.nvim",
        config = function() require("stabilize").setup() end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
	    require("indent_blankline").setup {}
        end
    },

    -- UI
    {
        "dracula/vim",
        name = "dracula",
        priority = 1000
    },
    {
        "feline-nvim/feline.nvim",
        config = function()
            vim.o.termguicolors = true
            require("statusline")
        end
    },

    -- Git
    "tpope/vim-fugitive",
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function() require("gitsigns").setup {} end
    },

    -- Keybindings
    {
        "folke/which-key.nvim",
        config = function() require("which-key").setup {} end
    },

    -- Navigation
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function() require("nvim-tree").setup {} end
    },

    {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim", "nvim-lua/plenary.nvim"
        },
        config = function()
            local telescope = require("telescope")

            keymap_set("n", "<C-p>", ":Telescope find_files<CR>",
                       {desc = "find files"})
            keymap_set("n", "<leader>ff", ":Telescope find_files<CR>",
                       {desc = "find files"})
            keymap_set("n", "<C-b>", ":Telescope buffers<CR>",
                       {desc = "find buffers"})
            keymap_set("n", "<leader>ff", ":Telescope find_files<CR>",
                       {desc = "find files"})
            keymap_set("n", "<leader>fa",
                       ":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
                       {desc = "find all"})
            keymap_set("n", "<leader>fb", ":Telescope buffers<CR>",
                       {desc = "find buffers"})
            keymap_set("n", "<leader>fr", ":Telescope oldfiles<CR>",
                       {desc = "find recent files"})
            keymap_set("n", "<leader>fg", ":Telescope live_grep<CR>",
                       {desc = "find using grep"})
            keymap_set("n", "<leader>F", ":Telescope<CR>",
                       {desc = "Open telescope window"})
            telescope.load_extension("fzf")
        end
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = function() vim.cmd ":TSUpdate" end,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                }
            }
        end
    },
    "https://github.com/khaveesh/vim-fish-syntax",


    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
         dependencies = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
         },
         config = function()
             local lsp = require("lsp-zero")
             lsp.preset("recommended")

             -- Ensure we have sumneko lua installed so it's easy to edit the
             -- config
             lsp.ensure_installed({
                 "sumneko_lua",
             })

             lsp.nvim_workspace()
             lsp.setup()

             -- Setup key mapping for code actions
             keymap_set('n', '<leader>ca', vim.lsp.buf.code_action, {
                 desc = 'Code action',
             })
             keymap_set('x', '<leader>ca', vim.lsp.buf.code_action, {
                 desc = 'Code action',
             })

         end
    },

    -- Formatting
    {
        "sbdchd/neoformat",
        config = function()
            local format_group = vim.api.nvim_create_augroup("Format",
                                                             {clear = true})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                command = "Neoformat",
                group = format_group
            })

            keymap_set("n", "<leader>cf", ":Neoformat<CR>",
                       {desc = "Format file"})
        end
    },

    -- Web development
    "mattn/emmet-vim",
    "leafOfTree/vim-vue-plugin",

    -- Rust development
    "mhinz/vim-crates",

    -- Zig development
    "ziglang/zig.vim",
})
