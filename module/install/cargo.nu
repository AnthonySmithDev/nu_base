
export def packages [] {
  [
    { name: zellij, category: core, features: "" }
    { name: alacritty, category: core, features: "" }
    { name: nu, category: core, features: "dataframe" }

    { name: zoxide, category: core, features: "" }
    { name: starship, category: core, features: "" }

    { name: ripgrep, category: core, features: "" }
    { name: fd-find, category: core, features: "" }

    { name: bat, category: core, features: "" }
    { name: amber, category: core, features: "" }
    { name: ast-grep, category: core, features: "" }

    { name: git-delta, category: core, features: "" }
    { name: mdcat, category: core, features: "" }
    { name: cloak, category: core, features: "" }
    { name: jless, category: core, features: "" }
    { name: sleek, category: core, features: "" }
    { name: bottom, category: core, features: "" }
    { name: ttyper, category: core, features: "" }
    { name: dua-cli, category: core, features: "" }
    { name: bore-cli, category: core, features: "" }

    { name: xh, category: extra, features: "" }
    { name: procs, category: extra, features: "" }
    { name: genact, category: extra, features: "" }
    { name: erdtree, category: extra, features: "" }
    { name: ouch, category: extra, features: "" }
    { name: pueue, category: extra, features: "" }
    { name: termscp, category: extra, features: "" }
    { name: gitui, category: extra, features: "" }
    { name: gping, category: extra, features: "" }

    { name: websocat, category: other, features: "ssl" }
    { name: miniview, category: other, features: "" }
    { name: csvlens, category: other, features: "" }
    { name: felix, category: other, features: "" }
    { name: rustcat, category: other, features: "" }
    { name: picterm, category: other, features: "" }
    { name: deno, category: other, features: "" }
    { name: fnm, category: other, features: "" }
    { name: xh, category: other, features: "" }
    { name: tere, category: other, features: "" }
    { name: xplr, category: other, features: "" }
    { name: viu, category: other, features: "" }
    { name: grex, category: other, features: "" }
    { name: coreutils, category: other, features: "unix" }
  ]
}

export def core [] {
  for crate in (packages | where category == core) {
    cargo install --locked $crate.name --features $crate.features
  }
}

export def dev [] {
  core
}

export def extra [] {
  for crate in (packages | where category == extra) {
    cargo install --locked $crate.name --features $crate.features
  }
}

def other [] {
  for crate in (packages | where category == other) {
    cargo install --locked $crate.name --features $crate.features
  }
}

export def crates [] {
  packages | get name
}

export def main [name: string@crates] {
  let crate = (packages | where name == $name | first)
  cargo install --locked $crate.name --features $crate.features
}
