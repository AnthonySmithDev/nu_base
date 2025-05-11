
def list [] {
  clock run kube-secrets 1min {
    kubectl get secrets
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def edit [name: string@names] {
  kubectl edit secrets $name
}

export def view [name: string@names] {
  kubectl get secrets $name -o yaml | from yaml
}

export def env [name: string@names] {
  mut data = {}
  for $x in (view $name | get data | transpose key value) {
    $data = ($data | insert $x.key ($x.value | decode base64 | decode))
  }
  $data
}
