
export def names [] {
  packages | get name
}

def install [package: record] {
  mut args = [
    --locked $package.name
  ]
  if ($package.features | is-not-empty) {
    $args = ($args | append [--features $package.features])
  }
  cargo install ...$args
}

export def main [name: string@names] {
  let crate = (packages | where name == $name | first)
  install $crate
}

export def core [] {
  for crate in (packages | where category == core) {
    install $crate
  }
}

export def dev [] {
  core
}

export def extra [] {
  for crate in (packages | where category == extra) {
    install $crate
  }
}

def other [] {
  for crate in (packages | where category == other) {
    install $crate
  }
}

export def packages [] {
  [
    [ category name features]; 
    [ core zellij null]
    [ core alacritty null]
    [ core nu null]

    [ core zoxide null]
    [ core starship null]

    [ core ripgrep null]
    [ core fd-find null]

    [ core bat null]
    [ core amber null]
    [ core ast-grep null]

    [ core git-delta null]
    [ core mdcat null]
    [ core cloak null]
    [ core jless null]
    [ core sleek null]
    [ core bottom null]
    [ core ttyper null]
    [ core dua-cli null]
    [ core bore-cli null]

    [ extra xh null]
    [ extra procs null]
    [ extra genact null]
    [ extra erdtree null]
    [ extra ouch null]
    [ extra pueue null]
    [ extra termscp null]
    [ extra gitui null]
    [ extra gping null]

    [ other websocat ssl ]
    [ other miniview null]
    [ other csvlens null]
    [ other felix null]
    [ other rustcat null]
    [ other picterm null]
    [ other deno null]
    [ other fnm null]
    [ other xh null]
    [ other tere null]
    [ other xplr null]
    [ other viu null]
    [ other grex null]
    [ other coreutils unix ]
  ]
}
