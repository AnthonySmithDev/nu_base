def get-server-aliases [] {
  $env.SSH_SERVERS | select alias desc | rename value description
}

def get-server-by-alias [alias: string] {
  $env.SSH_SERVERS | where alias == $alias | first
}

def get-usernames-by-alias [alias: string] {
  get-server-by-alias $alias | get user.name
}

def get-password-by-alias [alias: string, username: string] {
  get-server-by-alias $alias | get user | where name == $username | first | get pass
}

def get-hostname-by-alias [alias: string] {
  get-server-by-alias $alias | get hostname
}

def get-usernames-from-context [context: string] {
  get-usernames-by-alias ($context | str trim | split words | skip 2 | first)
}

def get-username-by-alias [alias: string@get-server-aliases, username: string = ""] {
  if ($username | is-empty) {
    return (get-usernames-by-alias $alias | first)
  }
  return $username
}

def get-host-info [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  let username = get-username-by-alias $alias $username
  return {
    username: $username
    password: (get-password-by-alias $alias $username)
    hostname: (get-hostname-by-alias $alias)
  }
}

def get-shell-command [] {
  let mod = "~/.local/nu_base/mod.nu"
  let app = "~/.usr/local/bin/nu"
  let exec = $'exec ($app) -e "source ($mod)"'
  return $"test -f ($mod) && ($exec) || bash"
}

export def shell [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  let host = get-host-info $alias $username
  sshpass -p $host.password ssh -t $"($host.username)@($host.hostname)" (get-shell-command)
}

export def cmd [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  let host = get-host-info $alias $username
  commandline edit $"sshpass -p ($host.password) ssh -t ($host.username)@($host.hostname)"
}

def copy-key-to-host [host: record] {
  sshpass -p $host.password ssh-copy-id -f $"($host.username)@($host.hostname)"
}

def copy-files-to-host [host: record] {
  sshpass -p $host.password rsync --exclude .git --recursive --info=progress2 $env.NU_BASE_PATH $"($host.username)@($host.hostname):~/.local"
}

def exec-cmd-to-host [host: record, cmd: string] {
  sshpass -p $host.password ssh -t $"($host.username)@($host.hostname)" $cmd
}

export def copy-key [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  copy-key-to-host (get-host-info $alias $username)
}

export def copy-files [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  copy-files-to-host (get-host-info $alias $username)
}

export def exec-base [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  exec-cmd-to-host (get-host-info $alias $username) "bash ~/.local/nu_base/sh/base.sh"
}

export def setup [alias: string@get-server-aliases, username?: string@get-usernames-from-context] {
  let host = get-host-info $alias $username

  copy-key-to-host $host
  copy-files-to-host $host
  exec-cmd-to-host $host "bash ~/.local/nu_base/sh/base.sh"
}

export def jump [] {
  ssh -J freyrecorp@192.168.0.11 freyrecorp@192.168.0.200 -t (get-shell-command)
}
