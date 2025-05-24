
export-env {
  $env.DATA_PATH = ($env.HOME | path join nu/nu_base/data/)
  $env.MODULES_PATH = ($env.HOME | path join nu/nu_base/modules/)

  $env.ICONS_PATH = ($env.DATA_PATH | path join icons)
  $env.APPLICATIONS_PATH = ($env.DATA_PATH | path join applications)

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

  pkg font FiraCode

  if (exists-external apt) {
    pkg apt flatpak

    pkg deb discord
    pkg deb vieb
  }

  if (exists-external pacman) {
    pkg pacman flatpak
    pkg pacman discord

    pkg aur vieb
    pkg aur timg
  }

  pkg sh brave
  pkg bin kitty

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

  pkg desktop kitty
  pkg desktop rain-add

  pkg script ctx
  pkg script vicat
  pkg script clipboard
  pkg script term-editor
  pkg script scrollback-pager
  pkg script scrollback-editor

  pkg js install opencommit

  config git
  config mpv
  config vieb
  config kitty
  config opencommit
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
