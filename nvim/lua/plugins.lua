-- Bootstrap if packer does not yet exist
-- From: https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd "packadd packer.nvim"
end

vim.cmd([[
aug AutoPackerCompile
    au!
    au BufWritePost plugins.lua source <afile> | PackerCompile
aug end
]])

lsp_setup_buffer_keymap = function(_client, bufnr)
    local is_wk_present, wk = pcall(require, "which-key")
    if(is_wk_present == false) then
        print("which-key not found")
        return
    end
    local buf = vim.lsp.buf

    wk.register(
        {
            g = {
                d = {buf.definition, "definition"},
                D = {buf.declaration, "declaration"},
                i = {buf.implementation, "implementation"},
                r = {buf.references, "references"}
            },
            K = {buf.hover, "Hover"},
            ["<leader>"] = {
                c = {
                    name = "code",
                    a = {buf.code_action, "action"}
                },
                rn = {buf.rename, "rename"},
                rf = {buf.formatting, "reformat"},
                w = {
                    name = "workspace",
                    s = {":Telescope lsp_workspace_symbols<CR>", "symbols"}
                }
            }
        },
        {
            mode = "n",
            buffer = bufnr
        }
    )
end

lsp_get_capabilities = function(cmp_nvim_lsp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if(cmp_nvim_lsp_present == false) then
        print("Cannot find cmp_nvim_lsp")
        return capabilities
    end

    return cmp_nvim_lsp.update_capabilities(capabilities)
end

return require("packer").startup(
    function()
        -- Let packer manage itself, so it can update.
        use "wbthomason/packer.nvim"

        -- General
        use "editorconfig/editorconfig-vim"
        use "tpope/vim-commentary" 

        -- UI
        use {"dracula/vim", as = "dracula"}
        use {
            'famiu/feline.nvim',
            tag='v0.1.1',
            config = function()
                require('statusline')
            end
        }

        -- Git
        use {
            "lewis6991/gitsigns.nvim",
            requires = {"nvim-lua/plenary.nvim"},
            config = function()
                require("gitsigns").setup {}
            end
        }

        -- Keybindings
        use {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {}
            end
        }

        -- Navigation
        use {
            "kyazdani42/nvim-tree.lua",
            requires = "kyazdani42/nvim-web-devicons"
        }

        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "folke/which-key.nvim",
            },
            config = function()
                local builtins = require('telescope.builtin')
                local wk = require('which-key')

                wk.register({
                    ["<C-p>"] = {":Telescope find_files<CR>", "find files"},
                    ["<C-b>"] = {":Telescope buffers<CR>", "find buffers"},
                    ["<leader>f"] = {
                       name = "Find",
                       f = {":Telescope find_files<CR>", "file"},
                       fb = {":Telescope file_browser<CR>", "file browser"},
                       b = {":Telescope buffers<CR>", "buffers"},
                       r = {":Telescope oldfiles<CR>", "recent files"},
                       g = {":Telescope live_grep<CR>", "grep"},
                       h = {":Telescope help_tags<CR>", "help"}, -- todo: use lsp?
                       s = {function()
                           builtins.treesitter {}
                       end, "symbols"},
                    }
                }, {
                    mode = 'n',
                })
            end
        }

        -- Syntax highlighting
        use {
            "nvim-treesitter/nvim-treesitter",
            run = function()
                vim.cmd ":TSUpdate"
            end,
            branch="0.5-compat",
            config = function()
                require("nvim-treesitter.configs").setup {
                    ensure_installed = "maintained"
                }
            end
        }
        use {
            "tikhomirov/vim-glsl",
            config = function()
                vim.cmd([[
                    aug FtGlsl
                        au!
                        au BufNewFile,BufRead *.vs,*.fs,*.vert,*.tesc,*.tese,*.geom,*.frag,*.comp,*.glsl set ft=glsl
                    aug end
                ]])
            end
        }
        use "https://github.com/khaveesh/vim-fish-syntax"

        -- LSP
        use {
            "neovim/nvim-lspconfig",
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "folke/which-key.nvim",
            },
            config = function()
                local lspconfig = require("lspconfig")
                local capabilities = lsp_get_capabilities(cmp_nvim_lsp)

                -- Rust is handled in rust-tools
                local servers = {"angularls", "tsserver"}
                for _, lsp in ipairs(servers) do
                    lspconfig[lsp].setup {
                        on_attach = function(client, buffernr)
                            lsp_setup_buffer_keymap(client, buffernr)
                        end,
                        capabilities = capabilities

                    }
                end
            end
        }

        -- Autocompletion
        use {
            "onsails/lspkind-nvim",
            config = function()
                require("lspkind").init {}
            end
        }

        use {
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "l3mon4d3/luasnip",
                "onsails/lspkind-nvim",
                "saadparwaiz1/cmp_luasnip"
            },
            config = function()
                local lspkind = require("lspkind")

                local fn = vim.fn
                local replace_termcodes = vim.api.nvim_replace_termcodes

                local check_back_space = function()
                    local col = fn.col(".") - 1
                    return col == 0 or fn.getline(".").sub(col, col):match("%s")
                end

                local cmp = require("cmp")
                cmp.setup {
                    mapping = {
                        ["<C-p>"] = cmp.mapping.select_prev_item(),
                        ["<C-n>"] = cmp.mapping.select_next_item(),
                        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-e>"] = cmp.mapping.close(),
                        ["<CR>"] = cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true
                        },
                        ["<Tab>"] = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end,
                        ["<S-Tab>"] = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end
                    },
                    formatting = {
                        format = function(entry, vim_item)
                            vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
                            vim_item.menu =
                                ({
                                nvim_lsp = "[LSP]",
                                buffer = "[Buffer]",
                                luasnip = "[Snippet]",
                                path = "[Path]",
                            })[entry.source.name]
                            return vim_item
                        end,
                    },
                    sources = {
                        {name = "nvim_lsp"},
                        {name = "buffer"},
                        {name = "path"},
                        {name = "luasnip"},
                    },
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end
                    },
                }
            end
        }

        -- Formatting
        use {
            "lukas-reineke/format.nvim",
            config = function()
                vim.cmd(
                    [[
                augroup Format
                    autocmd!
                    autocmd BufWritePost * FormatWrite
                augroup END
                ]]
                )

                require("format").setup {
                    ["*"] = {
                        {cmd = {"sed -i 's/[ \t]*$//'"}} -- remove trailing whitespace
                    },
                    lua = {
                        cmd = {
                            function(file)
                                return string.format("luafmt -l %s -w replace %s", vim.bo.textwidth, file)
                            end
                        }
                    }
                }
            end
        }

        -- Web development
        use "mattn/emmet-vim"
        use "leafOfTree/vim-vue-plugin"

        -- Rust development
        use {
            "simrat39/rust-tools.nvim",
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "folke/which-key.nvim",
                "neovim/nvim-lspconfig",
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim"
            },
            config = function()
                local capabilities = lsp_get_capabilities()
                require("rust-tools").setup {
                    server = {
                        on_attach = function(client, buffernr)
                            lsp_setup_buffer_keymap(client, buffernr)
                        end,
                        capabilities = capabilities
                    }
                }
            end
        }
        use "mhinz/vim-crates"
    end
)
