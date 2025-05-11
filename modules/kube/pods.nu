
def list [] {
  clock run kube-pods 1min {
    kubectl get pods
  } | from ssv
}

def data [all: bool] {
  if $all { list } else { list | where NAME =~ backend }
}

export def main [ --all(-a) ] {
  data $all
}

export def names [ --all(-a) ] {
  data $all | select NAME STATUS | rename value description
}

export def logs [name: string@names] {
  kubectl logs $name --follow
}

export def delete [...name: string@names] {
  kubectl delete pods ...$name --now
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

def groups [] {
  [backend frontend]
}

export def --wrapped diff [group: string@groups, ...rest] {
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

export def rm [] {
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
