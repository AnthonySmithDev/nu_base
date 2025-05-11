
def list [] {
  clock run kube-ingress 1min {
    kubectl get ingress
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def edit [name: string@names] {
  kubectl edit ingressroutes $name
}

export def view [name: string@names] {
  kubectl get ingressroutes $name -o yaml | from yaml
}

export def routes [name: string@names] {
  view $name | get spec.routes
}
