source ../env.nu
source ../module/source.nu

def main [
  --remote
  --clean
] {
  mkdir $env.USR_LOCAL_BIN
  mkdir $env.USR_LOCAL_LIB
  mkdir $env.USR_LOCAL_SHARE
  mkdir $env.USR_LOCAL_SHARE_FONTS
  mkdir $env.LOCAL_SHARE_FONTS

  if $remote {
    remote
  } else {
    local
  }

  if $clean {
    sudo rm /usr/bin/hx
    sudo rm /usr/bin/nu
    sudo rm /usr/bin/xh
    sudo rm /usr/bin/gum
    sudo rm /usr/bin/zellij
    sudo rm /usr/bin/zoxide
    sudo rm /usr/bin/starship
    sudo rm /usr/bin/alacritty

    sudo rm /usr/bin/editor
  }
}

def remote [] {
  download node --latest
  download rust --latest
  download golang --latest

  download xh
  download gum
  download helix
  download nushell
  download starship
  download zoxide
  download zellij

  config helix
  config zellij
  config nushell
}

def local [] {
  download node --latest
  download rust --latest
  download golang --latest

  # install pipx core
  # install npm core
  # install go dev

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

  config ssh
  config github
  config mods
  config helix
  config zellij
  config nushell
  config alacritty
  config regolith
  config input-remapper
  config ubuntu-software

  install apt core
  install apt python
  install apt docker
  install apt flathub
  install apt regolith
  install apt input-remapper

  nerd-font FiraCode
  compile alacritty
  helix background
  nu_source
}

def nu_source [] {
  mut source = []
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
