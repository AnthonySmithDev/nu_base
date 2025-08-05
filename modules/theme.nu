
export-env {
  $env.CONFIG_PATH = ($env.NU_BASE_PATH | path join data/config/)
}

def helix_themes [theme: string] {
  ls -s ($env.HELIX_RUNTIME | path join themes) | get name | each {|e| $e | split row "." | first }
}

export def helix [theme: string@helix_themes] {
  let config = ($env.CONFIG_PATH | path join helix/config.toml)
  open -r $config | lines | update 0 $'theme = "($theme)"' | str join "\n" | save -f $config
  if (ps | where name =~ hx | is-not-empty) {
    pkill -USR1 hx
  }
}

def nushell_themes [] {
  [dark_theme light_theme]
}

export def nushell [theme: string@nushell_themes] {
  let config = ($env.CONFIG_PATH | path join nushell/config.nu)
  open -r $config | lines | update 867 $'$env.config.color_config = $($theme)' | str join "\n" | save -f $config
}

def dir_zellij_themes [theme: string] {
  ls -s ~/.config/zellij/themes | get name | each {|e| $e | split row "." | first }
}

def zellij_themes [theme: string] {
  [
    catppuccin-latte
    catppuccin-frappe
    catppuccin-macchiato
    catppuccin-mocha
    cyber-noir
    blade-runner
    retro-wave
    dracula
    everforest-dark
    everforest-light
    gruvbox-light
    gruvbox-dark
    kanagawa
    menace
    molokai-dark
    dayfox
    nightfox
    terafox
    nord
    one-half-dark
    pencil-light
    solarized-dark
    solarized-light
    tokyo-night
    tokyo-night-dark
    tokyo-night-light
    tokyo-night-storm
  ]
}

export def zellij [theme: string@zellij_themes] {
  let config = ($env.CONFIG_PATH | path join zellij/config.kdl)
  open -r $config | lines | update 281 $'theme "($theme)"' | str join "\n" | save -f $config
}

def alacritty_themes [] {
  ls -s ~/.config/alacritty/themes | get name | each {|e| $e | split row "." | first }
}

export def alacritty [theme: string@alacritty_themes] {
  let config = ($env.CONFIG_PATH | path join alacritty/alacritty.toml)
  open -r $config | lines | update 1 $'"~/.config/alacritty/themes/($theme).toml",' | str join "\n" | save -f $config
}

def regolith_themes [] {
  regolith-look list | lines
}

export def regolith [theme: string@regolith_themes] {
  regolith-look set $theme
}

def bat_themes [] {
  ^bat --list-themes | lines | prepend "default"
}

export def bat [theme: string@bat_themes] {
  let config = ($env.CONFIG_PATH | path join bat/config)
  open -r $config | lines | update 6 $'--theme="($theme)"' | str join "\n" | save -f $config
}

export def dark [] {
  helix "ayu_dark"
  nushell "dark_theme"
  zellij "default"
  alacritty "ayu_dark"
  regolith "ayu-dark"
  bat "default"
}

export def light [] {
  helix "gruvbox_light_soft"
  nushell "light_theme"
  zellij "everforest-dark"
  alacritty "gruvbox_light"
  regolith "ayu"
  bat "gruvbox-light"
}
