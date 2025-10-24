local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.font_size = 12
config.font = wezterm.font 'Ubuntu Sans Mono'
config.keys = {
	{ key = 'k', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackAndViewport'}
}

return config
