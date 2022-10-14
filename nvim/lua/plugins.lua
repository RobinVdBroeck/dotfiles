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
    default_options = {silent = true}
    final_options = default_options
    for k, v in pairs(options) do final_options[k] = v end
    vim.keymap.set(mode, lhs, rhs, final_options)
end

lsp_on_attach = function(client, bufnr)
    local buf = vim.lsp.buf

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.onmifunc')

    -- keymap_set but with buffer option
    local function keymap_set2(mode, lhs, rhs, options)
        options["buffer"] = bufnr
        keymap_set(mode, lhs, rhs, options)
    end

    keymap_set2("n", "gd", buf.definition, {desc = "definition"})
    keymap_set2("n", "gD", buf.declaration, {desc = "declaration"})
    keymap_set2("n", "gi", buf.implementation, {desc = "implementation"})
    keymap_set2("n", "gr", buf.references, {desc = "references"})
    keymap_set2("n", "K", buf.hover, {desc = "hover"})
    keymap_set2("n", "<C-k>", buf.signature_help, {desc = "signature help"})
    keymap_set2("n", "<leader>D", buf.type_definition,
                {desc = "type definition"})
    keymap_set2("n", "<leader>ca", buf.code_action, {desc = "code action"})
    keymap_set2("n", "<leader>cn", buf.rename, {desc = "change name"})
    -- keymap_set2("n", "<leader>wa", buf.add_workspace_folder,
    --             {desc = "add workspace folder"})
    -- keymap_set2("n", "<leader>wr", buf.remove_workspace_folder,
    --             {desc = "remove workspace folder"})
    keymap_set2("n", "<leader>wl", function()
        print(vim.inspect(buf.list_workspace_folders()))
    end, {desc = "list workspace folders"})
    keymap_set2("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>",
                {desc = "find workspace symbols"})
end

lsp_get_capabilities = function(cmp_nvim_lsp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if (cmp_nvim_lsp_present == false) then
        print("Cannot find cmp_nvim_lsp")
        return capabilities
    end

    return cmp_nvim_lsp.update_capabilities(capabilities)
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

    -- -- LSP
    use {
        "neovim/nvim-lspconfig",
        requires = {"hrsh7th/cmp-nvim-lsp"},
        tag = "v0.1.3",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = lsp_get_capabilities(cmp_nvim_lsp)

            -- Rust is handled in rust-tools
            local servers = {
                "tsserver", "eslint", "pyright", "hls", "clangd", "serve_d",
                "rust-analyzer", "gopls"
            }
            local lsp_flags = {debounce_text_changes = 50}
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    on_attach = function(client, buffernr)
                        lsp_on_attach(client, buffernr)
                    end,
                    capabilities = capabilities,
                    flags = lsp_flags
                }
            end
        end
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path",
            "l3mon4d3/luasnip", "onsails/lspkind-nvim",
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
                formatting = {format = lspkind.cmp_format({mode = 'symbol'})},
                sources = {
                    {name = "nvim_lsp"}, {name = "buffer"}, {name = "path"},
                    {name = "luasnip"}
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                }
            }
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
