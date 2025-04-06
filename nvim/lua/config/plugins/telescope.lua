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
        '<leader>ff',
        ':Telescope find_files<CR>',
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>fa',
        ':Telescope find_files follow=true no_ignore=true hidden=true<CR>',
        desc = '[F]ind [A]ll',
      },
      {
        '<leader>fb',
        ':Telescope buffers<CR>',
        desc = '[F]ind [B]uffers',
      },
      {
        '<leader>fr',
        ':Telescope oldfiles<CR>',
        desc = '[F]ind [R]ecent files',
      },
      {
        '<leader>fg',
        ':Telescope live_grep<CR>',
        desc = '[F]ind using [G]rep',
      },
      {
        '<leader>F',
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
        extentions = { 'fzf' },
      }
    end,
  },
}
