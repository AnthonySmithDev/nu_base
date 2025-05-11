
export-env {
  $env.GITHUB_REPOSITORY = ($env.HOME | path join nu/nu_base/data/config/ghub/ghub.json)
  $env.TMP_PATH_FILE = ($env.HOME | path join tmp/file)
  $env.TMP_PATH_DIR = ($env.HOME | path join tmp/dir)
  $env.SYSTEMD_USER_DST = ($env.HOME | path join .config/systemd/user/)
  $env.SYSTEMD_ROOT_DST = ("/etc" | path join systemd/system/)
  $env.PKG_BIN_SYS = "linux_x64"
  $env.CONFIG_DIR_SRC = ($env.HOME | path join nu/nu_base/data/config/)
}

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

  pkg bin gum
  pkg bin mods
  pkg bin glow

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
  pkg bin gitu
  pkg bin jless
  pkg bin bottom
  pkg bin lazygit
  pkg bin lazydocker
  pkg bin difftastic
  pkg bin carapace

  pkg bin uv
  pkg bin pnpm

  pkg bin java
  pkg bin node
  pkg bin golang

  pkg sh rust

  config mods
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
  mkdir $env.USR_LOCAL_SHARE_APP_IMAGE

  mkdir $env.LOCAL_BIN
  mkdir $env.LOCAL_SHARE
  mkdir $env.LOCAL_SHARE_FONTS
  mkdir $env.LOCAL_SHARE_APPLICATIONS

  mkdir $env.SYSTEMD_USER_DST

  mkdir $env.TMP_PATH_DIR
  mkdir $env.TMP_PATH_FILE
}

const dirs = [
  ~/.local/nu_base
  ~/nu/nu_base
  ~/nu/nu_work
  ~/nu/nu_home
]

export def setup_nu [] {
  $dirs
  | each {path expand}
  | where {path exists}
  | each {|dir| $"source ($dir)/mod.nu"}
  | save --force ~/.source.nu

  touch ~/.env.nu
}

export def setup_zoxide [] {
  $dirs
  | each {path expand}
  | where {path exists}
  | each { |dir| ^zoxide add $dir; "OK" }
}
