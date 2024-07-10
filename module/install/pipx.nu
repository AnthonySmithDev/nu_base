
export def names [] {
  packages | get name
}

def install [package: record] {
  pipx install $package.package
}

export def main [name: string@names] {
  let package = (packages | where name == $name | first)
  install $package
}

export def dev [] {
  for package in (packages | where category == dev) {
    install $package
  }
}

export def core [] {
  dev
}

export def extra [] {
  for package in (packages | where category == extra) {
    install $package
  }
}

export def other [] {
  for package in (packages | where category == other) {
    install $package
  }
}

export def packages [] {
  [
    [ category name package];
    [ dev qmk qmk ]
    [ dev mycli mycli ]
    [ dev iredis iredis ]
    [ dev litecli litecli ]
    [ dev harlequin 'harlequin[mysql]' ]
    [ dev httpie httpie ]
    [ dev ranger ranger-fm ]

    [ extra dooit dooit ]
    [ extra girok girok ]
    [ extra calcure calcure ]
    [ extra scrapy scrapy ]
    [ extra http-prompt http-prompt ]

    [ other ipython ipython ]
    [ other asciinema asciinema ]
    [ other shell-gpt shell-gpt ]
    [ other gpt-command-line gpt-command-line ]
    [ other elia 'git+https://github.com/darrenburns/elia' ]
    [ other termtyper 'git+https://github.com/kraanzu/termtyper' ]
    [ other vimiv 'git+https://github.com/karlch/vimiv' ]
  ]
}
