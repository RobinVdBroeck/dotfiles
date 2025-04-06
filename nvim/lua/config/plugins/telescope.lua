local function find_nearest_package_json()
  local path = vim.fn.expand '%:p:h' -- Start from the current file's directory
  while path do
    local package_path = path .. '/package.json'
    local stat = vim.loop.fs_stat(package_path) -- Check if package.json exists
    if stat then
      return path -- Return the directory containing package.json
    end
    local parent = vim.fn.fnamemodify(path, ':h') -- Move up one directory
    if parent == path then
      break -- Stop if we've reached the root directory
    end
    path = parent
  end
  return nil -- Fallback to nil if no package.json is found
end

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.8',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-lua/plenary.nvim',
    },
    cmd = 'Telescope',
    keys = {
      {
        '<leader>sf',
        ':Telescope find_files<CR>',
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sa',
        ':Telescope find_files follow=true no_ignore=true hidden=true<CR>',
        desc = '[S]earch [A]ll',
      },
      {
        '<leader>sb',
        ':Telescope buffers<CR>',
        desc = '[S]earch [B]uffers',
      },
      {
        '<leader>sr',
        ':Telescope oldfiles<CR>',
        desc = '[S]earch [R]ecent files',
      },
      {
        '<leader>sg',
        ':Telescope live_grep<CR>',
        desc = '[S]earch using [G]rep',
      },
      {
        '<leader>st',
        function()
          if vim.fn.expand '%' == '' then
            vim.notify('No file is currently open!', vim.log.levels.ERROR)
            return
          end

          local filename = vim.fn.expand '%:t' -- Get the current file name (e.g., "foobar.component.tsx")
          local base_name = filename:gsub('%.%w+$', '') -- Remove the file extension (e.g., "foobar.component")
          local file_ext = vim.fn.expand '%:e' -- Get the current file extension (e.g., "tsx")

          -- Determine test patterns based on the file extension
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

          -- Determine the search root
          local root = find_nearest_package_json() or vim.fn.getcwd() -- Fallback to CWD if no package.json is found

          -- Build the find_command with multiple --glob options
          local find_command = { 'rg', '--files' }
          for _, pattern in ipairs(test_patterns) do
            table.insert(find_command, '--glob')
            table.insert(find_command, pattern)
          end

          -- Use Telescope to find files matching any of the test patterns
          require('telescope.builtin').find_files {
            prompt_title = 'Find Test File',
            search_dirs = { root }, -- Optional: Restrict search to the current working directory
            find_command = find_command,
          }
        end,
        desc = '[S]earch for [t]ests',
      },
      {

        '<leader>S',
        ':Telescope<CR>',
        desc = 'Open telescope window',
      },
      {
        '<leader>h',
        function()
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          -- A: Added
          -- C: Copied
          -- M: Modified
          -- R: Renamed
          -- T: Changed in the type (e.g., regular file to symbolic link)
          -- U: Unmerged
          -- X: Unknown
          -- B: Broken pairing
          local list = vim.fn.systemlist 'git diff --name-only --diff-filter=ACMRTUXB --merge-base master'

          pickers
            .new({}, {
              prompt_title = 'Changed files from master',
              finder = finders.new_table { results = list },
              previewer = conf.file_previewer {},
              sorter = conf.generic_sorter {},
            })
            :find()
        end,
        desc = 'Quick File picker using git',
      },
    },
    config = function()
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
    end,
  },
}
