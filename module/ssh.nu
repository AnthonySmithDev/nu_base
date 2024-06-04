
export-env {
  $env.SSH_SERVERS = [
    {
      alias: 'Alias'
      user: 'username'
      pass: 'password'
      desc: 'Description'
      host: {
        local: '192.168.0.1'
        tailscale: '100.77.231.27'
      }
      hostname: 'MyServer'
      private: true
    }
  ]
}

export def alias [] {
  $env.SSH_SERVERS | select alias desc | rename value description
}

export def server [alias: string@alias] {
  $env.SSH_SERVERS | where alias == $alias | first
}

export def keygen [keyfile: string = "~/.ssh/id_ed25519", --comment(-c): string = ""] {
  ssh-keygen -t ed25519 -f ($keyfile | path expand) -C $comment -N ""
}

export def host [server: record, path?: string] {
  if $path != null {
    return $'($server.user)@($server.hostname):($path)'
  }
  return $'($server.user)@($server.hostname)'
}

export def copy-id [alias: string@alias] {
  let server = (server $alias)
  sshpass -p $server.pass ssh-copy-id (host $server)
}

export def sync [alias: string@alias, --work(-w)] {
  let server = (server $alias)
  rsync --exclude '.git' -q -r $env.NU_BASE_PATH (host $server ~/.local)
  if $work {
    rsync -q -r $env.NU_WORK_PATH (host $server ~/.local)
  }
}

export def --wrapped exec [alias: string@alias, ...cmd: string] {
  let server = (server $alias)
  ssh -t (host $server) ...$cmd
}

export def install [alias: string@alias] {
  exec $alias 'bash ~/.local/nu_base/sh/base.sh'
}

export def shell [alias: string@alias] {
  exec $alias 'exec ~/.local/bin/nu -e "source ~/.local/nu_base/source.nu"'
}

export def copy [alias: string@alias, src: string, dest: string] {
  let server = (server $alias)
  scp $src (host $server $dest)
}

export def port-forward [remote_port: string, destination_address: string, local_port: string, username: string, ssh_server: string] {
  # ssh -R [remote_port]:[destination_address]:[local_port] [username]@[ssh_server]
  ssh -R $"($remote_port):($destination_address):($local_port) ($username)@($ssh_server)"
}

export def ollama [] {
  port-forward 11434 localhost 11434 anthony r2v2
}
