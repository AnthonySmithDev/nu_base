local wezterm = require 'wezterm'

return function(config)
  -- local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
  local modal = wezterm.plugin.require("https://github.com/AnthonySmithDev/modal.wezterm")
  modal.apply_to_config(config)

  if config.keys == nil then
      config.keys = {}
  end

  table.insert(config.keys, {
  	key = "s",
  	mods = "CTRL|SHIFT",
  	action = modal.activate_mode("Scroll"),
  })

  table.insert(config.keys, {
  	key = "u",
  	mods = "CTRL|SHIFT",
  	action = modal.activate_mode("UI"),
  })

  table.insert(config.keys, {
  	key = "c",
  	mods = "ALT",
  	action = modal.activate_mode("copy_mode"),
  })

  wezterm.on("modal.enter", function(name, window, pane)
    modal.set_right_status(window, name)
    modal.set_window_title(pane, name)
  end)

  wezterm.on("modal.exit", function(name, window, pane)
    window:set_right_status("NOT IN A MODE")
    modal.reset_window_title(pane)
  end)
end
