
def list [] {
  clock run kube-namespaces 1min {
    kubectl get namespaces
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def set [name: string@names] {
  let filename = ($env.HOME | path join .kube config)
  open $filename | from yaml | upsert contexts.context.namespace $name | to yaml | save -f $filename
}
