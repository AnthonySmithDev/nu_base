
export-env {
  $env.NU_BASE_PATH = ($env.HOME | path join nu/nu_base/)

  $env.DATA_PATH = ($env.NU_BASE_PATH | path join data/)
  $env.MODULES_PATH = ($env.NU_BASE_PATH | path join modules/)

  $env.CONFIG_PATH = ($env.DATA_PATH | path join config)
  $env.SYSTEMD_PATH = ($env.DATA_PATH | path join systemd)
  
  $env.GHUB_REPOSITORY_PATH = ($env.CONFIG_PATH | path join ghub/ghub.json)
  $env.GHUB_TEMP_PATH = ($env.HOME | path join temp/ghub)

  $env.PKG_BIN_SYS = "linux_x64"
  $env.PKG_TEMP_PATH = ($env.HOME | path join temp/pkg)

  $env.CONFIG_DIRS = [
    /home/anthony/nu/nu_base/data/config,
    /home/anthony/nu/nu_work/data/config
  ]
}

source ../builtin.nu
source ../env.nu

use config/
use ghub/
use pkg/

export def main [] {
  sudo echo "Sudo OK"

  setup_dir
  setup_nu

  if (exists-external apt) {
    try {
      pkg apt update
      pkg apt upgrade

      pkg apt nala
      pkg apt basic
      pkg apt docker
    }
  }

  if (exists-external pacman) {
    pkg pacman update

    pkg pacman ssh
    pkg pacman tools
    pkg pacman docker
    pkg pacman gnome
    pkg pacman qemu
  }

  pkg bin gum
  pkg bin mods
  pkg bin glow
  pkg bin crush
  pkg bin opencode

  pkg bin helix
  pkg bin nushell
  pkg bin starship
  pkg bin zoxide
  pkg bin zellij
  pkg bin yazi

  pkg bin fd
  pkg bin rg
  pkg bin rgr
  pkg bin bat
  pkg bin fzf

  pkg bin eza
  pkg bin gdu
  pkg bin ouch
  pkg bin gitu
  pkg bin jless
  pkg bin jnv
  pkg bin jqp
  pkg bin hexyl
  pkg bin bottom
  pkg bin lazygit
  pkg bin lazydocker
  pkg bin difftastic
  pkg bin carapace
  pkg bin mirrord

  pkg bin uv
  pkg bin pnpm

  pkg bin java
  pkg bin node
  pkg bin golang

  pkg sh rust

  config mods
  config opencode
  config nushell
  config helix
  config zellij
  config yazi

  setup_zoxide
}

export def setup_dir [] {
  mkdir $env.USR_LOCAL_BIN
  mkdir $env.USR_LOCAL_LIB
  mkdir $env.USR_LOCAL_SHARE
  mkdir $env.USR_LOCAL_SOURCE
  mkdir $env.USR_LOCAL_DOWN
  mkdir $env.USR_LOCAL_APK
  mkdir $env.USR_LOCAL_DEB
  mkdir $env.USR_LOCAL_FONT

  mkdir $env.USR_LOCAL_SHARE_BIN
  mkdir $env.USR_LOCAL_SHARE_LIB
  mkdir $env.USR_LOCAL_SHARE_BUILD
  mkdir $env.USR_LOCAL_SHARE_SCRIPT
  mkdir $env.USR_LOCAL_SHARE_APP_IMAGE

  mkdir $env.LOCAL_BIN
  mkdir $env.LOCAL_SHARE
  mkdir $env.LOCAL_SHARE_FONTS
  mkdir $env.LOCAL_SHARE_APPLICATIONS

  mkdir $env.PKG_TEMP_PATH

  mkdir $env.PNPM_HOME
}

const dirs = [
  ~/.local/nu_base
  ~/nu/nu_base
  ~/nu/nu_work
]

export def setup_nu [] {
  let dirs = $dirs
  | each {path expand}
  | where {path exists}

  let modules = ($dirs | each {|dir| $dir | path join modules})
  let configs = ($dirs | each {|dir| $dir | path join data/config})
  let sources = ($dirs | each {|dir| $"source ($dir)/mod.nu"})

  let lib_dirs = $"const NU_LIB_DIRS = ($modules)"
  let config_dirs = $"$env.CONFIG_DIRS = ($configs)"

  $lib_dirs
  | append $config_dirs
  | append $sources
  | save --force ~/.source.nu
}

export def setup_zoxide [] {
  $dirs
  | each {path expand}
  | where {path exists}
  | each { |dir| ^zoxide add $dir; "OK" }
}
