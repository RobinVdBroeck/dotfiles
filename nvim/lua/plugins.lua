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

return require("lazy").setup({
    -- General
    "tpope/vim-commentary",
    "tpope/vim-abolish",
    "tpope/vim-sleuth",

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
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~'},
            },
            on_attach = function (buffnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, {buffer = buffnr, desc="[G]o to [P]revious hunk"})
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, {buffer = buffnr, desc="[G]o to [N]revious hunk"})
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, {buffer = buffnr, desc="[P]review [H]unk"})
            end
        }
    },

    -- Keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {}
    },

    -- Navigation
    {
        "kyazdani42/nvim-tree.lua",
        priority = 999,
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            local function open_nvim_tree()
                require("nvim-tree.api").tree.open()
            end

            require("nvim-tree").setup {}
            vim.api.nvim_create_autocmd({ "VimEnter" }, {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = open_nvim_tree
            })
        end
    },


    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },
            "nvim-lua/plenary.nvim"
        },
        cmd = "Telescope",
        keys = {
            {
                "<C-p>",
                ":Telescope find_files<CR>",
                 desc = "find files"
            },
            {
                "<leader>ff",
                ":Telescope find_files<CR>",
                 desc = "find files"
            },
            {
                "<C-b>",
                ":Telescope buffers<CR>",
                desc = "find buffers"
            },
            {
                "<leader>ff",
                ":Telescope find_files<CR>",
                 desc = "find files"
            },
            {
                "<leader>fa",
                ":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
                 desc = "find all",
            },
            {
                "<leader>fb",
                ":Telescope buffers<CR>",
                desc = "find buffers"
            },
            {
                "<leader>fr",
                ":Telescope oldfiles<CR>",
                desc = "find recent files"
            },
            {
                "<leader>fg",
                ":Telescope live_grep<CR>",
                 desc = "find using grep"
            },
            {
                "<leader>F",
                ":Telescope<CR>",
                desc = "Open telescope window"
            },
        },
        config = function()
            require("telescope").setup {
                defaults = {
                    -- Fix for memory leak in ripgrep,
                    -- see: https://github.com/nvim-telescope/telescope.nvim/issues/2482
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    path_display = { "truncate" },
                    layout_config = {
                        prompt_position = "bottom",
                        preview_cutoff = 0,
                        horizontal = {
                            width = { padding = 0.1 },
                            height = { padding = 0.1 },
                        preview_width = 0.25,
                        },
                        vertical = {
                            width = { padding = 0.1 },
                            height = { padding = 0.1 },
                        },
                    },
                },
                extentions = { "fzf" }
            }
        end
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                }
            }
        end
    },


    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {},
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "copilot" },
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
    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        opts = {}
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
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "open diagnostic" })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "prevous diagnostic" })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "next diagnostic " })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "diagnoastic quickfixlist" })


            -- Setup keymappings based on buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = function(desc)
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
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
                        opts("workspace remove folder"))
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
    {
        "mhinz/vim-crates",
        ft = "toml",
    },

    -- Zig development
    "ziglang/zig.vim",
})
