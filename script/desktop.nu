source ../env.nu
source ../def.nu
source ../module/source.nu

def main [] {

  nerd-font FiraCode

  if (external exists apt) {
    install apt flathub
    install apt brave
    install apt vieb
    install apt discord
  }

  # if (confirm Install Regolith:) {
  #   install apt regolith --beta
  #   config regolith
  # }

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
  download pueue
  download ttyper
  download bottom
  download rclone
  download carapace
  download difftastic

  download gitlab
  download kubectl
  download tailscale

  compile alacritty
  config alacritty --theme

  config git

  srv init pueued
  srv user pueued start
}

def dev [] {
  env-path $env.GOBIN
  env-path $env.CARGOBIN
  env-path $env.PIPX_BIN_DIR
  env-path $env.NPM_CONFIG_BIN

  install go dev
  install npm dev
  install pipx dev
  install cargo dev
}

def extra [] {
  compile mouseless-status
  download mouseless
  config mouseless normal
  startup mouseless
}
