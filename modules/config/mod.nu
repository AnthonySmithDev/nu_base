
export-env {
  $env.CONFIG_DIR_SRC = ($env.HOME | path join nu/nu_base/data/config/)
  $env.CONFIG_DIR_DST = ($env.HOME | path join .config/)
}

def config-src [path: string] {
  $env.CONFIG_DIR_SRC | path join $path
}

def config-dst [path: string] {
  $env.CONFIG_DIR_DST | path join $path
}

def home-dst [path: string] {
  $env.HOME | path join $path
}

def bind [
  src_path: string,
  dst_path?: string,
  --dir
  --home
] {
  let src = config-src $src_path
  let dst = if $home {
    home-dst ($dst_path | default $src_path)
  } else {
    config-dst ($dst_path | default $src_path)
  }

  let dirname = ($dst | path dirname)
  if not ($dirname | path exists) {
    mkdir $dirname
  }

  if $dir { rm -rf $dst }

  print $"Config: ($dst)"
  ln -sf $src $dst
}

export def rain [] {
  bind --home rain/config.yaml
}

export def nushell [] {
  touch -c ~/.source.nu
  bind nushell/config.nu
}

export def zellij [] {
  bind zellij/config.kdl
  bind --dir zellij/themes
}

export def mods [] {
  bind mods/mods.yml
}

export def vieb [] {
  bind Vieb/viebrc
}

export def vi-mongo [] {
  bind vi-mongo/config.yaml
}

export def rclone [] {
  bind rclone/rclone.conf
}

export def alacritty [] {
  bind alacritty/alacritty.toml
}

def ghostty-completions [] {
  [desktop laptop]
}

export def ghostty [completion: string@ghostty-completions] {
  bind $"ghostty/($completion)" ghostty/config
}

export def wezterm [] {
  bind wezterm/wezterm.lua
}

export def rio [] {
  bind rio/config.toml
}

export def foot [] {
  bind foot/foot.init
}

export def bat [] {
  bind bat/config
}

export def dooit [] {
  bind dooit/config.py
}

def mouseless-completions [] {
  [desktop laptop]
}

export def mouseless [completion: string@mouseless-completions] {
  bind $"mouseless/($completion).yaml" mouseless/config.yaml
}

def lan-mouse-completions [] {
  [desktop laptop]
}

export def lan-mouse [completion: string@lan-mouse-completions] {
  bind $"lan-mouse/($completion).toml" lan-mouse/config.toml
}

export def cosmic [] {
  bind --dir cosmic/ cosmic/
}

export def helix [] {
  bind helix/config.toml
  bind helix/languages.toml

  helix-theme
}

def helix-theme [] {
  let theme = ($env.HELIX_RUNTIME | path join themes/ayu_dark.toml)
  if ($theme | path exists) {
    sed -i '38s/"background"/""/' $theme
    sed -i '44s/"black"/""/' $theme
    sed -i '49s/"black"/""/' $theme
    sed -i '51s/"black"/""/' $theme
    sed -i '58s/"black"/""/' $theme
  }
}

export def yazi [] {
  bind yazi/init.lua
  bind yazi/yazi.toml
  bind yazi/theme.toml
  bind yazi/keymap.toml

  yazi-plugins
}

def yazi-plugins [] {
  try { ya pack -a kmlupreti/ayu-dark }
  try { ya pack -a grappas/wl-clipboard }
  try { ya pack -a yazi-rs/plugins:mount }
  try { ya pack -a yazi-rs/plugins:toggle-pane }
  try { ya pack -a yazi-rs/plugins:full-border }
  try { ya pack -a yazi-rs/plugins:smart-filter }
}

export def git [] {
  ^git config --global core.editor 'hx'
  ^git config --global init.defaultBranch 'main'
  ^git config --global user.name 'Anthony Smith'
  ^git config --global user.email 'anthonyasdeveloper@gmail.com'
}

export def qmk [] {
  ^qmk config user.bootloader=avrdude
  ^qmk config user.keyboard=lily58/r2g
  ^qmk config user.keymap=anthony_smith
}

export def core [] {
  nushell
  helix
  bat
  mods
  yazi
  zellij
  wezterm

  vieb
}
