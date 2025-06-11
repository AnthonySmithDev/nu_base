
def list [] {
  use clock.nu
  clock run kube-services 1min {
    kubectl get services
  } | from ssv
}

export def main [] {
  list
}

export def names [] {
  list | get NAME?
}

export def edit [name: string@names] {
  kubectl edit services $name
}

export def view [name: string@names] {
  kubectl get services $name -o yaml | from yaml
}

export def --env port [name: string@names] {
  let port = (main | where NAME == $name | get "PORT(S)" | first)
  $port | split row "/" | first
}

export def port-forward [name: string@names, local_port: string, remote_port: string] {
  let service = ([service $name] | path join)
  let ports = ([$local_port $remote_port] | str join ":")

  kubectl port-forward --address 0.0.0.0 $service $ports
}
