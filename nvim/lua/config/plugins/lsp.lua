return {
  {
    'neovim/nvim-lspconfig',
    version = '~2.4.0',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {}, version = '~2.0.0' },
      {
        'mason-org/mason-lspconfig.nvim',
        version = '~2.1.0',
        opts = { ensure_installed = { 'lua_ls' } },
      },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Setup global LSP options
      vim.lsp.config('*', {
        root_markers = { '.git' },
      })

      -- Setup lua lsp for neovim configuration
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim', 'require' },
            },
          },
        },
      })

      -- Add keybindings for lsp commands
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>wd', function()
            require('telescope.builtin').diagnostics {
              severity = vim.diagnostic.severity.ERROR, -- Optional: filter only errors
            }
          end, '[W]orkspace [D]iagnostics')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('<leader>e', vim.diagnostic.open_float, 'Open diagnostic')
          map('K', vim.lsp.buf.hover, 'hover')
        end,
      })
    end,
  },
}
