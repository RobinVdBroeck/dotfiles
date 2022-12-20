-- Bootstrap if packer does not yet exist
-- From: https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git", "clone", "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    vim.cmd "packadd packer.nvim"
    vim.cmd "packersync"
end

local auto_packer_compile_group = vim.api.nvim_create_augroup(
                                      "AutoPackerCompile", {clear = true})

vim.api.nvim_create_autocmd("BufWritePost", {
    command = "PackerCompile",
    pattern = "plugins.lua",
    group = auto_packer_compile_group
})

-- vim.keymap.set with default options
function keymap_set(mode, lhs, rhs, options)
    local default_options = {silent = true}
    local final_options = default_options
    for k, v in pairs(options) do final_options[k] = v end
    vim.keymap.set(mode, lhs, rhs, final_options)
end

return require("packer").startup(function()
    -- Let packer manage itself, so it can update.
    use "wbthomason/packer.nvim"

    -- General
    use "editorconfig/editorconfig-vim"
    use "tpope/vim-commentary"
    use "tpope/vim-abolish"
    use {
        "luukvbaal/stabilize.nvim",
        config = function() require("stabilize").setup() end
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {}
        end
    }

    -- UI
    use {"dracula/vim", as = "dracula"}
    use {
        "famiu/feline.nvim",
        tag = "v1.1.2",
        config = function() require("statusline") end
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function() require("gitsigns").setup {} end
    }

    -- Keybindings
    use {
        "folke/which-key.nvim",
        config = function() require("which-key").setup {} end
    }

    -- Navigation
    use {
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("nvim-tree").setup {} end
    }

    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = {
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
            telescope.load_extension("fzf")
        end
    }

    -- Syntax highlighting
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function() vim.cmd ":TSUpdate" end,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {enabled = true}
            }
        end
    }
    use "https://github.com/khaveesh/vim-fish-syntax"


    -- LSP
    use {
        "VonHeikemen/lsp-zero.nvim",
         requires = {
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
    }

    -- Formatting
    use {
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
    }

    -- Web development
    use "mattn/emmet-vim"
    use "leafOfTree/vim-vue-plugin"

    -- Rust development
    use "mhinz/vim-crates"

    -- Zig development
    use "ziglang/zig.vim"
end)
