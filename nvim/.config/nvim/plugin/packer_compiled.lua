-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/robin/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/robin/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/robin/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/robin/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/robin/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  dracula = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/dracula"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/editorconfig-vim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/emmet-vim"
  },
  ["format.nvim"] = {
    config = { "\27LJ\1\2a\0\1\5\0\6\0\b4\1\0\0007\1\1\1%\2\2\0004\3\3\0007\3\4\0037\3\5\3\16\4\0\0@\1\4\0\14textwidth\abo\bvim\31luafmt -l %s -w replace %s\vformat\vstringÉ\2\1\0\5\0\r\0\0234\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\b\0002\2\3\0003\3\a\0003\4\6\0:\4\1\3;\3\1\2:\2\t\0013\2\v\0002\3\3\0001\4\n\0;\4\1\3:\3\1\2:\2\f\1>\0\2\1G\0\1\0\blua\1\0\0\0\6*\1\0\0\1\0\0\1\2\0\0\24sed -i 's/[ \t]*$//'\nsetup\vformat\frequire¤\1                augroup Format\n                    autocmd!\n                    autocmd BufWritePost * FormatWrite\n                augroup END\n                \bcmd\bvim\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/format.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\1\2†\1\0\0\4\1\6\2\24+\0\0\0007\0\0\0%\1\1\0>\0\2\2\21\0\0\0\b\0\1\0T\1\15€+\1\0\0007\1\2\1%\2\1\0>\1\2\0027\1\3\1\16\2\0\0\16\3\0\0>\1\3\2\16\2\1\0007\1\4\1%\3\5\0>\1\3\2T\2\3€)\1\1\0T\2\1€)\1\2\0H\1\2\0\0À\a%s\nmatch\bsub\fgetline\6.\bcol\2\0¸\1\0\1\a\3\5\1\"+\1\0\0007\1\0\1>\1\1\2\t\1\0\0T\1\v€+\1\0\0007\1\1\1+\2\1\0%\3\2\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\17€+\1\2\0>\1\1\2\15\0\1\0T\2\v€+\1\0\0007\1\1\1+\2\1\0%\3\4\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\2€\16\1\0\0>\1\1\1G\0\1\0\0À\1À\2À\n<Tab>\6n\n<C-n>\rfeedkeys\15pumvisible\2®\4\1\0\n\0$\0>4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\4\0004\1\0\0007\1\5\0017\1\6\0011\2\a\0004\3\b\0%\4\t\0>\3\2\0027\4\n\0033\5 \0003\6\r\0007\a\v\0037\a\f\a>\a\1\2:\a\14\0067\a\v\0037\a\15\a>\a\1\2:\a\16\0067\a\v\0037\a\17\a'\büÿ>\a\2\2:\a\18\0067\a\v\0037\a\17\a'\b\4\0>\a\2\2:\a\19\0067\a\v\0037\a\20\a>\a\1\2:\a\21\0067\a\v\0037\a\22\a>\a\1\2:\a\23\0067\a\v\0037\a\24\a3\b\27\0007\t\25\0037\t\26\t:\t\28\b>\a\2\2:\a\29\0061\a\30\0:\a\31\6:\6\v\0052\6\3\0003\a!\0;\a\1\0063\a\"\0;\a\2\6:\6#\5>\4\2\0010\0\0€G\0\1\0\fsources\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\1\0\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\nsetup\bcmp\frequire\0\27nvim_replace_termcodes\bapi\afn\21menuone,noselect\16completeopt\6o\bvim\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2h\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["nvim-whichkey-setup.lua"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-whichkey-setup.lua"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\1\2<\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\15rust-tools\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/rust-tools.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-airline"
  },
  ["vim-vue-plugin"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-vue-plugin"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-which-key"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2h\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\1\2†\1\0\0\4\1\6\2\24+\0\0\0007\0\0\0%\1\1\0>\0\2\2\21\0\0\0\b\0\1\0T\1\15€+\1\0\0007\1\2\1%\2\1\0>\1\2\0027\1\3\1\16\2\0\0\16\3\0\0>\1\3\2\16\2\1\0007\1\4\1%\3\5\0>\1\3\2T\2\3€)\1\1\0T\2\1€)\1\2\0H\1\2\0\0À\a%s\nmatch\bsub\fgetline\6.\bcol\2\0¸\1\0\1\a\3\5\1\"+\1\0\0007\1\0\1>\1\1\2\t\1\0\0T\1\v€+\1\0\0007\1\1\1+\2\1\0%\3\2\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\17€+\1\2\0>\1\1\2\15\0\1\0T\2\v€+\1\0\0007\1\1\1+\2\1\0%\3\4\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\2€\16\1\0\0>\1\1\1G\0\1\0\0À\1À\2À\n<Tab>\6n\n<C-n>\rfeedkeys\15pumvisible\2®\4\1\0\n\0$\0>4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\4\0004\1\0\0007\1\5\0017\1\6\0011\2\a\0004\3\b\0%\4\t\0>\3\2\0027\4\n\0033\5 \0003\6\r\0007\a\v\0037\a\f\a>\a\1\2:\a\14\0067\a\v\0037\a\15\a>\a\1\2:\a\16\0067\a\v\0037\a\17\a'\büÿ>\a\2\2:\a\18\0067\a\v\0037\a\17\a'\b\4\0>\a\2\2:\a\19\0067\a\v\0037\a\20\a>\a\1\2:\a\21\0067\a\v\0037\a\22\a>\a\1\2:\a\23\0067\a\v\0037\a\24\a3\b\27\0007\t\25\0037\t\26\t:\t\28\b>\a\2\2:\a\29\0061\a\30\0:\a\31\6:\6\v\0052\6\3\0003\a!\0;\a\1\0063\a\"\0;\a\2\6:\6#\5>\4\2\0010\0\0€G\0\1\0\fsources\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\1\0\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\nsetup\bcmp\frequire\0\27nvim_replace_termcodes\bapi\afn\21menuone,noselect\16completeopt\6o\bvim\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\1\2<\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\15rust-tools\frequire\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: format.nvim
time([[Config for format.nvim]], true)
try_loadstring("\27LJ\1\2a\0\1\5\0\6\0\b4\1\0\0007\1\1\1%\2\2\0004\3\3\0007\3\4\0037\3\5\3\16\4\0\0@\1\4\0\14textwidth\abo\bvim\31luafmt -l %s -w replace %s\vformat\vstringÉ\2\1\0\5\0\r\0\0234\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\b\0002\2\3\0003\3\a\0003\4\6\0:\4\1\3;\3\1\2:\2\t\0013\2\v\0002\3\3\0001\4\n\0;\4\1\3:\3\1\2:\2\f\1>\0\2\1G\0\1\0\blua\1\0\0\0\6*\1\0\0\1\0\0\1\2\0\0\24sed -i 's/[ \t]*$//'\nsetup\vformat\frequire¤\1                augroup Format\n                    autocmd!\n                    autocmd BufWritePost * FormatWrite\n                augroup END\n                \bcmd\bvim\0", "config", "format.nvim")
time([[Config for format.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
