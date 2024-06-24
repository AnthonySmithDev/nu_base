source ../env.nu
source ../module/source.nu

def main [] {
  create_dir

  if (is_debian) {
    install apt core
    install apt python
    install apt docker
  }

  download node --latest
  download java --latest
  download rust --latest
  download golang --latest

  sudo echo "Sudo OK"

  download xh --global
  download gum --global
  download helix --global
  download nushell --global
  download starship --global
  download zoxide --global
  download zellij --global

  download rg --global
  download fd --global
  download fzf --global
  download gdu --global

  config mods
  config helix
  config nushell
  config zellij --theme

  nu_source
  touch ~/.env.nu
}

def create_dir [] {
  mkdir $env.USR_LOCAL_BIN
  mkdir $env.USR_LOCAL_LIB
  mkdir $env.USR_LOCAL_SOURCE
  mkdir $env.USR_LOCAL_SHARE
  mkdir $env.USR_LOCAL_SHARE_FONTS
  mkdir $env.USR_LOCAL_SHARE_DOWNLOAD

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
