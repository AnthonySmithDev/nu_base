source ../env.nu
source ../module/source.nu

def main [] {

  if (is_debian) {
    install apt regolith --beta
    install apt flathub
    install apt brave
    install apt vieb
  }

  nerd-font FiraCode

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

  download melt
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

  compile alacritty --default

  config git
  config regolith
  config alacritty --theme
}

def dev [] {
  install go dev
  install npm dev
  install pipx dev
  install cargo dev
}

def extra [] {
  download gitlab
  config gitlab

  download mouseless --global
  config mouseless normal
  startup mouseless
}
