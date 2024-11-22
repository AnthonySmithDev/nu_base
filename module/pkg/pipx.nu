
export def names [] {
  packages | get name
}

def install [package: record, force: bool] {
  if $force {
    pipx install $package.package --force
  } else {
    pipx install $package.package
  }
}

export def main [name: string@names, --force(-f)] {
  let package = (packages | where name == $name | first)
  install $package $force
}

export def dev [ --force(-f) ] {
  for package in (packages | where category == dev) {
    install $package $force
  }
}

export def core [] {
  dev
}

export def extra [ --force(-f) ] {
  for package in (packages | where category == extra) {
    install $package $force
  }
}

export def other [ --force(-f) ] {
  for package in (packages | where category == other) {
    install $package $force
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
