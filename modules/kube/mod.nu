
export use pods.nu
export use services.nu
export use deployments.nu
export use replicasets.nu
export use namespaces.nu
export use secrets.nu
export use ingress.nu

export use forward.nu

export def prod [] {
  namespaces set payzum
}

export def dev [] {
  namespaces set payzum-dev
}

export module logs {
  export def main [] {
    pods logs (pods names  | where ($it | str contains backend-main) | first)
  }

  export def p2p [] {
    pods logs (pods names  | where ($it | str contains backend-p2p) | first)
  }
}

export def config [src: path] {
  let dir = ($env.HOME | path join .kube)
  mkdir $dir

  ln -sf $src ($dir | path join config)
}
