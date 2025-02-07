
def alias [] {
  $env.SSH_SERVERS | select alias desc | rename value description
}

def server-by-alias [alias: string] {
  $env.SSH_SERVERS | where alias == $alias | first
}

def user-names-by-alias [alias: string] {
  server-by-alias $alias | get user.name
}

def password-by-alias [alias: string, name: string] {
  server-by-alias $alias | get user | where name == $name | first | get pass
}

def hostname-by-alias [alias: string] {
  server-by-alias $alias | get hostname
}

def alias-user-names [context: string] {
  user-names-by-alias ($context | split words | last)
}

def username-by-alias [alias: string@alias, username?: string] {
  if ($username | is-empty) {
    return (user-names-by-alias $alias | first)
  }
  return $username
}

def cmd-shell [] {
  let mod = "~/.local/nu_base/mod.nu"
  let app = "~/.usr/local/bin/nu"
  let exec = $'exec ($app) -e "source ($mod)"'
  return $"test -f ($mod) && ($exec) || bash"
}

export def shell [alias: string@alias, username?: string@alias-user-names] {
  let username = username-by-alias $alias $username
  let password = password-by-alias $alias $username
  let hostname = hostname-by-alias $alias

  sshpass -p $password ssh -t $"($username)@($hostname)" (cmd-shell)
}

export def ssh [alias: string@alias, username?: string@alias-user-names] {
  let username = username-by-alias $alias $username
  let password = password-by-alias $alias $username
  let hostname = hostname-by-alias $alias

  commandline edit $"sshpass -p ($password) ssh -t ($username)@($hostname)"
}

export def setup [alias: string@alias, username?: string@alias-user-names] {
  let username = username-by-alias $alias $username
  let password = password-by-alias $alias $username
  let hostname = hostname-by-alias $alias

  sshpass -p $password ssh-copy-id -f $"($username)@($hostname)"
  sshpass -p $password rsync --exclude .git --recursive --info=progress2 $env.NU_BASE_PATH $"($username)@($hostname):~/.local"
  sshpass -p $password ssh -t $"($username)@($hostname)" "bash ~/.local/nu_base/sh/base.sh"
}
