
export def --env rust [ --latest(-l), --force(-f) ] {
  if (which rustup | is-empty) or $force {
    if (exists-external curl) {
      curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh -s -- -q -y
    }
    if (exists-external wget) {
      wget -O- --https-only --secure-protocol=auto --quiet --show-progress https://sh.rustup.rs | sh -s -- -q -y
    }
  }
  env-path $env.CARGOBIN
}

export def bun [ --force(-f) ] {
  if not (exists-external bun) or $force {
    curl -fsSL https://bun.sh/install | bash
  }
}

export def deno [ --force(-f) ] {
  if not (exists-external deno) or $force {
    curl -fsSL https://deno.land/install.sh | sh
  }
}

export def haskell [ --latest(-l), --force(-f) ] {
  if not (exists-external ghcup) or $force {
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  }
}

export def nix [ --force(-f) ] {
  if not (exists-external nix) or $force {
    curl -L 'https://nixos.org/nix/install' | bash -s -- --daemon
  }
}

export def tailscale [ --force(-f) ] {
  if not (exists-external tailscale) or $force {
    curl -fsSL 'https://tailscale.com/install.sh' | sh
  }
}

export def zed [ --force(-f) ] {
  if not (exists-external zed) or $force {
    curl https://zed.dev/install.sh | sh
  }
}

export def devbox [ --force(-f) ] {
  if not (exists-external devbox) or $force {
    curl -fsSL https://get.jetify.com/devbox | bash
  }
}

export def fnm [ --force(-f) ] {
  if not (exists-external fnm) or $force {
    curl -fsSL https://fnm.vercel.app/install | bash
  }
}

export def ollama [ --force(-f) ] {
  if not (exists-external ollama) or $force {
    curl -fsSL https://ollama.com/install.sh | sh
  }
}
