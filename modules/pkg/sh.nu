
def download [url: string] {
  # wget -O- --https-only --secure-protocol=auto --quiet --show-progress $url
  # curl --proto '=https' --tlsv1.2 -sSf $url
  http get $url
}

export def --env rust [ --force(-f) ] {
  if not (exists-external rustup) or $force {
    download 'https://sh.rustup.rs' | sh -s -- -q -y
  }
  env-path $env.CARGOBIN
}

export def bun [ --force(-f) ] {
  if not (exists-external bun) or $force {
    download https://bun.sh/install | bash
  }
}

export def deno [ --force(-f) ] {
  if not (exists-external deno) or $force {
    download https://deno.land/install.sh | sh
  }
}

export def haskell [ --force(-f) ] {
  if not (exists-external ghcup) or $force {
    download https://get-ghcup.haskell.org | sh
  }
}

export def nix [ --force(-f) ] {
  if not (exists-external nix) or $force {
    download 'https://nixos.org/nix/install' | bash -s -- --daemon
  }
}

export def tailscale [ --force(-f) ] {
  if not (exists-external tailscale) or $force {
    download 'https://tailscale.com/install.sh' | sh
  }
}

export def zed [ --force(-f) ] {
  if not (exists-external zed) or $force {
    download https://zed.dev/install.sh | sh
  }
}

export def devbox [ --force(-f) ] {
  if not (exists-external devbox) or $force {
    download https://get.jetify.com/devbox | bash
  }
}

export def fnm [ --force(-f) ] {
  if not (exists-external fnm) or $force {
    download https://fnm.vercel.app/install | bash
  }
}

export def ollama [ --force(-f) ] {
  if not (exists-external ollama) or $force {
    download https://ollama.com/install.sh | sh
  }
}

export def zellij [ --force(-f) ] {
  if not (exists-external zellij) or $force {
    download https://zellij.dev/launch | bash
  }
}

export def uv [ --force(-f) ] {
  if not (exists-external uv) or $force {
    download https://astral.sh/uv/install.sh | sh
  }
}

export def ruff [ --force(-f) ] {
  if not (exists-external ruff) or $force {
    download https://astral.sh/ruff/install.sh | sh
  }
}

export def sshx [ --force(-f) ] {
  if not (exists-external sshx) or $force {
    download https://sshx.io/get | sh
  }
}

export def aider [ --force(-f) ] {
  if not (exists-external aider) or $force {
    download https://aider.chat/install.sh | sh
  }
}

export def starship [ --force(-f) ] {
  if not (exists-external starship) or $force {
    download https://starship.rs/install.sh | sh
  }
}

export def zoxide [ --force(-f) ] {
  if not (exists-external zoxide) or $force {
    download https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  }
}

export def dotnet [ --force(-f) ] {
  # sudo apt install zlib1g
  if not (exists-external dotnet) or $force {
    download https://dot.net/v1/dotnet-install.sh | bash -s -- --version latest
  }
}

export def brave [ --force(-f) ] {
  if not (exists-external brave) or $force {
    curl -fsS https://dl.brave.com/install.sh | sh
  }
}
