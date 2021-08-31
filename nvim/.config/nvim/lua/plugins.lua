-- Bootstrap if packer does not yet exist
-- From: https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd "packadd packer.nvim"
end

vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

lsp_setup_buffer_keymap = function(wk)
    return function(_client, bufnr)
        print("setting up mapping")
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
end

lsp_get_capabilities = function(cmp_nvim_lsp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    return cmp_nvim_lsp.update_capabilities(capabilities)
end

return require("packer").startup(
    function()
        -- Let packer manage itself, so it can update.
        use "wbthomason/packer.nvim"

        -- General use "editorconfig/editorconfig-vim"

        -- UI
        use {"dracula/vim", as = "dracula"}
        use {
            "ojroques/nvim-hardline",
            config = function()
                require("hardline").setup {}
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
            requires = "nvim-lua/plenary.nvim",
            config = function()
            end
        }

        -- Syntax highlighting
        use {
            "nvim-treesitter/nvim-treesitter",
            run = function()
                vim.cmd ":TSUpdate"
            end,
            config = function()
                require("nvim-treesitter.configs").setup {
                    ensure_installed = "maintained"
                }
            end
        }

        -- LSP
        use {
            "neovim/nvim-lspconfig",
            config = function()
                -- TODO: add more servers
                -- rust is handled in rust-tools
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
                "onsails/lspkind-nvim"
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
                            if fn.pumvisible() == 1 then
                                fn.feedkeys(replace_termcodes("<C-n>", true, true, true), "n")
                            elseif check_back_space() then
                                fn.feedkeys(replace_termcodes("<Tab>", true, true, true), "n")
                            else
                                fallback()
                            end
                        end
                    },
                    format = function(entry, vim_item)
                        vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
                        vim_item.menu =
                            ({
                            nvim_lsp = "[LSP]",
                            buffer = "[Buffer]"
                        })[entry.source.name]
                        return vim_item
                    end,
                    sources = {
                        {name = "nvim_lsp"},
                        {name = "buffer"}
                    }
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
                local cmp_nvim_lsp = require("cmp_nvim_lsp")
                local capabilities = lsp_get_capabilities(cmp_nvim_lsp)
                require("rust-tools").setup {
                    server = {
                        on_attach = function(client, buffernr)
                            local wk = require("which-key")
                            lsp_setup_buffer_keymap(wk)(client, buffernr)
                        end,
                        capabilities = capabilities
                    }
                }
            end
        }
    end
)
