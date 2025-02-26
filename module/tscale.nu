
export def ls [] {
  let columns = [ip node owner os status]
  tailscale status | from ssv -n -m 1 | rename ...$columns | select ...$columns
}

export def on [] {
  ls | where status !~ offline
}

export def off [] {
  ls | where status =~ offline
}

export def nodes [] {
  ls | get node
}

export def info [node: string@nodes] {
  ls | where node == $node | first
}

export def ip [node: string@nodes] {
  info $node | get ip
}
