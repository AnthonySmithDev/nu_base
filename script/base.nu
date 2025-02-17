source ../env.nu
source ../def.nu
source ../builtin.nu

use ../module/https.nu
use ../module/extract.nu
use ../module/config.nu
use ../module/ghub.nu
use ../module/root/
use ../module/pkg/

def main [] {
  setup_dir
  setup_nu

  if (exists-external apt) {
    try {
      pkg apt update
      pkg apt basic
      pkg apt docker
    }
  }

  pkg bin java
  pkg bin node --latest
  pkg bin golang --latest

  pkg sh rust --latest

  sudo echo "Sudo OK"

  pkg bin uv
  pkg bin pnpm

  pkg bin xh
  pkg bin helix
  pkg bin nushell
  pkg bin starship
  pkg bin zoxide
  pkg bin zellij
  pkg bin gum

  pkg bin rg
  pkg bin fd
  pkg bin fzf
  pkg bin gdu

  config mods
  config nushell
  config helix --theme
  config zellij --theme

  root config nushell
  root config helix
  root config zellij

  setup_zoxide
}

def setup_dir [] {
  mkdir $env.SCRIPT_DIR_DST

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

  mkdir $env.LOCAL_BIN
  mkdir $env.LOCAL_SHARE
  mkdir $env.LOCAL_SHARE_FONTS
  mkdir $env.LOCAL_SHARE_APPLICATIONS

  mkdir $env.CONFIG_SYSTEMD_USER_DST

  mkdir $env.TMP_PATH_DIR
  mkdir $env.TMP_PATH_FILE
}

def setup_nu [] {
  mut source = []
  if ("~/.local/nu_base" | path exists) {
    $source = ($source | append "source ~/.local/nu_base/mod.nu")
  }

  if ("~/nushell/nu_base" | path exists) {
    $source = ($source | append "source ~/nushell/nu_base/mod.nu")
  }
  if ("~/nushell/nu_work" | path exists) {
    $source = ($source | append "source ~/nushell/nu_work/mod.nu")
  }
  if ("~/nushell/nu_home" | path exists) {
    $source = ($source | append "source ~/nushell/nu_home/mod.nu")
  }
  $source | save -f ~/.source.nu
  touch ~/.env.nu
}

def setup_zoxide [] {
  if ("~/.local/nu_base" | path exists) {
    ^zoxide add ~/.local/nu_base
  }

  if ("~/nushell/nu_base" | path exists) {
    ^zoxide add ~/nushell/nu_base
  }
  if ("~/nushell/nu_work" | path exists) {
    ^zoxide add ~/nushell/nu_work
  }
  if ("~/nushell/nu_home" | path exists) {
    ^zoxide add ~/nushell/nu_home
  }
}
