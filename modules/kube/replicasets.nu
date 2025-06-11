
def list [] {
  use clock.nu
  clock run kube-replicasets 1min {
    kubectl get replicasets
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def edit [name: string@names] {
  kubectl edit replicasets $name
}

export def scale [name: string@names, replicas: int = 1] {
  kubectl scale replicaset $name --replicas $replicas
}

export def describe [name: string@names] {
  kubectl describe replicaset $name
}

export def delete [name: string@names] {
  kubectl delete replicaset $name
  use clock.nu
  clock delete kube-replicasets
}
