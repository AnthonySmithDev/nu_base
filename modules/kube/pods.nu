
def list [] {
  use clock.nu

  clock run kube-pods 2min {
    kubectl get pods
  } | from ssv
}

def type-groups [] {
  [all backend frontend db]
}

export def --env set [group: string@type-groups] {
  $env.KUBE_POD_NAME = $group
}

def data [] {
  match $env.KUBE_POD_NAME? {
    "backend" => (list | where NAME =~ backend)
    "frontend" => (list | where NAME =~ frontend)
    "db" => (list | where {|it| $it.NAME =~ mongo- or $it.NAME =~ redis- })
    _ => (list)
  }
}

export def main [] {
  data
}

export def names [] {
  data | select NAME STATUS | rename value description
}

export def logs [name: string@names] {
  kubectl logs $name --follow
}

export def delete [...name: string@names] {
  kubectl delete pods ...$name --now
  refresh
}

export def refresh [] {
  use clock.nu
  clock delete kube-pods
}

export def edit [name: string@names] {
  kubectl edit pod $name
}

export def view [name: string@names] {
  kubectl get pod $name -o yaml | from yaml
}

export def restart [] {
  let names = (names | where ($it | str contains backend))
  for $name in $names {
    delete $name
  }
}

export def --wrapped exec [name: string@names, ...cmd: string] {
  kubectl exec $name -- ...$cmd
}

export def shell [name: string@names] {
  kubectl exec -it $name -- sh
}

export def describe [name: string@names] {
  kubecolor describe pod $name
}

export def mirror [name: string@names, ...cmd: string] {
  mirrord exec --target $"pod/($name)" ...$cmd
}

export def watch [] {
  viddy -n 1s -p -t -s -b -- kubecolor get pods
}

export def all [] {
  kubectl get pods --all-namespaces | from ssv
}

export def images [] {
  let output = "NAME:.metadata.name,IMAGES:.spec.containers[*].image"
  kubectl get pods -o custom-columns=($output) | from ssv
}

def diff-groups [] {
  [backend frontend]
}

export def --wrapped diff [group: string@diff-groups, ...rest] {
  let output = "NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,IMAGES:.spec.containers[*].image"
  let pods = (kubectl get pods -o custom-columns=($output) -A | from ssv | where NAME =~ $group)
  let a = (mktemp -t --suffix .txt)
  let b = (mktemp -t --suffix .txt)
  $pods | where NAMESPACE == "payzum" | get IMAGES | save -f $a
  $pods | where NAMESPACE == "payzum-dev" | get IMAGES | save -f $b
  difft ...$rest $a $b
}

export def status [] {
  all | get STATUS | uniq
}

export def namespaces [] {
  all | group-by NAMESPACE
}

export def remove [] {
  let pods = (kubectl get pods | lines | skip)
  let filter = (gum filter --strict --no-limit ...$pods | from ssv --noheaders)
  let names = ($filter | rename NAME READY STATUS RESTARTS AGE | get NAME)
  if ($names | | is-empty) {
    return
  }
  kubectl delete pods ...$names --now
}

export def env [name: string@names, terms: string = ''] {
  let envs = exec $name env | lines | where $it =~ 'APP'
  $envs | where ($it | str downcase) =~ $terms
}

export def 'search env' [name: string@names] {
  env $name | to text | gum filter --no-fuzzy
}

export def 'spec env' [name: string@names] {
  view $name | get spec.containers | first | get env.name
}
