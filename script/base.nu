source ../env.nu
source ../def.nu
source ../builtin.nu
source ../module/source.nu

def main [] {
  create_dir

  nu_source
  touch ~/.env.nu

  if (exists-external apt) {
    pkg apt update
    pkg apt basic
    pkg apt docker
  }

  pkg bin java
  pkg bin node --latest
  pkg bin rust --latest
  pkg bin golang --latest

  pkg bin uv
  pkg bin pnpm

  sudo echo "Sudo OK"

  pkg bin xh
  pkg bin gum
  pkg bin helix
  pkg bin nushell
  pkg bin starship
  pkg bin zoxide
  pkg bin zellij

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

  nu_zoxide
}

def create_dir [] {
  mkdir $env.USR_LOCAL_BIN
  mkdir $env.USR_LOCAL_LIB
  mkdir $env.USR_LOCAL_SOURCE
  mkdir $env.USR_LOCAL_APK
  mkdir $env.USR_LOCAL_SHARE
  mkdir $env.USR_LOCAL_SHARE_FONTS
  mkdir $env.USR_LOCAL_SHARE_DOWNLOAD
  mkdir $env.SCRIPT_DIR_DST

  mkdir $env.LOCAL_BIN
  mkdir $env.LOCAL_SHARE
  mkdir $env.LOCAL_SHARE_FONTS
  mkdir $env.LOCAL_SHARE_APPLICATIONS

  mkdir $env.CONFIG_SYSTEMD_USER_DST
}

def nu_source [] {
  mut source = []
  if ("~/.local/nu_base" | path exists) {
    $source = ($source | append "source ~/.local/nu_base/source.nu")
  }

  if ("~/nushell/nu_base" | path exists) {
    $source = ($source | append "source ~/nushell/nu_base/source.nu")
  }
  if ("~/nushell/nu_work" | path exists) {
    $source = ($source | append "source ~/nushell/nu_work/source.nu")
  }
  if ("~/nushell/nu_home" | path exists) {
    $source = ($source | append "source ~/nushell/nu_home/source.nu")
  }
  $source | save -f ~/.source.nu
}

def nu_zoxide [] {
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
