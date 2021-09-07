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
  ["buftabline.nvim"] = {
    config = { "\27LJ\1\2j\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\2\15tab_format\25 #{n}: #{b}#{f} #{i}\14auto_hide\2\nsetup\15buftabline\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/buftabline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/cmp-path"
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
  ["feline.nvim"] = {
    config = { "\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15statusline\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/feline.nvim"
  },
  ["format.nvim"] = {
    config = { "\27LJ\1\2a\0\1\5\0\6\0\b4\1\0\0007\1\1\1%\2\2\0004\3\3\0007\3\4\0037\3\5\3\16\4\0\0@\1\4\0\14textwidth\abo\bvim\31luafmt -l %s -w replace %s\vformat\vstringÉ\2\1\0\5\0\r\0\0234\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\b\0002\2\3\0003\3\a\0003\4\6\0:\4\1\3;\3\1\2:\2\t\0013\2\v\0002\3\3\0001\4\n\0;\4\1\3:\3\1\2:\2\f\1>\0\2\1G\0\1\0\blua\1\0\0\0\6*\1\0\0\1\0\0\1\2\0\0\24sed -i 's/[ \t]*$//'\nsetup\vformat\frequire¤\1                augroup Format\n                    autocmd!\n                    autocmd BufWritePost * FormatWrite\n                augroup END\n                \bcmd\bvim\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/format.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\1\0028\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\1\2†\1\0\0\4\1\6\2\24+\0\0\0007\0\0\0%\1\1\0>\0\2\2\21\0\0\0\b\0\1\0T\1\15€+\1\0\0007\1\2\1%\2\1\0>\1\2\0027\1\3\1\16\2\0\0\16\3\0\0>\1\3\2\16\2\1\0007\1\4\1%\3\5\0>\1\3\2T\2\3€)\1\1\0T\2\1€)\1\2\0H\1\2\0\1À\a%s\nmatch\bsub\fgetline\6.\bcol\2\0¸\1\0\1\a\3\5\1\"+\1\0\0007\1\0\1>\1\1\2\t\1\0\0T\1\v€+\1\0\0007\1\1\1+\2\1\0%\3\2\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\17€+\1\2\0>\1\1\2\15\0\1\0T\2\v€+\1\0\0007\1\1\1+\2\1\0%\3\4\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\2€\16\1\0\0>\1\1\1G\0\1\0\1À\2À\3À\n<Tab>\6n\n<C-n>\rfeedkeys\15pumvisible\2›\1\0\2\5\1\b\0\15+\2\0\0007\2\1\0027\2\2\0027\3\0\0016\2\3\2%\3\3\0007\4\0\1$\2\4\2:\2\0\0013\2\5\0007\3\6\0007\3\a\0036\2\3\2:\2\4\1H\1\2\0\0À\tname\vsource\1\0\3\tpath\v[Path]\rnvim_lsp\n[LSP]\vbuffer\r[Buffer]\tmenu\6 \fdefault\fpresets\tkindÎ\4\1\0\v\0'\0C4\0\0\0%\1\1\0>\0\2\0024\1\2\0007\1\3\0014\2\2\0007\2\4\0027\2\5\0021\3\6\0004\4\0\0%\5\a\0>\4\2\0027\5\b\0043\6\30\0003\a\v\0007\b\t\0047\b\n\b>\b\1\2:\b\f\a7\b\t\0047\b\r\b>\b\1\2:\b\14\a7\b\t\0047\b\15\b'\tüÿ>\b\2\2:\b\16\a7\b\t\0047\b\15\b'\t\4\0>\b\2\2:\b\17\a7\b\t\0047\b\18\b>\b\1\2:\b\19\a7\b\t\0047\b\20\b>\b\1\2:\b\21\a7\b\t\0047\b\22\b3\t\25\0007\n\23\0047\n\24\n:\n\26\t>\b\2\2:\b\27\a1\b\28\0:\b\29\a:\a\t\0063\a \0001\b\31\0:\b!\a:\a\"\0062\a\4\0003\b#\0;\b\1\a3\b$\0;\b\2\a3\b%\0;\b\3\a:\a&\6>\5\2\0010\0\0€G\0\1\0\fsources\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\15formatting\vformat\1\0\0\0\1\0\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\nsetup\bcmp\0\27nvim_replace_termcodes\bapi\afn\bvim\flspkind\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\0023\0\2\5\0\1\0\0054\2\0\0\16\3\0\0\16\4\1\0>\2\3\1G\0\1\0\28lsp_setup_buffer_keymapÎ\1\1\0\v\0\v\0\0214\0\0\0%\1\1\0>\0\2\0024\1\2\0004\2\3\0>\1\2\0023\2\4\0004\3\5\0\16\4\2\0>\3\2\4T\6\a€6\b\a\0007\b\6\b3\t\b\0001\n\a\0:\n\t\t:\1\n\t>\b\2\1A\6\3\3N\6÷G\0\1\0\17capabilities\14on_attach\1\0\0\0\nsetup\vipairs\1\3\0\0\14angularls\rtsserver\17cmp_nvim_lsp\25lsp_get_capabilities\14lspconfig\frequire\0" },
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
    config = { "\27LJ\1\0023\0\2\5\0\1\0\0054\2\0\0\16\3\0\0\16\4\1\0>\2\3\1G\0\1\0\28lsp_setup_buffer_keymap’\1\1\0\5\0\n\0\0144\0\0\0>\0\1\0024\1\1\0%\2\2\0>\1\2\0027\1\3\0013\2\b\0003\3\5\0001\4\4\0:\4\6\3:\0\a\3:\3\t\2>\1\2\1G\0\1\0\vserver\1\0\0\17capabilities\14on_attach\1\0\0\0\nsetup\15rust-tools\frequire\25lsp_get_capabilities\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/rust-tools.nvim"
  },
  ["telescope.nvim"] = {
    config = { '\27LJ\1\2(\0\0\2\1\1\0\5+\0\0\0007\0\0\0002\1\0\0>\0\2\1G\0\1\0\0À\15treesitterº\4\1\0\a\0\27\0"4\0\0\0%\1\1\0>\0\2\0024\1\0\0%\2\2\0>\1\2\0027\2\3\0013\3\5\0003\4\4\0:\4\6\0033\4\a\0:\4\b\0033\4\t\0003\5\n\0:\5\v\0043\5\f\0:\5\r\0043\5\14\0:\5\15\0043\5\16\0:\5\17\0043\5\18\0:\5\19\0043\5\20\0:\5\21\0043\5\23\0001\6\22\0;\6\1\5:\5\24\4:\4\25\0033\4\26\0>\2\3\0010\0\0€G\0\1\0\1\0\1\tmode\6n\14<leader>f\6s\1\3\0\0\0\fsymbols\0\6h\1\3\0\0\29:Telescope help_tags<CR>\thelp\6g\1\3\0\0\29:Telescope live_grep<CR>\tgrep\6r\1\3\0\0\28:Telescope oldfiles<CR>\17recent files\6b\1\3\0\0\27:Telescope buffers<CR>\fbuffers\afb\1\3\0\0 :Telescope file_browser<CR>\17file browser\6f\1\3\0\0\30:Telescope find_files<CR>\tfile\1\0\1\tname\tFind\n<C-b>\1\3\0\0\27:Telescope buffers<CR>\17find buffers\n<C-p>\1\0\0\1\3\0\0\30:Telescope find_files<CR>\15find files\rregister\14which-key\22telescope.builtin\frequire\0' },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-crates"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-crates"
  },
  ["vim-glsl"] = {
    config = { "\27LJ\1\2\2\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0á\1                    aug FtGlsl\n                        au!\n                        au BufNewFile,BufRead *.vs,*.fs,*.vert,*.tesc,*.tese,*.geom,*.frag,*.comp,*.glsl set ft=glsl\n                    aug end\n                \bcmd\bvim\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-glsl"
  },
  ["vim-vue-plugin"] = {
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/vim-vue-plugin"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/robin/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\0023\0\2\5\0\1\0\0054\2\0\0\16\3\0\0\16\4\1\0>\2\3\1G\0\1\0\28lsp_setup_buffer_keymapÎ\1\1\0\v\0\v\0\0214\0\0\0%\1\1\0>\0\2\0024\1\2\0004\2\3\0>\1\2\0023\2\4\0004\3\5\0\16\4\2\0>\3\2\4T\6\a€6\b\a\0007\b\6\b3\t\b\0001\n\a\0:\n\t\t:\1\n\t>\b\2\1A\6\3\3N\6÷G\0\1\0\17capabilities\14on_attach\1\0\0\0\nsetup\vipairs\1\3\0\0\14angularls\rtsserver\17cmp_nvim_lsp\25lsp_get_capabilities\14lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\1\2†\1\0\0\4\1\6\2\24+\0\0\0007\0\0\0%\1\1\0>\0\2\2\21\0\0\0\b\0\1\0T\1\15€+\1\0\0007\1\2\1%\2\1\0>\1\2\0027\1\3\1\16\2\0\0\16\3\0\0>\1\3\2\16\2\1\0007\1\4\1%\3\5\0>\1\3\2T\2\3€)\1\1\0T\2\1€)\1\2\0H\1\2\0\1À\a%s\nmatch\bsub\fgetline\6.\bcol\2\0¸\1\0\1\a\3\5\1\"+\1\0\0007\1\0\1>\1\1\2\t\1\0\0T\1\v€+\1\0\0007\1\1\1+\2\1\0%\3\2\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\17€+\1\2\0>\1\1\2\15\0\1\0T\2\v€+\1\0\0007\1\1\1+\2\1\0%\3\4\0)\4\2\0)\5\2\0)\6\2\0>\2\5\2%\3\3\0>\1\3\1T\1\2€\16\1\0\0>\1\1\1G\0\1\0\1À\2À\3À\n<Tab>\6n\n<C-n>\rfeedkeys\15pumvisible\2›\1\0\2\5\1\b\0\15+\2\0\0007\2\1\0027\2\2\0027\3\0\0016\2\3\2%\3\3\0007\4\0\1$\2\4\2:\2\0\0013\2\5\0007\3\6\0007\3\a\0036\2\3\2:\2\4\1H\1\2\0\0À\tname\vsource\1\0\3\tpath\v[Path]\rnvim_lsp\n[LSP]\vbuffer\r[Buffer]\tmenu\6 \fdefault\fpresets\tkindÎ\4\1\0\v\0'\0C4\0\0\0%\1\1\0>\0\2\0024\1\2\0007\1\3\0014\2\2\0007\2\4\0027\2\5\0021\3\6\0004\4\0\0%\5\a\0>\4\2\0027\5\b\0043\6\30\0003\a\v\0007\b\t\0047\b\n\b>\b\1\2:\b\f\a7\b\t\0047\b\r\b>\b\1\2:\b\14\a7\b\t\0047\b\15\b'\tüÿ>\b\2\2:\b\16\a7\b\t\0047\b\15\b'\t\4\0>\b\2\2:\b\17\a7\b\t\0047\b\18\b>\b\1\2:\b\19\a7\b\t\0047\b\20\b>\b\1\2:\b\21\a7\b\t\0047\b\22\b3\t\25\0007\n\23\0047\n\24\n:\n\26\t>\b\2\2:\b\27\a1\b\28\0:\b\29\a:\a\t\0063\a \0001\b\31\0:\b!\a:\a\"\0062\a\4\0003\b#\0;\b\1\a3\b$\0;\b\2\a3\b%\0;\b\3\a:\a&\6>\5\2\0010\0\0€G\0\1\0\fsources\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\15formatting\vformat\1\0\0\0\1\0\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\nsetup\bcmp\0\27nvim_replace_termcodes\bapi\afn\bvim\flspkind\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: format.nvim
time([[Config for format.nvim]], true)
try_loadstring("\27LJ\1\2a\0\1\5\0\6\0\b4\1\0\0007\1\1\1%\2\2\0004\3\3\0007\3\4\0037\3\5\3\16\4\0\0@\1\4\0\14textwidth\abo\bvim\31luafmt -l %s -w replace %s\vformat\vstringÉ\2\1\0\5\0\r\0\0234\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\b\0002\2\3\0003\3\a\0003\4\6\0:\4\1\3;\3\1\2:\2\t\0013\2\v\0002\3\3\0001\4\n\0;\4\1\3:\3\1\2:\2\f\1>\0\2\1G\0\1\0\blua\1\0\0\0\6*\1\0\0\1\0\0\1\2\0\0\24sed -i 's/[ \t]*$//'\nsetup\vformat\frequire¤\1                augroup Format\n                    autocmd!\n                    autocmd BufWritePost * FormatWrite\n                augroup END\n                \bcmd\bvim\0", "config", "format.nvim")
time([[Config for format.nvim]], false)
-- Config for: buftabline.nvim
time([[Config for buftabline.nvim]], true)
try_loadstring("\27LJ\1\2j\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\2\15tab_format\25 #{n}: #{b}#{f} #{i}\14auto_hide\2\nsetup\15buftabline\frequire\0", "config", "buftabline.nvim")
time([[Config for buftabline.nvim]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\1\0028\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2h\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\1\0023\0\2\5\0\1\0\0054\2\0\0\16\3\0\0\16\4\1\0>\2\3\1G\0\1\0\28lsp_setup_buffer_keymap’\1\1\0\5\0\n\0\0144\0\0\0>\0\1\0024\1\1\0%\2\2\0>\1\2\0027\1\3\0013\2\b\0003\3\5\0001\4\4\0:\4\6\3:\0\a\3:\3\t\2>\1\2\1G\0\1\0\vserver\1\0\0\17capabilities\14on_attach\1\0\0\0\nsetup\15rust-tools\frequire\25lsp_get_capabilities\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: feline.nvim
time([[Config for feline.nvim]], true)
try_loadstring("\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15statusline\frequire\0", "config", "feline.nvim")
time([[Config for feline.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring('\27LJ\1\2(\0\0\2\1\1\0\5+\0\0\0007\0\0\0002\1\0\0>\0\2\1G\0\1\0\0À\15treesitterº\4\1\0\a\0\27\0"4\0\0\0%\1\1\0>\0\2\0024\1\0\0%\2\2\0>\1\2\0027\2\3\0013\3\5\0003\4\4\0:\4\6\0033\4\a\0:\4\b\0033\4\t\0003\5\n\0:\5\v\0043\5\f\0:\5\r\0043\5\14\0:\5\15\0043\5\16\0:\5\17\0043\5\18\0:\5\19\0043\5\20\0:\5\21\0043\5\23\0001\6\22\0;\6\1\5:\5\24\4:\4\25\0033\4\26\0>\2\3\0010\0\0€G\0\1\0\1\0\1\tmode\6n\14<leader>f\6s\1\3\0\0\0\fsymbols\0\6h\1\3\0\0\29:Telescope help_tags<CR>\thelp\6g\1\3\0\0\29:Telescope live_grep<CR>\tgrep\6r\1\3\0\0\28:Telescope oldfiles<CR>\17recent files\6b\1\3\0\0\27:Telescope buffers<CR>\fbuffers\afb\1\3\0\0 :Telescope file_browser<CR>\17file browser\6f\1\3\0\0\30:Telescope find_files<CR>\tfile\1\0\1\tname\tFind\n<C-b>\1\3\0\0\27:Telescope buffers<CR>\17find buffers\n<C-p>\1\0\0\1\3\0\0\30:Telescope find_files<CR>\15find files\rregister\14which-key\22telescope.builtin\frequire\0', "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: vim-glsl
time([[Config for vim-glsl]], true)
try_loadstring("\27LJ\1\2\2\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0á\1                    aug FtGlsl\n                        au!\n                        au BufNewFile,BufRead *.vs,*.fs,*.vert,*.tesc,*.tese,*.geom,*.frag,*.comp,*.glsl set ft=glsl\n                    aug end\n                \bcmd\bvim\0", "config", "vim-glsl")
time([[Config for vim-glsl]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
