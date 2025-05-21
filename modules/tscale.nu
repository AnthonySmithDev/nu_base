
export-env {
  $env.TAILSCALED_STATE = "/var/lib/tailscale/tailscaled.state"
  $env.TAILSCALED_BACKUP = ($env.HOME | path join tailscale/tailscaled.backup)
}

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

def sudo-path-exists [] {
  try {
    sudo test -e $in
  } catch {
    return false
  }
  return true
}

export def backup [destination?: path] {
  if not ($env.TAILSCALED_STATE | sudo-path-exists) {
      error make {msg: "Error: tailscaled.state file not found"}
  }

  let tailscaled_backup = ($destination | default $env.TAILSCALED_BACKUP)
  sudo systemctl stop tailscaled
  mkdir ($tailscaled_backup | path dirname)
  sudo cp $env.TAILSCALED_STATE $tailscaled_backup
  sudo chown $"($env.USER):($env.USER)" $tailscaled_backup
  sudo chmod 600 $tailscaled_backup
  sudo systemctl start tailscaled

  print (ansi green) "Backup completed. Tailscale restarted." (ansi reset)
}

export def restore [source?: path] {
  let tailscaled_backup = ($source | default $env.TAILSCALED_BACKUP)
  if not ($tailscaled_backup | path exists) {
      error make {msg: "Error: tailscaled.backup file not found"}
  }

  sudo systemctl stop tailscaled
  sudo cp $tailscaled_backup $env.TAILSCALED_STATE
  sudo chown root:root $env.TAILSCALED_STATE
  sudo chmod 600 $env.TAILSCALED_STATE
  sudo systemctl start tailscaled

  print (ansi green) "Restoration completed. Tailscale restarted." (ansi reset)
}
