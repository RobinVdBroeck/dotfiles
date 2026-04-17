vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Build steps: replaces lazy.nvim's `build = ...` field.
-- Fires after vim.pack installs or updates the matching plugin.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.kind ~= 'install' and d.kind ~= 'update' then
      return
    end
    local name = d.spec.name
    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = d.path }):wait()
    end
  end,
})

local specs = {
  -- Colorscheme first so it's available before any UI is drawn
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin', version = 'v1.11.0' },

  -- Shared dependencies
  { src = 'https://github.com/nvim-lua/plenary.nvim', version = vim.version.range '^0.1.0' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- no semver tags
  { src = 'https://github.com/MunifTanjim/nui.nvim', version = vim.version.range '^0.4.0' },
  { src = 'https://github.com/nvim-neotest/nvim-nio', version = vim.version.range '^1.10.0' },
  { src = 'https://github.com/antoinemadec/FixCursorHold.nvim' }, -- no tags

  -- Treesitter (arborist auto-installs parsers on FileType; nvim-treesitter is deprecated)
  { src = 'https://github.com/arborist-ts/arborist.nvim', version = vim.version.range '^0.6.0' },

  -- Editor UX
  { src = 'https://github.com/folke/todo-comments.nvim', version = vim.version.range '^1.5.0' },
  { src = 'https://github.com/folke/which-key.nvim', version = vim.version.range '^3.17.0' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim', version = vim.version.range '^3.0.0' },

  -- Completion
  { src = 'https://github.com/zbirenbaum/copilot.lua', version = vim.version.range '^2.0.0' },
  { src = 'https://github.com/fang2hou/blink-copilot', version = vim.version.range '^1.4.0' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^1.10.0' },

  -- Formatting
  { src = 'https://github.com/stevearc/conform.nvim', version = vim.version.range '^9.0.0' },

  -- Git
  { src = 'https://github.com/tpope/vim-fugitive', version = vim.version.range '^3.7.0' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim', version = vim.version.range '^2.1.0' },

  -- LSP (mason first so servers are installed before lspconfig reads them)
  { src = 'https://github.com/mason-org/mason.nvim', version = vim.version.range '^2.1.0' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim', version = vim.version.range '^2.1.0' },
  { src = 'https://github.com/neovim/nvim-lspconfig', version = vim.version.range '^2.5.0' },

  -- File tree
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '^3.38.0' },

  -- Telescope (fzf-native first; telescope loads its extension lazily)
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' }, -- no tags
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range '^0.1.9' },

  -- Neotest (adapters before neotest so they resolve on setup)
  { src = 'https://github.com/adrigzr/neotest-mocha' }, -- no tags
  { src = 'https://github.com/marilari88/neotest-vitest', version = vim.version.range '^0.2.0' },
  { src = 'https://github.com/nvim-neotest/neotest', version = vim.version.range '^5.15.0' },

  -- C++ tooling
  { src = 'https://github.com/Civitasv/cmake-tools.nvim' }, -- no tags

  -- Statusline
  { src = 'https://github.com/nvim-lualine/lualine.nvim' }, -- tags are `compat-nvim-X.Y`, not semver
}

vim.pack.add(specs)

-- Apply colorscheme early to avoid a flash of default theme
vim.o.background = 'dark'
vim.cmd.colorscheme 'catppuccin'

-- :Pack user command — thin wrapper over vim.pack
--   :Pack update [names...]   confirm-then-apply updates (opens diff buffer)
--   :Pack sync   [names...]   apply updates without confirmation; when called
--                             without args, also uninstalls plugins no longer
--                             declared in `specs` above.
--   :Pack list                print installed plugins
--   :Pack del    <names...>   uninstall plugins
local function orphaned()
  local declared = {}
  for _, s in ipairs(specs) do
    declared[s.src] = true
  end
  local orphans = {}
  for _, entry in ipairs(vim.pack.get()) do
    if not declared[entry.spec.src] then
      table.insert(orphans, entry.spec.name)
    end
  end
  return orphans
end

local subcommands = {
  update = function(names)
    vim.pack.update(#names > 0 and names or nil)
  end,
  sync = function(names)
    vim.pack.update(#names > 0 and names or nil, { force = true })
    if #names == 0 then
      local orphans = orphaned()
      if #orphans > 0 then
        vim.pack.del(orphans)
        vim.notify('Removed orphaned plugins: ' .. table.concat(orphans, ', '))
      end
    end
  end,
  list = function()
    local function git(cwd, args)
      local res = vim.system(vim.list_extend({ 'git' }, args), { cwd = cwd, text = true }):wait()
      if res.code ~= 0 then
        return nil
      end
      return vim.trim(res.stdout or '')
    end

    -- Treat only tags that start with a digit (or `v<digit>`) as real releases.
    -- Excludes things like `nvim-0.6`, `compat-nvim-0.6`, `nerd-v2-compat`.
    local function is_release_tag(t)
      return t:match '^v?%d' ~= nil
    end

    local function current_version(path)
      -- Prefer a semver tag when HEAD has multiple (e.g. both `stable` and `v1.5.0`).
      local at_head = git(path, { 'tag', '--points-at', 'HEAD' })
      if at_head and at_head ~= '' then
        local tags = vim.split(at_head, '\n', { trimempty = true })
        local best_tag, best_ver
        for _, t in ipairs(tags) do
          if is_release_tag(t) then
            local parsed = vim.version.parse(t)
            if parsed and (not best_ver or vim.version.gt(parsed, best_ver)) then
              best_tag, best_ver = t, parsed
            end
          end
        end
        return best_tag or tags[1]
      end
      -- HEAD is not at any tag: describe against the nearest reachable tag.
      return git(path, { 'describe', '--tags', '--always', 'HEAD' }) or '?'
    end

    local function all_tags(path)
      local out = git(path, { 'tag' })
      if not out or out == '' then
        return {}
      end
      return vim.split(out, '\n', { trimempty = true })
    end

    local function max_semver(tags, filter)
      local best_tag, best_ver
      for _, t in ipairs(tags) do
        if is_release_tag(t) then
          local parsed = vim.version.parse(t)
          if parsed and (not filter or filter(parsed)) then
            if not best_ver or vim.version.gt(parsed, best_ver) then
              best_tag, best_ver = t, parsed
            end
          end
        end
      end
      return best_tag or '-'
    end

    local function range_repr(v)
      if v == nil then
        return 'latest'
      end
      if type(v) == 'string' then
        return v
      end
      local from = v.from and tostring(v.from) or '*'
      local to = v.to and tostring(v.to) or '*'
      return from .. '..' .. to
    end

    local function latest_in_range(v, tags)
      if v == nil then
        return '-'
      end
      if type(v) == 'string' then
        return v
      end
      return max_semver(tags, function(p)
        return v:has(p)
      end)
    end

    local rows = { { 'plugin', 'current', 'range', 'latest-in-range', 'latest' } }
    for _, entry in ipairs(vim.pack.get()) do
      local path = entry.path
      local tags = all_tags(path)
      table.insert(rows, {
        entry.spec.name,
        current_version(path),
        range_repr(entry.spec.version),
        latest_in_range(entry.spec.version, tags),
        max_semver(tags),
      })
    end

    local widths = { 0, 0, 0, 0, 0 }
    for _, row in ipairs(rows) do
      for i, cell in ipairs(row) do
        widths[i] = math.max(widths[i], vim.api.nvim_strwidth(cell))
      end
    end

    local function render(row)
      local parts = {}
      for i, cell in ipairs(row) do
        local pad = widths[i] - vim.api.nvim_strwidth(cell)
        parts[i] = cell .. string.rep(' ', pad)
      end
      return table.concat(parts, '  ')
    end

    local sep = {}
    for i, w in ipairs(widths) do
      sep[i] = string.rep('-', w)
    end
    local lines = { render(rows[1]), render(sep) }
    for i = 2, #rows do
      lines[#lines + 1] = render(rows[i])
    end

    vim.cmd 'new'
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Colorize each data row by freshness:
    --   green  — current is the latest release overall
    --   orange — outdated, but the latest is still within the pinned range
    --   red    — outdated and the latest is outside the pinned range (range blocks it)
    local hl = { ok = 'DiagnosticOk', warn = 'DiagnosticWarn', err = 'DiagnosticError' }
    local ns = vim.api.nvim_create_namespace 'pack-list'
    for i = 2, #rows do
      local _, current, _, in_range, latest = unpack(rows[i])
      local status
      if latest == '-' or current == latest then
        status = 'ok'
      elseif in_range == latest then
        status = 'warn'
      else
        status = 'err'
      end
      -- rows[i] maps to buffer line i (line 0 header, line 1 separator, data from line 2)
      local line_nr = i
      vim.api.nvim_buf_set_extmark(buf, ns, line_nr, 0, {
        end_row = line_nr,
        end_col = #lines[line_nr + 1],
        hl_group = hl[status],
        hl_eol = true,
      })
    end

    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_set_name(buf, 'pack-list')
  end,
  del = function(names)
    if #names == 0 then
      vim.notify(':Pack del requires at least one plugin name', vim.log.levels.ERROR)
      return
    end
    vim.pack.del(names)
  end,
}

vim.api.nvim_create_user_command('Pack', function(opts)
  local sub = opts.fargs[1]
  local action = subcommands[sub]
  if not action then
    vim.notify('Unknown :Pack subcommand: ' .. tostring(sub), vim.log.levels.ERROR)
    return
  end
  action(vim.list_slice(opts.fargs, 2))
end, {
  nargs = '+',
  complete = function(arglead, cmdline)
    local parts = vim.split(cmdline, '%s+', { trimempty = true })
    local at_subcommand = #parts <= 1 or (#parts == 2 and not cmdline:match '%s$')
    if at_subcommand then
      return vim.tbl_filter(function(s)
        return vim.startswith(s, arglead)
      end, vim.tbl_keys(subcommands))
    end
    local names = vim.tbl_map(function(p)
      return p.spec.name
    end, vim.pack.get())
    return vim.tbl_filter(function(s)
      return vim.startswith(s, arglead)
    end, names)
  end,
})

-- Run each plugin's setup
require('config.plugins.treesitter').setup()
require('config.plugins.comments').setup()
require('config.plugins.which-key').setup()
require('config.plugins.indent_line').setup()
require('config.plugins.completion').setup()
require('config.plugins.conform').setup()
require('config.plugins.git').setup()
require('config.plugins.lsp').setup()
require('config.plugins.neo_tree').setup()
require('config.plugins.telescope').setup()
require('config.plugins.test').setup()
require('config.plugins.cpp').setup()
require('config.plugins.ui').setup()
