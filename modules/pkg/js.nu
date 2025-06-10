
export def names [] {
  packages | get name
}

def installer [pkgs: list] {
  for $pkg in $pkgs {
    pnpm install --global $pkg
  }
}

export def install [...names: string@names] {
  let pkgs = (packages | where {|e| $e.name in $names} | get package)
  if ($pkgs | is-empty) {
    installer $names
  } else {
    installer $pkgs
  }
}

export def core [] {
  installer (packages | where category == dev | get package)
}

export def extra [] {
  installer (packages | where category == extra | get package)
}

export def packages [] {
  [
    [ category name package];

    [ dev serve serve ]
    [ dev wscat wscat ]
    [ dev prettier prettier ]
    [ dev opencommit opencommit ]
    [ dev http-server http-server ]
    [ dev gitmoji-cli gitmoji-cli ]
    [ dev localtunnel localtunnel ]
    [ dev ezshare ezshare ]

    [ extra pake pake-cli ]
    [ extra tldr tldr ]
    [ extra surge surge ]
    [ extra httpyac httpyac ]
    [ extra taskbook taskbook ]
    [ extra carbon carbon-now-cli ]

    [ other nativescript nativescript ]
    [ other quasar @quasar/cli ]
  ]
}
