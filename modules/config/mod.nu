
export-env {
  $env.CONFIG_PATH = ($env.DATA_PATH | path join config)
}

def bind-user [
  src_name: string,
  dst_name?: string,
  --home,
  --dir,
] {
  let base_path = if $home { $env.HOME } else { ($env.HOME | path join ".config/") }
  let dst_name = ($dst_name | default $src_name)
  let dst_path = ($base_path | path join $dst_name)
  let dst_dir = ($dst_path | path dirname)

  if not ($dst_dir | path exists) {
    mkdir $dst_dir
  }

  if $dir {
    rm -rf $dst_path
  }

  let src_path = ($env.CONFIG_PATH | path join $src_name)
  ln -sf $src_path $dst_path

  print $"Config: ($dst_path)"
}

def bind-root [
  src_name: string,
  dst_name?: string,
  --home,
  --dir,
] {
  let base_path = if $home { "/root/" } else { "/root/.config/" }
  let dst_name = ($dst_name | default $src_name)
  let dst_path = ($base_path | path join $dst_name)
  let dst_dir = ($dst_path | path dirname)

  if not ($dst_dir | path exists) {
    sudo mkdir -p $dst_dir
  }

  if $dir {
    sudo rm -rf $dst_path
  }

  let src_path = ($env.CONFIG_PATH | path join $src_name)
  sudo ln -sf $src_path $dst_path

  print $"Config: ($dst_path)"
}

export def rain [] {
  bind-user --home rain/config.yaml
}

export def nushell [] {
  touch -c ($env.HOME | path join .source.nu)
  bind-user nushell/config.nu

  sudo touch -c ("/root" | path join .source.nu)
  bind-root nushell/config.nu
}

export def zellij [] {
  bind-user zellij/config.kdl
  bind-user --dir zellij/themes

  bind-root zellij/config.kdl
  bind-root --dir zellij/themes
}

export def mods [] {
  bind-user mods/mods.yml
}

export def vieb [] {
  bind-user Vieb/viebrc
}

export def vi-mongo [] {
  bind-user vi-mongo/config.yaml
}

export def rclone [] {
  bind-user rclone/rclone.conf
}

export def alacritty [] {
  bind-user alacritty/alacritty.toml
}

def ghostty-completions [] {
  [desktop laptop]
}

export def ghostty [completion: string@ghostty-completions] {
  bind-user $"ghostty/($completion)" ghostty/config
}

export def wezterm [] {
  bind-user wezterm/wezterm.lua
}

export def rio [] {
  bind-user rio/config.toml
}

export def foot [] {
  bind-user foot/foot.init
}

export def bat [] {
  bind-user bat/config
}

export def dooit [] {
  bind-user dooit/config.py
}

def mouseless-completions [] {
  [desktop laptop]
}

export def mouseless [completion: string@mouseless-completions] {
  bind-user $"mouseless/($completion).yaml" mouseless/config.yaml
}

def lan-mouse-completions [] {
  [desktop laptop]
}

export def lan-mouse [completion: string@lan-mouse-completions] {
  bind-user $"lan-mouse/($completion).toml" lan-mouse/config.toml
}

export def cosmic [] {
  bind-user --dir cosmic/ cosmic/
}

export def helix [] {
  bind-user helix/config.toml
  bind-user helix/languages.toml

  bind-root helix/config.toml
  bind-root helix/languages.toml

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
  bind-user yazi/init.lua
  bind-user yazi/yazi.toml
  bind-user yazi/theme.toml
  bind-user yazi/keymap.toml

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
