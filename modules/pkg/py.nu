
export def names [] {
  packages | get name
}

def installer [pkgs: table] {
  for $pkg in $pkgs {
    uv tool install $pkg.package
  }
}

export def install [...names: string@names] {
  installer (packages | where {|e| $e.name in $names})
}

export def dev [] {
  installer (packages | where category == dev)
}

export def extra [] {
  installer (packages | where category == extra)
}

export def other [] {
  installer (packages | where category == other)
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
    [ other kube-shell kube-shell ]
    [ other gpt-command-line gpt-command-line ]
    [ other elia git+https://github.com/darrenburns/elia ]
    [ other termtyper git+https://github.com/kraanzu/termtyper ]
    [ other isd git+https://github.com/isd-project/isd ]
    [ other vimiv git+https://github.com/karlch/vimiv-qt ]
    [ other pyqt6 PyQt6 ]
    [ other oterm oterm ]
    [ other bagels bagels ]
    [ other tiptop tiptop ]
    [ other recoverpy recoverpy ]
    [ other moneyterm moneyterm ]
    [ other vimg textual-imageview ]
  ]
}

export def aider [] {
  uv tool install --force --python python3.12 aider-chat@latest
}
