
export-env {
  $env.TAILSCALED_STATE = "/var/lib/tailscale/tailscaled.state"
  $env.TAILSCALED_BACKUP_DIR = ($env.HOME | path join tailscale)
  $env.TAILSCALED_BACKUP_NAME = "tailscaled.backup"
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

export def backup [--dir: path] {
  if not ($env.TAILSCALED_STATE | sudo-path-exists) {
      error make {msg: "Error: tailscaled.state file not found"}
  }

  let backup_dir = ($dir | default $env.TAILSCALED_BACKUP_DIR)
  let backup_path = ($backup_dir | path join $env.TAILSCALED_BACKUP_NAME)
  mkdir $backup_dir

  sudo systemctl stop tailscaled
  sudo cp $env.TAILSCALED_STATE $backup_path
  sudo chown $"($env.USER):($env.USER)" $backup_path
  sudo chmod 660 $backup_path
  sudo systemctl start tailscaled

  print (ansi green) "Backup completed. Tailscale restarted." (ansi reset)
}

export def restore [--dir: path] {
  let backup_dir = ($dir | default $env.TAILSCALED_BACKUP_DIR)
  let backup_path = ($backup_dir | path join $env.TAILSCALED_BACKUP_NAME)

  if not ($backup_path | path exists) {
      error make {msg: $"Error: tailscaled.backup file not found in ($backup_dir)"}
  }

  sudo systemctl stop tailscaled
  sudo cp $backup_path $env.TAILSCALED_STATE
  sudo chown root:root $env.TAILSCALED_STATE
  sudo chmod 660 $env.TAILSCALED_STATE
  sudo systemctl start tailscaled

  print (ansi green) "Restoration completed. Tailscale restarted." (ansi reset)
}
