
export-env {
  $env.NVIM_DIR = ($env.HOME | path join .nvim)
  $env.NVIM_CONFIG = ($env.HOME | path join .config nvim)
}

export def uninstall [] {
  rm -rf $env.NVIM_CONFIG
  rm -rf ~/.local/state/nvim
  rm -rf ~/.local/share/nvim
}

export def NvChad [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join NvChad)
  if not ($src | path exists) {
    git clone https://github.com/NvChad/starter $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}

export def LunarVim [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join LunarVim)
  if not ($src | path exists) {
    git clone https://github.com/LunarVim/LunarVim $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}

export def LazyVim [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join LazyVim)
  if not ($src | path exists) {
    git clone https://github.com/LazyVim/starter $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}

export def AstroNvim [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join AstroNvim)
  if not ($src | path exists) {
    git clone https://github.com/AstroNvim/template $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}

def CosmicNvim [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join CosmicNvim)
  if not ($src | path exists) {
    git clone https://github.com/CosmicNvim/CosmicNvim $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}

def NormalNvim [ --uninstall(-u) ] {
  if $uninstall {
    uninstall
  }
  let src = ($env.NVIM_DIR | path join NormalNvim)
  if not ($src | path exists) {
    git clone https://github.com/NormalNvim/NormalNvim.git $src
  }
  if ($env.NVIM_CONFIG | path exists) {
    rm -rf $env.NVIM_CONFIG
  }
  ln -sf $src $env.NVIM_CONFIG
  nvim
}
