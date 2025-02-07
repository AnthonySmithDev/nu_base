
export def names [] {
  packages | get name
}

def installer [packages: table] {
  for $package in $packages {
    mut args = [
      --locked $package.name
    ]
    if ($package.features | is-not-empty) {
      $args = ($args | append [--features $package.features])
    }
    cargo install ...$args
  }
}

export def install [...names: string@names] {
  installer (packages | where {|e| $e.name in $names})
}

export def core [] {
  installer (packages | where category == core)
}

export def dev [] {
  core
}

export def extra [] {
  installer (packages | where category == extra)
}

def other [] {
  installer (packages | where category == other)
}

def cruster [] {
  cargo install --git https://github.com/sinKettu/cruster --tag "v0.7.2"
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
    [ other fzf-make null ]
  ]
}
