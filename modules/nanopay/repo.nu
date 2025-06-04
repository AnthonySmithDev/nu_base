export def names [] {
  {
    frontend: [
      'nanopay-frontend-user'
      'nanopay-frontend-admin'
      'nanopay-frontend-payment'
      'nanopay-frontend-p2p-desktop'
    ],
    backend: [
      # 'nanopay-backend-all'
      # 'nanopay-backend-main'
      'nanopay-backend-user'
      'nanopay-backend-admin'
      'nanopay-backend-price'
      'nanopay-backend-upload'
      'nanopay-backend-out'
      'nanopay-backend-lnd'
      'nanopay-backend-nanod'
      'nanopay-backend-bitcoind'
      'nanopay-backend-payment'
      'nanopay-backend-p2p'
      'nanopay-backend-ws'
      'nanopay-backend-bot'
      'nanopay-backend-coingecko'
    ]
  }
}

def --wrapped git_cmd [category: string, name: string, command: string, ...args] {
  print $"\n--- ($name) ---"
  let dir = match $category {
    "frontend" => $env.NANOPAY_FRONTEND,
    "backend" => $env.NANOPAY_BACKEND,
    _ => { error make {msg: "Invalid category, must be 'frontend' or 'backend'"} }
  }
  let path = ($dir | path join $name)
  git -C $path $command ...$args
}

def git_clone [category: string, name: string] {
  let dir = match $category {
    "frontend" => $env.NANOPAY_FRONTEND,
    "backend" => $env.NANOPAY_BACKEND,
    _ => { error make {msg: "Invalid category, must be 'frontend' or 'backend'"} }
  }
  let path = ($dir | path join $name)
  if not ($path | path exists) {
    git clone $"git@($env.GITLAB_HOST):nanopay/($category)/($name).git" $path --recurse-submodules
  }
}

def zoxide_add [category: string, name: string] {
  print $"\n--- ($name) ---"
  let dir = match $category {
    "frontend" => $env.NANOPAY_FRONTEND,
    "backend" => $env.NANOPAY_BACKEND,
    _ => { error make {msg: "Invalid category, must be 'frontend' or 'backend'"} }
  }
  ^zoxide add ($dir | path join $name)
}

def run_for_each_repo [category: string, command: closure] {
  for $name in (names | get $category) {
    do $command $name
  }
}

export def --wrapped cmd [category: string, command: string, ...args] {
  run_for_each_repo $category { |name| git_cmd $category $name $command ...$args }
}

export def clone [category: string] {
  run_for_each_repo $category { |name| git_clone $category $name }
}

export def submodule [category: string] {
  run_for_each_repo $category { |name| git_cmd $category $name submodule update --init --recursive }
}

export def status [category: string] {
  run_for_each_repo $category { |name| git_cmd $category $name status }
}

export def switch [category: string, branch: string] {
  run_for_each_repo $category { |name| 
    try { git_cmd $category $name switch $branch }
  }
}

export def fetch [category: string] {
  run_for_each_repo $category { |name| git_cmd $category $name fetch }
}

export def pull [category: string] {
  run_for_each_repo $category { |name| 
    try { git_cmd $category $name pull }
  }
}

export def reset [category: string, branch: string] {
  run_for_each_repo $category { |name| 
    try {
      gum confirm --default=false $"Are you sure run ($name): git reset --hard origin/($branch)?"
      git_cmd $category $name reset --hard origin/($branch)
    }
  }
}

export def remote_refresh [category: string] {
  run_for_each_repo $category { |name|
    git_cmd $category $name remote remove origin
    git_cmd $category $name remote add origin $"git@($env.GITLAB_HOST):nanopay/($category)/($name).git"
    git_cmd $category $name push --set-upstream origin main
  }
}

export def zoxide [category: string] {
  run_for_each_repo $category { |name| zoxide_add $category $name }
}
