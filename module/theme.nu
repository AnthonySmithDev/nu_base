
def helix_themes [theme: string] {
  ls -s ($env.HELIX_RUNTIME | path join themes) | get name | each {|e| $e | split row "." | first }
}

export def helix [theme: string@helix_themes] {
  let config = ($env.CONFIG_DIR_REPO | path join helix/config.toml)
  open -r $config | lines | update 0 $'theme = "($theme)"' | str join "\n" | save -f $config
  pkill -USR1 hx
}

def nushell_themes [] {
  [dark_theme light_theme]
}

export def nushell [theme: string@nushell_themes] {
  let config = ($env.CONFIG_DIR_REPO | path join nushell/config.nu)
  open -r $config | lines | update 867 $'$env.config.color_config = $($theme)' | str join "\n" | save -f $config
}

def zellij_themes [theme: string] {
  ls -s ~/.config/zellij/themes | get name | each {|e| $e | split row "." | first }
}

export def zellij [theme: string@zellij_themes] {
  let config = ($env.CONFIG_DIR_REPO | path join zellij/config.kdl)
  open -r $config | lines | update 281 $'theme "($theme)"' | str join "\n" | save -f $config
}

def alacritty_themes [] {
  ls -s ~/.config/alacritty/themes | get name | each {|e| $e | split row "." | first }
}

export def alacritty [theme: string@alacritty_themes] {
  let config = ($env.CONFIG_DIR_REPO | path join alacritty/alacritty.toml)
  open -r $config | lines | update 1 $'"~/.config/alacritty/themes/($theme).toml",' | str join "\n" | save -f $config
}

def regolith_themes [] {
  regolith-look list | lines
}

export def regolith [theme: string@regolith_themes] {
  regolith-look set $theme
}

export def dark [] {
  helix "ayu_dark"
  nushell "dark_theme"
  zellij "default"
  alacritty "ayu_dark"
  regolith "ayu-dark"
}

export def light [] {
  helix "gruvbox_light_soft"
  nushell "light_theme"
  zellij "everforest-light"
  alacritty "gruvbox_light"
  regolith "ayu"
}
