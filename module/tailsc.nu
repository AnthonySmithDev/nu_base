
export def list [] {
  let columns = [ip node owner os status]
  tailscale status | from ssv -n -m 1 | rename ...$columns | select ...$columns
}

export alias ls = list

export def online [] {
  list | where status == '-'
}

export def offline [] {
  list | where status == 'offline'
}

export def nodes [] {
  list | get node
}

export def info [node: string@nodes] {
  list | where node == $node | first
}

export def ip [node: string@nodes] {
  info $node | get ip
}
