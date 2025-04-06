local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'catppuccin-mocha'

-- Setup leader key
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- pane management
  {
    mods = 'LEADER',
    key = '%',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    mods = 'LEADER',
    key = '=',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    mods = 'LEADER',
    key = 'z',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    mods = 'LEADER',
    key = 'Space',
    action = wezterm.action.RotatePanes 'Clockwise',
  },
  {
    mods = 'LEADER',
    key = 'c',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    mods = 'LEADER',
    key = 'x',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    mods = 'LEADER',
    key = 'n',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    mods = 'LEADER',
    key = 'p',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    mods = 'LEADER',
    key = 'l',
    action = wezterm.action.ActivateLastTab,
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    mods = 'LEADER',
    key = tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
