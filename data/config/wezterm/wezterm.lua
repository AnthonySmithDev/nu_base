local wezterm = require 'wezterm'
local config = wezterm.config_builder()

require('base')(config)
require('plugin')(config)
require('custom')(config)

return config
