
def list [] {
  use clock.nu
  clock run kube-deployments 1min {
    kubectl get deployments
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def scale [name: string@names, replicas: int = 1] {
  kubectl scale deployment $name --replicas $replicas
}

export def delete [name: string@names] {
  kubectl delete deployment $name
  use clock.nu
  clock delete kube-deployments
}
