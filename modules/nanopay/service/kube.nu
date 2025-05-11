
export def insert [] {
  let names = (kube pods | get NAME)
  kube pods exec ($names | where $it =~ p2p | first) ./bin -- db insert
  kube pods exec ($names | where $it =~ main | first) ./bin -- db insert
  kube pods exec ($names | where $it =~ nanod | first) ./bin -- db insert
  kube pods exec ($names | where $it =~ bitcoind | first) ./bin -- db insert
  kube pods exec ($names | where $it =~ upload | first) ./bin -- bucket
}

export def index [] {
  let names = (kube pods | get NAME)
  kube pods exec ($names | where $it =~ main | first) ./bin -- db index
}
