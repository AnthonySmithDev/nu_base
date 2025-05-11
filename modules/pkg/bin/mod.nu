
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

  eza
  gdu
  gitu
  jless
  bottom
  lazygit
  lazydocker
  difftastic
  carapace

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
}

def remove [path: string] {
  let dirs = (ls $path | where type == dir | get name)
  for dir in $dirs {
    let versions = (ls $dir | sort-by -r modified | skip 1 | get name)
    for version in $versions {
      print $version
      rm -rf $version
    }
  }
}

export def clean [] {
  remove $env.USR_LOCAL_SHARE_BIN
  remove $env.USR_LOCAL_SHARE_LIB
}
