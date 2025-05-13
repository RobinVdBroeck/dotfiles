local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'catppuccin-mocha'

-- Leader key: CTRL-a
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Split panes (vim style: s = horizontal split, v = vertical split)
  {
    mods = 'LEADER',
    key = 's',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    mods = 'LEADER',
    key = 'v',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Pane navigation (vim style: h/j/k/l)
  {
    mods = 'LEADER',
    key = 'h',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    mods = 'LEADER',
    key = 'j',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    mods = 'LEADER',
    key = 'k',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    mods = 'LEADER',
    key = 'l',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },

  -- Zoom current pane
  {
    mods = 'LEADER',
    key = 'z',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- Rotate panes
  {
    mods = 'LEADER',
    key = 'Space',
    action = wezterm.action.RotatePanes 'Clockwise',
  },

  -- Tab management
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
    key = 't',
    action = wezterm.action.ActivateLastTab,
  },
}

-- Bind numbers 1-9 to tab activation
for i = 1, 9 do
  table.insert(config.keys, {
    mods = 'LEADER',
    key = tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
