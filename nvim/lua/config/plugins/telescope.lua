local function find_nearest_package_json()
  local path = vim.fn.expand '%:p:h'
  while path do
    local package_path = path .. '/package.json'
    local stat = vim.loop.fs_stat(package_path)
    if stat then
      return path
    end
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      break
    end
    path = parent
  end
  return nil
end

local M = {}

function M.setup()
  require('telescope').setup {
    defaults = {
      path_display = { 'truncate' },
      layout_config = {
        prompt_position = 'bottom',
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
    extentions = { 'fzf', 'fidget' },
  }

  local map = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
  end

  map('<leader>sf', ':Telescope find_files<CR>', '[S]earch [F]iles')
  map('<leader>sa', ':Telescope find_files follow=true no_ignore=true hidden=true<CR>', '[S]earch [A]ll')
  map('<leader>sb', ':Telescope buffers<CR>', '[S]earch [B]uffers')
  map('<leader>sr', ':Telescope oldfiles<CR>', '[S]earch [R]ecent files')
  map('<leader>sg', ':Telescope live_grep<CR>', '[S]earch using [G]rep')
  map('<leader>S', ':Telescope<CR>', 'Open telescope window')

  map('<leader>st', function()
    if vim.fn.expand '%' == '' then
      vim.notify('No file is currently open!', vim.log.levels.ERROR)
      return
    end

    local filename = vim.fn.expand '%:t'
    local base_name = filename:gsub('%.%w+$', '')
    local file_ext = vim.fn.expand '%:e'

    local test_patterns
    if file_ext == 'ts' then
      test_patterns = {
        base_name .. '.test.ts',
        base_name .. '.spec.ts',
        base_name .. '.test.js',
        base_name .. '.spec.js',
      }
    elseif file_ext == 'tsx' then
      test_patterns = {
        base_name .. '.test.tsx',
        base_name .. '.spec.tsx',
        base_name .. '.test.jsx',
        base_name .. '.spec.jsx',
      }
    else
      test_patterns = {
        base_name .. '.test.' .. file_ext,
        base_name .. '.spec.' .. file_ext,
      }
    end

    local root = find_nearest_package_json() or vim.fn.getcwd()

    local find_command = { 'rg', '--files' }
    for _, pattern in ipairs(test_patterns) do
      table.insert(find_command, '--glob')
      table.insert(find_command, pattern)
    end

    require('telescope.builtin').find_files {
      prompt_title = 'Find Test File',
      search_dirs = { root },
      find_command = find_command,
    }
  end, '[S]earch for [t]ests')

  map('<leader>h', function()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local list = vim.fn.systemlist 'git diff --name-only --diff-filter=ACMRTUXB --merge-base master'

    pickers
      .new({}, {
        prompt_title = 'Changed files from master',
        finder = finders.new_table { results = list },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
  end, 'Quick File picker using git')
end

return M
