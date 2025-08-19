
def get-server-aliases [] {
  open $env.SSH_SERVERS | select alias desc | rename value description
}

def get-server-by-alias [alias: string] {
  open $env.SSH_SERVERS | where alias == $alias | first
}

def get-usernames-by-alias [alias: string] {
  get-server-by-alias $alias | get user.name
}

def get-password-by-alias [alias: string, username?: string] {
  get-server-by-alias $alias | get user | where name == $username | first | get pass
}

def get-hostname-by-alias [alias: string, type?: string] {
  let server = get-server-by-alias $alias
  if $type != null {
    return ($server | get host | get $type)
  }
  return $server.hostname
}

def get-usernames-from-context [context: string] {
  get-usernames-by-alias ($context | str trim | split row " " | skip 2 | first)
}

def get-username-by-alias [alias: string@get-server-aliases, username?: string] {
  if $username != null {
    return $username
  }
  return (get-usernames-by-alias $alias | first)
}

def get-host-type [] {
  [local tailscale]
}

def get-server [alias: string@get-server-aliases, username?: string@get-usernames-from-context, type?: string] {
  let username = get-username-by-alias $alias $username
  return {
    username: $username
    password: (get-password-by-alias $alias $username)
    hostname: (get-hostname-by-alias $alias $type)
  }
}

def get-shell-command [] {
  let app = "~/.usr/local/bin/nu"
  let mod = "~/.local/nu_base/mod.nu"
  let exec = $'exec ($app) -e "source ($mod)"'
  # return $"test -f ($app) && test -f ($mod) && ($exec) || exec bash"
  return "script /dev/null -c nu"
  # return "sudo nu"
}

export def shell [
  alias: string@get-server-aliases,
  --username(-u): string@get-usernames-from-context,
  --type(-t): string@get-host-type,
  --display(-d)
] {
  let server = get-server $alias $username $type
  mut args = [-t]
  if $display { $args = ($args | append "-Y") }
  ssh ...$args $"($server.username)@($server.hostname)" (get-shell-command)
}

export def cmd [
  alias: string@get-server-aliases,
  --username(-u): string@get-usernames-from-context,
  --type(-t): string@get-host-type,
  --display(-d)
] {
  let server = get-server $alias $username $type
  mut args = [-t]
  if $display { $args = ($args | append "-Y") }
  commandline edit $"ssh ($args | str join ' ') ($server.username)@($server.hostname)"
}

export def jump [
  from_alias: string@get-server-aliases,
  to_alias: string@get-server-aliases,
  --from-username: string,
  --to-username: string,
  --type(-t): string@get-host-type
  --to-type(-t): string@get-host-type = "local"
] {
  let from_server = get-server $from_alias $from_username $type
  let to_server = get-server $to_alias $to_username $to_type
  ssh -J $"($from_server.username)@($from_server.hostname)" $"($to_server.username)@($to_server.hostname)" -t (get-shell-command)
}

export def "file send" [
  alias: string@get-server-aliases,
  source_path: path,
  dest_path?: string,
  --username(-u): string@get-usernames-from-context,
  --type(-t): string@get-host-type,
] {
  let server = get-server $alias $username $type
  let destination = if $dest_path == null {
    $"($server.username)@($server.hostname):~/($source_path | path basename)"
  } else {
    $"($server.username)@($server.hostname):($dest_path)"
  }
  
  # sshpass -p $server.password
  scp -r $source_path $destination
}

export def "file get" [
  alias: string@get-server-aliases,
  source_path: string,
  dest_path?: path,
  --username(-u): string@get-usernames-from-context,
  --type(-t): string@get-host-type,
] {
  let server = get-server $alias $username $type
  let destination = if $dest_path == null {
    ($source_path | path basename)
  } else {
    $dest_path
  }
  
  # sshpass -p $server.password
  scp -r $"($server.username)@($server.hostname):($source_path)" $destination
}

def copy-key-to-host [host: record] {
  # sshpass -p $host.password
  ssh-copy-id -f $"($host.username)@($host.hostname)"
}

def copy-files-to-host [host: record] {
  sshpass -p $host.password rsync --exclude .git --recursive --info=progress2 $env.NU_BASE_PATH $"($host.username)@($host.hostname):~/.local"
}

def exec-cmd-to-host [host: record, cmd: string] {
  sshpass -p $host.password ssh -t $"($host.username)@($host.hostname)" $cmd
}

export def copy-key [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  copy-key-to-host (get-server $alias $username)
}

export def copy-files [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  copy-files-to-host (get-server $alias $username)
}

export def exec-base [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  exec-cmd-to-host (get-server $alias $username) "bash ~/.local/nu_base/sh/base.sh"
}

def create-script [host: record] {
  $"echo '/home/($host.username)/.local/nu_base' > /home/($host.username)/.nu_base_path"
}

export def setup [
  alias: string@get-server-aliases,
  --username(-u): string@get-usernames-from-context,
] {
  let host = get-server $alias $username

  copy-key-to-host $host
  copy-files-to-host $host
  exec-cmd-to-host $host (create-script $host)
  exec-cmd-to-host $host "bash ~/.local/nu_base/sh/nushell.sh"
  exec-cmd-to-host $host "bash ~/.local/nu_base/sh/base.sh"
}

export def mount [
    alias: string@get-server-aliases,
    username?: string@get-usernames-from-context,
    --wd: string
] {
    let mount_dir = ($env.HOME | path join "media" $alias)
    let host = (get-server $alias $username)
    let remote_path = if ($wd | is-not-empty) { $wd } else {
      "/home" | path join $host.username
    }
    let mount_point = ($mount_dir | path join ($remote_path | path basename))
    mkdir $mount_point

    try {
        sshfs -o ro $"($host.username)@($host.hostname):($remote_path)" $mount_point
        return {
            status: "success",
            mount_point: $mount_point,
            remote_path: $remote_path,
            host: ($host | reject password)
        }
    } catch {
        return {
            status: "error",
            message: $"Failed to mount ($alias)",
            host: ($host | reject password)
            error: $in
        }
    }
}

export def umount [
    alias: string@get-server-aliases,
    username?: string@get-usernames-from-context,
    --wd: string
] {
    let mount_dir = ($env.HOME | path join "media" $alias)
    let host = (get-server $alias $username)
    let remote_path = if ($wd | is-not-empty) { $wd } else {
      "/home" | path join $host.username
    }
    let mount_point = ($mount_dir | path join ($remote_path | path basename))

    try {
        fusermount -u $mount_point
        return {status: "success", message: $"Unmounted ($mount_point)"}
    } catch {
        return {status: "error", message: $"Failed to unmount ($mount_point)"}
    }
}
