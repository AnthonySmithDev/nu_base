
export def install [pkg: string@names] {
  pnpm install --global $pkg
}

export def core [] {
  for package in (packages | where category == dev) {
    install $package
  }
}

export def extra [] {
  for package in (packages | where category == extra) {
    install $package
  }
}

export def nativescript [] {
  install nativescript
}

export def quasar [] {
  install @quasar/cli
}

export def packages [] {
  [
    [ category name package];

    [ dev serve serve ]
    [ dev wscat wscat ]
    [ dev prettier prettier ]
    [ dev opencommit opencommit ]
    [ dev gitmoji-cli gitmoji-cli ]
    [ dev localtunnel localtunnel ]

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

export def names [] {
  packages | get name
}
