local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

-- vim.keymap.set with default options
function keymap_set(mode, lhs, rhs, options)
    local default_options = { silent = true }
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
        dependencies = { "nvim-lua/plenary.nvim" },
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

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim", "nvim-lua/plenary.nvim"
        },
        config = function()
            local telescope = require("telescope")

            keymap_set("n", "<C-p>", ":Telescope find_files<CR>",
                { desc = "find files" })
            keymap_set("n", "<leader>ff", ":Telescope find_files<CR>",
                { desc = "find files" })
            keymap_set("n", "<C-b>", ":Telescope buffers<CR>",
                { desc = "find buffers" })
            keymap_set("n", "<leader>ff", ":Telescope find_files<CR>",
                { desc = "find files" })
            keymap_set("n", "<leader>fa",
                ":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
                { desc = "find all" })
            keymap_set("n", "<leader>fb", ":Telescope buffers<CR>",
                { desc = "find buffers" })
            keymap_set("n", "<leader>fr", ":Telescope oldfiles<CR>",
                { desc = "find recent files" })
            keymap_set("n", "<leader>fg", ":Telescope live_grep<CR>",
                { desc = "find using grep" })
            keymap_set("n", "<leader>F", ":Telescope<CR>",
                { desc = "Open telescope window" })
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


    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                    ['<S-Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end
                }),
            }
        end
    },

    -- LSP
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig"
        },
        config = function()
            require("mason").setup {}

            -- Setup binding between mason and lspconfig
            local mlsp = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            mlsp.setup {
                ensure_installed = { "lua_ls" }
            }
            mlsp.setup_handlers {
                function(server_name)
                    lspconfig[server_name].setup {}
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end,
            }

            -- Setup global keymapping
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "open diagnostic"})
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "prevous diagnostic" })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "next diagnostic " })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "diagnoastic quickfixlist" })


            -- Setup keymappings based on buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = function (desc)
                        return {
                            buffer = ev.buf,
                            desc = desc
                        }
                    end
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("goto Decleration"))
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("goto definition"))
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("hover"))
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("goto implementation"))
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts("signature help"))
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts("workspace add folder"))
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts("workspace remove folder"))
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts("workspace list folder"))
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts("type defintion"))
                    vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, opts("change name")) -- change name
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts("code action"))
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("goto references"))
                    vim.keymap.set('n', '<leader>cf', function()
                        vim.lsp.buf.format { async = true }
                    end, opts("change format"))
                end,
            })
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
