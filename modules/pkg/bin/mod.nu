
export use github.nu *
export use other.nu *

export def core [ --force(-f) ] {
  gum
  mods
  glow

  helix
  nushell
  starship
  zoxide
  zellij
  yazi

  fd
  rg
  rgr
  bat
  fzf
  riff

  eza
  gdu
  ouch
  gitu
  jless
  hexyl
  bottom
  lazygit
  lazydocker
  difftastic
  carapace
  mirrord

  uv
  pnpm

  rain
  melt
  soft
  freeze

  qrcp
  qrrs

  task
  wsget
  broot
  rclone
  ttyper

  zk
  omm
  taskell

  usql
  mongosh
  vi-mongo

  kubectl
  kubecolor

  github-cli
  gitlab-cli

  scrcpy

  java
  node
  golang

  kitty
  neovim
}

def remove [path: string] {
  let dirs = (ls $path | where type == dir | get name)
  for dir in $dirs {
    let versions = (ls $dir | sort-by -r modified | get name)
    if ($versions | length) == 1 {
      continue
    }
    print $" + (ansi green_bold)($versions | first)(ansi reset)"
    for version in ($versions | skip 1) {
      print $" - (ansi red_bold)($version)(ansi reset)"
      rm -rf $version
    }
  }
}

export def clean [] {
  remove $env.USR_LOCAL_SHARE_BIN
  remove $env.USR_LOCAL_SHARE_LIB
}
