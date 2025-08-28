-- WezTerm Configuration
-- Mimics iTerm2 behavior with CMD-D/CMD-SHIFT-D pane splitting and auto-clipboard

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Detect the operating system
local function is_macos()
  return wezterm.target_triple:find("darwin") ~= nil
end

local function is_linux()
  return wezterm.target_triple:find("linux") ~= nil
end

-- Use CMD (Super key) on all platforms for muscle memory consistency
local mod_key = 'CMD'

-- Font configuration
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 12.0

-- Color scheme - iTerm2 "Dark Background" preset
config.colors = {
  foreground = '#f0f0f0',
  background = '#000000',
  cursor_bg = '#f0f0f0',
  cursor_fg = '#000000',
  cursor_border = '#f0f0f0',
  selection_fg = '#000000',
  selection_bg = '#b5d5ff',
  scrollbar_thumb = '#333333',
  split = '#444444',

  ansi = {
    '#000000', -- black
    '#990000', -- red
    '#00a600', -- green
    '#999900', -- yellow
    '#0000b2', -- blue
    '#b200b2', -- magenta
    '#00a6b2', -- cyan
    '#bfbfbf', -- white
  },

  brights = {
    '#666666', -- bright black (gray)
    '#e50000', -- bright red
    '#00d900', -- bright green
    '#e5e500', -- bright yellow
    '#0000ff', -- bright blue
    '#e500e5', -- bright magenta
    '#00e5e5', -- bright cyan
    '#e5e5e5', -- bright white
  },
}

-- Window configuration
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0

-- Tab bar configuration
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false

-- Scrollback
config.scrollback_lines = 10000

-- Selection behavior - automatically copy to clipboard (like iTerm2)
config.selection_word_boundary = " \t\n{}[]()\"'`"

-- Key bindings - iTerm2 style pane splitting
config.keys = {
  -- Pane splitting (iTerm2 style)
  {
    key = 'd',
    mods = mod_key,
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = mod_key .. '|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Pane navigation
  {
    key = 'LeftArrow',
    mods = mod_key .. '|ALT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = mod_key .. '|ALT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = mod_key .. '|ALT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = mod_key .. '|ALT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },

  -- Pane resizing
  {
    key = 'LeftArrow',
    mods = mod_key .. '|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'RightArrow',
    mods = mod_key .. '|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'UpArrow',
    mods = mod_key .. '|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'DownArrow',
    mods = mod_key .. '|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },

  -- Close pane
  {
    key = 'w',
    mods = mod_key,
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- New tab
  {
    key = 't',
    mods = mod_key,
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },

  -- Close tab
  {
    key = 'w',
    mods = mod_key .. '|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },

  -- Tab navigation
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },

  -- Copy/Paste
  {
    key = 'c',
    mods = mod_key,
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = mod_key,
    action = wezterm.action.PasteFrom 'Clipboard',
  },

  -- Clear screen
  {
    key = 'k',
    mods = mod_key,
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },

  -- Find
  {
    key = 'f',
    mods = mod_key,
    action = wezterm.action.Search { CaseSensitiveString = '' },
  },
}

-- Mouse bindings for selection behavior
config.mouse_bindings = {
  -- Right click to paste from clipboard
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },

  -- Triple click to select line
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'Line',
  },
}

-- Automatically copy selection to clipboard (iTerm2 behavior)
wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'Configuration reloaded!', nil, 4000)
end)

-- Copy selection to clipboard automatically when selection is made
wezterm.on('copy-mode-update', function(window, pane)
  local selection = window:get_selection_text_for_pane(pane)
  if selection and selection ~= '' then
    wezterm.copy_to_clipboard(selection)
  end
end)

-- Bell configuration
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

-- Cursor configuration
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- Performance
config.max_fps = 60
config.animation_fps = 60

-- Window padding
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

return config
