
export-env {
  $env.NVIM_DIR = ($env.HOME | path join .nvim)
  $env.NVIM_CONFIG = ($env.HOME | path join .config nvim)
  $env.NVIM_LOCAL_SHARE = ($env.HOME | path join .local share nvim)
  $env.NVIM_LOCAL_STATE = ($env.HOME | path join .local state nvim)
  $env.NVIM_CACHE = ($env.HOME | path join .cache nvim)
}

const repositories = {
  NvChad: "https://github.com/NvChad/starter"
  LazyVim: "https://github.com/LazyVim/starter"
  LunarVim: "https://github.com/LunarVim/LunarVim"
  AstroNvim: "https://github.com/AstroNvim/template"
  # CosmicNvim: "https://github.com/CosmicNvim/CosmicNvim"
  # NormalNvim: "https://github.com/NormalNvim/NormalNvim.git"
}

def names [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: ($repositories | columns)
  }
}

export def --wrapped run [name: string@names, ...rest] {
  let config = ($env.NVIM_DIR | path join $name config)
  if not ($config | path exists) {
    git clone ($repositories | get $name) $config
  }
  rm -rf $env.NVIM_CONFIG
  ln -sf $config $env.NVIM_CONFIG

  let share = ($env.NVIM_DIR | path join $name share)
  if not ($share | path exists) {
    mkdir $share
  }
  rm -rf $env.NVIM_LOCAL_SHARE
  ln -sf $share $env.NVIM_LOCAL_SHARE

  let state = ($env.NVIM_DIR | path join $name state)
  if not ($state | path exists) {
    mkdir $state
  }
  rm -rf $env.NVIM_LOCAL_STATE
  ln -sf $state $env.NVIM_LOCAL_STATE

  let cache = ($env.NVIM_DIR | path join $name cache)
  if not ($cache | path exists) {
    mkdir $cache
  }
  rm -rf $env.NVIM_CACHE
  ln -sf $cache $env.NVIM_CACHE

  nvim ...$rest
}

export def uninstall [] {
  rm -rf $env.NVIM_CONFIG
  rm -rf $env.NVIM_LOCAL_SHARE
  rm -rf $env.NVIM_LOCAL_STATE
  rm -rf $env.NVIM_CACHE
}
