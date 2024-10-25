source ../env.nu
source ../def.nu
source ../module/source.nu

def main [] {
  nu_zoxide

  config git
  nerd-font FiraCode

  if (exists-external apt) {
    # install apt flathub
    install apt brave

    install deb discord
    install deb vieb
    config vieb
  }

  install bin lsd
  install bin bat
  install bin mods
  install bin glow
  install bin freeze
  install bin soft
  install bin qrcp
  install bin jless
  install bin taskell
  install bin lazygit
  install bin lazydocker

  install bin melt
  install bin task
  install bin usql
  install bin amber
  install bin delta
  install bin pueue
  install bin ttyper
  install bin bottom
  install bin rclone
  install bin carapace
  install bin difftastic

  install bin gitlab
  install bin kubectl
  install bin tailscale

  compile alacritty
  config alacritty --theme

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

def nu_zoxide [] {
  ^zoxide add ~/Desktop
  ^zoxide add ~/Documents
  ^zoxide add ~/Downloads
  ^zoxide add ~/Music
  ^zoxide add ~/Pictures
  ^zoxide add ~/Public
  ^zoxide add ~/Templates
  ^zoxide add ~/Videos
}
