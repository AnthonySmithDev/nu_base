
export def dev [] {
  cargo install --locked sleek
}

export def core [] {
  cargo install --locked zellij
  cargo install --locked alacritty
  cargo install --locked nu --features=dataframe

  cargo install --locked zoxide
  cargo install --locked starship

  cargo install --locked ripgrep
  cargo install --locked fd-find

  cargo install --locked bat
  cargo install --locked amber
  cargo install --locked ast-grep

  cargo install --locked git-delta
  cargo install --locked mdcat
  cargo install --locked cloak
  cargo install --locked jless
  cargo install --locked bottom
  cargo install --locked ttyper
  cargo install --locked dua-cli
  cargo install --locked bore-cli
}

export def extra [] {
  cargo install --locked xh
  cargo install --locked procs
  cargo install --locked genact
  cargo install --locked erdtree
  cargo install --locked ouch
  cargo install --locked pueue
  cargo install --locked termscp
  cargo install --locked gitui
  cargo install --locked gping
}

def other [] {
  cargo install --features=ssl websocat
  cargo install --locked miniview
  cargo install --locked csvlens
  cargo install --locked felix
  cargo install --locked rustcat
  cargo install --locked picterm
  cargo install --locked deno
  cargo install --locked fnm
  cargo install --locked xh
  cargo install --locked tere
  cargo install --locked xplr
  cargo install --locked viu
  cargo install --locked grex
  cargo install --locked coreutils --features unix
}
