
export-env {
  $env.NVIMS_DIR = ($env.HOME | path join .nvims)

  $env.NVIM_CONFIG = ($env.HOME | path join .config nvim)
  $env.NVIM_LOCAL_SHARE = ($env.HOME | path join .local share nvim)
  $env.NVIM_LOCAL_STATE = ($env.HOME | path join .local state nvim)
  $env.NVIM_CACHE = ($env.HOME | path join .cache nvim)
}

const repositories = {
  nvchad: "https://github.com/NvChad/starter"
  lazyvim: "https://github.com/LazyVim/starter"
  lunarvim: "https://github.com/LunarVim/LunarVim"
  astronvim: "https://github.com/AstroNvim/template"
  # cosmicnvim: "https://github.com/CosmicNvim/CosmicNvim"
  # normalnvim: "https://github.com/NormalNvim/NormalNvim.git"
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

export def install [...names: string@names] {
  for $name in ($names | default -e ($repositories | columns)) {
    let config = ($env.NVIMS_DIR | path join $name config)
    if not ($config | path exists) {
      git clone ($repositories | get $name) $config
      print ""
    } else {
      git -C $config pull
      print ""
    }
    rm -rf $env.NVIM_CONFIG
    ln -sf $config $env.NVIM_CONFIG

    let share = ($env.NVIMS_DIR | path join $name share)
    if not ($share | path exists) {
      mkdir $share
    }
    rm -rf $env.NVIM_LOCAL_SHARE
    ln -sf $share $env.NVIM_LOCAL_SHARE

    let state = ($env.NVIMS_DIR | path join $name state)
    if not ($state | path exists) {
      mkdir $state
    }
    rm -rf $env.NVIM_LOCAL_STATE
    ln -sf $state $env.NVIM_LOCAL_STATE

    let cache = ($env.NVIMS_DIR | path join $name cache)
    if not ($cache | path exists) {
      mkdir $cache
    }
    rm -rf $env.NVIM_CACHE
    ln -sf $cache $env.NVIM_CACHE
  }
}

export def --wrapped run [name: string@names, ...rest] {
  install $name
  nvim ...$rest
}

export def remove [...names: string@names] {
  rm -rf $env.NVIM_CONFIG
  rm -rf $env.NVIM_LOCAL_SHARE
  rm -rf $env.NVIM_LOCAL_STATE
  rm -rf $env.NVIM_CACHE

  for $name in $names {
    rm -rf ($env.NVIMS_DIR | path join $name config)
    rm -rf ($env.NVIMS_DIR | path join $name share)
    rm -rf ($env.NVIMS_DIR | path join $name state)
    rm -rf ($env.NVIMS_DIR | path join $name cache)
  }
}
