source ../env.nu
source ../def.nu
source ../builtin.nu
source ../module/mod.nu
use ../module/nerd-font.nu

def main [] {
  setup_zoxide

  config git
  nerd-font FiraCode

  if (exists-external apt) {
    pkg apt flathub
    pkg apt brave
    pkg deb discord

    pkg deb vieb
    config vieb
  }

  pkg bin melt
  pkg bin mods
  pkg bin glow
  pkg bin soft
  pkg bin freeze

  pkg bin eza
  pkg bin bat
  pkg bin qrcp
  pkg bin jless
  pkg bin taskell
  pkg bin lazygit
  pkg bin lazydocker

  pkg bin task
  pkg bin usql
  pkg bin amber
  pkg bin pueue
  pkg bin ttyper
  pkg bin bottom
  pkg bin rclone
  pkg bin carapace
  pkg bin difftastic

  pkg bin gitlab
  pkg bin kubectl
  pkg bin tailscale

  pkg compile alacritty
  config alacritty --theme

  srv init pueued
  srv user pueued start
}

def --env dev [] {
  env-path $env.GOBIN
  env-path $env.CARGOBIN
  env-path $env.PIPX_BIN_DIR
  env-path $env.NPM_CONFIG_BIN

  pkg go dev
  pkg js dev
  pkg py dev
  pkg cargo dev
}

def setup_zoxide [] {
  ^zoxide add ~/Desktop
  ^zoxide add ~/Documents
  ^zoxide add ~/Downloads
  ^zoxide add ~/Music
  ^zoxide add ~/Pictures
  ^zoxide add ~/Public
  ^zoxide add ~/Templates
  ^zoxide add ~/Videos
}
