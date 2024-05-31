source ../env.nu
source ../module/source.nu

def main [
  --remote
  --clean
] {
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

def local_nu_base [] {
  if ("~/.local/nu_base" | path exists) {
    "source ~/.local/nu_base/source.nu" | save -f ~/.source.nu
  }
}

def remote [] {
  local_nu_base

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

  download rg
  download fd
  download gdu
  download fzf

  download bat
  download bottom
  download carapace

  config helix
  config zellij
  config nushell

  touch ~/.env.nu
  touch ~/.source.nu
}

def is_debian [] {
  (sys host | get name) in ["Ubuntu"]
}

def local [] {
  nu_source

  if (is_debian) {
    install apt core
    install apt docker
    install apt flathub
    install apt regolith --beta
    install apt input-remapper
    install apt python
    install apt brave
    install apt vieb
    # sudo apt --fix-broken install
  }

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

  download lsd
  download bat
  download mods
  download glow
  download soft
  download qrcp
  download jless
  download taskell
  download silicon
  download lazygit
  download lazydocker

  download task
  download usql
  download amber
  download delta
  download rclone
  download kubectl
  download ttyper
  download bottom
  download carapace
  download tailscale

  nerd-font FiraCode
  compile alacritty --default

  config mods
  config helix
  config zellij_themes
  config zellij
  config nushell
  config alacritty_themes
  config alacritty
  config regolith
  config input-remapper
  config ubuntu-software
  config github
  
  # helix background
}

def nu_source [] {
  touch ~/.source.nu
  touch ~/.env.nu

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

def install_dev [] {
  install go dev
  install npm dev
  install pipx dev
  install cargo dev
}
