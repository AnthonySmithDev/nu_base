
export use github.nu *
export use other.nu *

export def core [ --force(-f) ] {
  gum
  # mods
  glow
  crush
  opencode

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
  resvg

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

  neovim

  java
  node
  golang
}

def remove [path: string] {
  let dirs = (ls $path | where type == dir | get name)
  for dir in $dirs {
    let versions = (ls $dir | sort-by -r modified | get name)
    if ($versions | length) == 0 {
      print $"(ansi blue_bold) - ($dir)(ansi reset)"
      rm -rfp $dir
      continue
    }
    if ($versions | length) == 1 {
      continue
    }
    print $"(ansi green_bold) + ($versions | first)(ansi reset)"
    for version in ($versions | skip 1) {
      print $"  (ansi red_bold) - ($version)(ansi reset)"
      rm -rfp $version
    }
  }
}

export def "local ls" [] {
  ls $env.USR_LOCAL_SHARE_BIN | get name
  | append (ls $env.USR_LOCAL_SHARE_LIB | get name)
}

export def "local clean" [] {
  remove $env.USR_LOCAL_SHARE_BIN
  remove $env.USR_LOCAL_SHARE_LIB
}

export def "global ls" [] {
  ls --long /usr/local/bin/ | where type == symlink | select name target
}

export def "global clean" [] {
  for $path in (global ls | get name) {
    sudo rm -rf $path
  }
}
