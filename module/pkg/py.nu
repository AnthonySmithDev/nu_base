
export def --wrapped install [name: string@names, ...rest] {
  let package = (packages | where name == $name | first)
  uv tool install $package.package ...$rest
}

export def dev [] {
  for package in (packages | where category == dev) {
    install $package.name
  }
}

export def extra [] {
  for package in (packages | where category == extra) {
    install $package.name
  }
}

export def other [] {
  for package in (packages | where category == other) {
    install $package.name
  }
}

export def packages [] {
  [
    [ category name package];

    [ dev qmk qmk ]
    [ dev mycli mycli ]
    [ dev iredis iredis ]
    [ dev litecli litecli ]
    [ dev harlequin harlequin[mysql] ]
    [ dev httpie httpie ]
    [ dev ranger ranger-fm ]
    [ dev pyclip pyclip ]
    [ dev posting posting ]

    [ extra dooit dooit ]
    [ extra girok girok ]
    [ extra dolphie dolphie ]
    [ extra calcure calcure ]
    [ extra scrapy scrapy ]
    [ extra http-prompt http-prompt ]

    [ other ipython ipython ]
    [ other asciinema asciinema ]
    [ other shell-gpt shell-gpt ]
    [ other gpt-command-line gpt-command-line ]
    [ other elia git+https://github.com/darrenburns/elia ]
    [ other termtyper git+https://github.com/kraanzu/termtyper ]
    [ other vimiv git+https://github.com/karlch/vimiv ]
  ]
}

export def names [] {
  packages | get name
}
