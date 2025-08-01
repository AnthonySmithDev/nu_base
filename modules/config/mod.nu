
export-env {
  # $env.CONFIG_DIRS = []
}

def bind-user [
  src_name: string,
  dst_name?: string,
  --copy,
  --home,
  --local,
  --state,
  --dir,
] {
  let base_path = if $home {
    $env.HOME
  } else if $local {
    $env.HOME | path join .local/
  } else if $state {
    $env.HOME | path join .local/state/
  } else {
    $env.HOME | path join .config/
  }

  let dst_name = ($dst_name | default $src_name)
  let dst_path = ($base_path | path join $dst_name)
  let dst_dir = ($dst_path | path dirname)

  if not ($dst_dir | path exists) {
    mkdir $dst_dir
  }

  if $dir {
    rm -rf $dst_path
  }

  if ($env.CONFIG_DIRS? | is-empty) {
    return
  }

  for config_dir in $env.CONFIG_DIRS {
    let src_path = ($config_dir | path join $src_name)
    if not ($src_path | path exists) {
      continue
    }
    if $copy {
      rm -rf $dst_path
      cp -f $src_path $dst_path
    } else {
      ln -sf $src_path $dst_path
    }
    print $"Config: ($dst_path)"
  }
}

def bind-root [
  src_name: string,
  dst_name?: string,
  --copy,
  --home,
  --local,
  --state,
  --dir,
] {
  let base_path = if $home {
    "/root/"
  } else if $local {
    "/root/.local/"
  } else if $state {
    "/root/.local/state/"
  } else {
    "/root/.config/"
  }

  let dst_name = ($dst_name | default $src_name)
  let dst_path = ($base_path | path join $dst_name)
  let dst_dir = ($dst_path | path dirname)

  if not ($dst_dir | path exists) {
    sudo mkdir -p $dst_dir
  }

  if $dir {
    sudo rm -rf $dst_path
  }

  if ($env.CONFIG_DIRS? | is-empty) {
    return
  }

  for config_dir in $env.CONFIG_DIRS {
    let src_path = ($config_dir | path join $src_name)
    if not ($src_path | path exists) {
      continue
    }
    if $copy {
      sudo rm -rf $dst_path
      sudo cp -f $src_path $dst_path
    } else {
      sudo ln -sf $src_path $dst_path
    }
    print $"Config: ($dst_path)"
  }
}

export def rain [] {
  bind-user --copy --home rain/config.yaml
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
  bind-user vi-mongo/styles/ayu-dark.yaml
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

export def ghostty [completion: string@ghostty-completions = "desktop"] {
  bind-user $"ghostty/($completion)" ghostty/config
}

def kitty-completions [] {
  [desktop laptop]
}

export def kitty [completion: string@kitty-completions = "desktop"] {
  bind-user kitty/kitty.conf
  bind-user $"kitty/($completion).conf" kitty/custom.conf
  bind-user --dir kitty/themes
  ^kill -SIGUSR1 kitty
}

def wezterm-completions [] {
  [desktop laptop]
}

export def wezterm [completion: string@wezterm-completions = "desktop"] {
  bind-user $"wezterm/($completion).lua" wezterm/custom.lua

  bind-user wezterm/base.lua
  bind-user wezterm/plugin.lua
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

export def aichat [] {
  bind-user aichat/config.yaml
}

export def mpv [] {
  bind-user mpv/mpv.conf
  bind-user mpv/input.conf
}

export def opencommit [] {
  bind-user --home oco/opencommit .opencommit
  bind-user --home oco/opencommit_migrations .opencommit_migrations
}

export def git [] {
  bind-user --home git/gitconfig .gitconfig
}

def sway-completions [] {
  [desktop laptop]
}

export def sway [completion: string@sway-completions] {
  bind-user sway/config
  bind-user sway/definitions.d/theme.conf
  bind-user sway/definitions.d/input.conf
  bind-user sway/definitions.d/common.conf
  bind-user $"sway/config.d/($completion).conf" sway/config.d/output.conf
  bind-user sway/config.d/modes.conf
}

export def hyde-state [] {
  bind-user --state hyde/state/config hyde/config
  ^hyde-shell waybar -u
}

export def hyde-kitty [] {
  bind-user hyde/kitty/kitty.conf kitty/kitty.conf
  ^kill -SIGUSR1 kitty
}

def hyde-completions [] {
  [home, work, laptop]
}

export def hyde [completion: string@hyde-completions] {
  bind-user hyde/config.toml hyde/config.toml

  bind-user hyde/hypr/hypridle.conf hypr/hypridle.conf
  bind-user hyde/hypr/userprefs.conf hypr/userprefs.conf

  # bind-user $"hyde/hypr/($completion)/monitors.conf" hypr/monitors.conf

  bind-user --dir hyde/hypr/($completion) hypr/custom
}

def mouseless-completions [] {
  [desktop laptop]
}

export def mouseless [completion: string@mouseless-completions] {
  bind-user $"mouseless/($completion).yaml" mouseless/config.yaml
}

def lan-mouse-completions [] {
  [desktop micro laptop vanesa]
}

export def lan-mouse [completion: string@lan-mouse-completions] {
  bind-user $"lan-mouse/($completion).toml" lan-mouse/config.toml
}

def ssh-completions [] {
  [home work]
}

export def ssh [completion: string@ssh-completions] {
  bind-user --home ssh/($completion) .ssh/config
}

export def cosmic [] {
  bind-user --dir cosmic/ cosmic/
}

export def zed [] {
  bind-user zed/settings.json
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
  # try { ya pkg add grappas/wl-clipboard }
  try { ya pkg add kmlupreti/ayu-dark }
  try { ya pkg add yazi-rs/plugins:piper }
  try { ya pkg add yazi-rs/plugins:mount }
  try { ya pkg add yazi-rs/plugins:toggle-pane }
  try { ya pkg add yazi-rs/plugins:full-border }
  try { ya pkg add yazi-rs/plugins:smart-filter }
}

export def qmk [] {
  ^qmk config user.bootloader=avrdude
  ^qmk config user.keyboard=lily58/r2g
  ^qmk config user.keymap=anthony_smith
}

export def wallpapers [] {
  bind-user wallpapers
}

export def mimeapps [] {
  bind-user mimeapps.list
}

export def neovide [] {
  bind-user neovide/config.toml
}

export def opencode [] {
  bind-user opencode/config.json
}

export def qview [] {
  bind-user --copy qView/qView.conf
}

export def imv [] {
  bind-user imv/config
}

export def gitlab [] {
  glab config set -g -h $env.GITLAB_HOST token $env.GITLAB_TOKEN
  glab config set -g -h $env.GITLAB_HOST api_protocol http
  glab config set -g -h $env.GITLAB_HOST git_protocol ssh
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
