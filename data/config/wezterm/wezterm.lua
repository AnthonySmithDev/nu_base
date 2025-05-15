local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'ayu'
local colors = wezterm.color.get_builtin_schemes()[config.color_scheme]
config.colors = colors

config.default_prog = { 'nu', '-l' }

config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"

-- config.enable_wayland = false
-- config.front_end = "WebGpu"
-- config.enable_kitty_graphics = true

-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.font_size = 11

config.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font',
  'JetBrains Mono',
  'Cascadia Code',
})

-- require('plugin')(config)
require('custom')(config)

return config
