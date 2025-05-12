
export-env {
  $env.DATA_PATH = ($env.HOME | path join nu/nu_base/data/)
  $env.CONFIG_PATH = ($env.DATA_PATH | path join config)
  $env.SYSTEMD_PATH = ($env.DATA_PATH | path join systemd)
  
  $env.GHUB_REPOSITORY_PATH = ($env.CONFIG_PATH | path join ghub/ghub.json)
  $env.GHUB_TEMP_PATH = ($env.HOME | path join temp/ghub)

  $env.PKG_BIN_SYS = "linux_x64"
  $env.PKG_TEMP_PATH = ($env.HOME | path join temp/pkg)
}

use config/
use ghub/
use pkg/

export def main [] {
  setup_zoxide

  config git
  pkg font FiraCode

  if (exists-external apt) {
    pkg apt brave
    pkg deb discord
    pkg apt flathub

    pkg deb vieb
    pkg apt wezterm

    config vieb
    config wezterm
  }

  pkg bin rain
  pkg bin melt
  pkg bin soft
  pkg bin freeze

  pkg bin qrcp
  pkg bin qrrs

  pkg bin task
  pkg bin wsget
  pkg bin broot
  pkg bin rclone
  pkg bin ttyper

  pkg bin zk
  pkg bin omm
  pkg bin taskell

  pkg bin usql
  pkg bin mongosh
  pkg bin vi-mongo

  pkg bin kubectl
  pkg bin kubecolor

  pkg bin github-cli
  pkg bin gitlab-cli

  pkg bin scrcpy

  pkg sh tailscale

  pkg desktop helix
  pkg desktop yazi
  pkg desktop zellij
}

export def --env dev [] {
  env-path $env.GOBIN
  env-path $env.CARGOBIN
  env-path $env.PIPX_BIN_DIR
  env-path $env.sync-NPM_CONFIG_BIN

  pkg go dev
  pkg js dev
  pkg py dev
  pkg cargo dev
}

export def setup_zoxide [] {
  ^zoxide add ~/Desktop
  ^zoxide add ~/Documents
  ^zoxide add ~/Downloads
  ^zoxide add ~/Music
  ^zoxide add ~/Pictures
  ^zoxide add ~/Public
  ^zoxide add ~/Templates
  ^zoxide add ~/Videos
}
