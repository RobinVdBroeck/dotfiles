local function find_package_with_dep(dep)
  return function(file_path)
    local path = file_path
    if vim.fn.isdirectory(path) == 0 then
      path = vim.fn.fnamemodify(path, ':h')
    end
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(path) .. ' rev-parse --show-toplevel')[1]
    while path ~= '/' and #path >= #git_root do
      local pkg_file = path .. '/package.json'
      if vim.fn.filereadable(pkg_file) == 1 then
        local ok, json = pcall(vim.fn.json_decode, vim.fn.readfile(pkg_file))
        if ok and json then
          local deps = vim.tbl_extend('force', {}, json.dependencies or {}, json.devDependencies or {})
          if deps[dep] then
            return path
          end
        end
      end
      path = vim.fn.fnamemodify(path, ':h')
    end
  end
end

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'adrigzr/neotest-mocha',
      'marilari88/neotest-vitest',
    },
    keys = {
      {
        'tt',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test',
      },
      {
        'tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run current file',
      },
      {
        'td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
      {
        'ts',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop test',
      },
      {
        'ta',
        function()
          require('neotest').run.attach()
        end,
        desc = 'Attach to test',
      },
      {
        'tp',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Show test panel',
      },
      {
        'to',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Show output',
      },
    },
    config = function()
      -- Autoclose on pressing esc
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neotest-output-panel',
        callback = function()
          local close = function()
            require('neotest').output_panel.close()
          end
          vim.keymap.set('n', '<Esc>', close, { buffer = true })
          vim.keymap.set('n', 'q', close, { buffer = true })
        end,
      })

      require('neotest').setup {
        adapters = {
          require 'neotest-vitest' {
            cwd = find_package_with_dep 'vitest',
          },
          require 'neotest-mocha' {
            cwd = find_package_with_dep 'mocha',
          },
        },
        consumers = {
          progress = function(client)
            local handle
            local passed, failed, skipped = 0, 0, 0

            local function summary()
              local parts = {}
              if passed > 0 then
                table.insert(parts, passed .. ' passed')
              end
              if failed > 0 then
                table.insert(parts, failed .. ' failed')
              end
              if skipped > 0 then
                table.insert(parts, skipped .. ' skipped')
              end
              return #parts > 0 and table.concat(parts, ', ') or 'waiting...'
            end

            client.listeners.run = function()
              if handle then
                handle:cancel()
              end
              passed, failed, skipped = 0, 0, 0
              handle = require('fidget.progress').handle.create {
                title = 'Running',
                message = 'waiting...',
                lsp_client = { name = 'neotest' },
              }
            end
            client.listeners.results = function(_, results, partial)
              for _, result in pairs(results) do
                if result.status == 'passed' then
                  passed = passed + 1
                elseif result.status == 'failed' then
                  failed = failed + 1
                elseif result.status == 'skipped' then
                  skipped = skipped + 1
                end
              end
              if handle then
                handle.message = summary()
                if not partial then
                  handle:finish()
                  handle = nil
                  require('neotest').output_panel.open()
                end
              end
            end
          end,
        },
      }
    end,
  },
}
