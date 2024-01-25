
export def lunarvim [] {
  let args = [
    '-v' '/home/anthony/.local/share/lunarvim:/root/.local/share/nvim'
    '-v' '/home/anthony/.local/state/lunarvim:/root/.local/state/nvim'
    '-v' '/home/anthony/.cache/lunarvim:/root/.cache/nvim'
    '-v' $'($env.PWD):/root/pwd'
  ]
  docker run --rm ...$args -it lunarvim
}

export def nvchad [] {
  let args = [
    '-v' '/home/anthony/.local/share/nvchad:/root/.local/share/nvim'
    '-v' '/home/anthony/.local/state/nvchad:/root/.local/state/nvim'
    '-v' '/home/anthony/.cache/nvchad:/root/.cache/nvim'
    '-v' $'($env.PWD):/root/pwd'
  ]
  docker run --rm ...$args -it nvchad
}

export def lazyvim [] {
  let args = [
    '-v' '/home/anthony/.local/share/lazyvim:/root/.local/share/nvim'
    '-v' '/home/anthony/.local/state/lazyvim:/root/.local/state/nvim'
    '-v' '/home/anthony/.cache/lazyvim:/root/.cache/nvim'
    '-v' $'($env.PWD):/root/pwd'
  ]
  docker run --rm ...$args -it lazyvim
}

export def astronvim [] {
  let args = [
    '-v' '/home/anthony/.local/share/astronvim:/root/.local/share/nvim'
    '-v' '/home/anthony/.local/state/astronvim:/root/.local/state/nvim'
    '-v' '/home/anthony/.cache/astronvim:/root/.cache/nvim'
    '-v' $'($env.PWD):/root/pwd'
  ]
  docker run --rm ...$args -it astronvim
}
