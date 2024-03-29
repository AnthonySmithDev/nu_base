
export def servers [] {
  [
    {
      alias: 'R2'
      user: 'anthony'
      pass: '40149616'
      host: {
        local: '192.168.0.141'
        tailscale: '100.77.231.27'
      }
      hostname: 'r2'
      private: true
    }
    {
      alias: 'S1'
      user: 'freyrecorp'
      pass: '40149616'
      host: {
        local: '192.168.0.11'
        tailscale: '100.93.208.5'
      }
      hostname: 'hansolo'
      private: false
    }
    {
      alias: 'S2'
      user: 'freyrecorp'
      pass: '40149616'
      host: {
        local: '192.168.0.12'
        tailscale: '100.122.65.125'
      }
      hostname: 'darthvader'
      private: false
    }
    {
      alias: 'S3'
      user: 'freyrecorp'
      pass: '40149616'
      host: {
        local: '192.168.0.13'
        tailscale: '100.93.5.38'
      }
      hostname: 'yoda'
      private: false
    }
    {
      alias: 'S4'
      user: 'freyrecorp'
      pass: '40149616'
      host: {
        local: '192.168.0.14'
        tailscale: '100.98.177.106'
      }
      hostname: 'kenobi'
      private: false
    }
  ]
}

export def list-server [] {
  servers | get alias
}

export def get_server [alias: string@'list-server'] {
  servers | where alias == $alias | first
}

export def get_dest [server: record, path?: string] {
  if $path != null {
    return $'($server.user)@($server.hostname):($path)'
  }
  return $'($server.user)@($server.hostname)'
}

export def 'key copy' [alias: string@'list-server'] {
  let server = (get_server $alias)
  sshpass -p $server.pass ssh-copy-id (get_dest $server)
}

export def sync [alias: string@'list-server'] {
  let server = (get_server $alias)

  rsync --exclude '.git' -q -r $env.REPO_PATH (get_dest $server ~/.local)

  if $server.private {
    ssh -t (get_dest $server) 'cp ~/.local/nu_base/bash/remote/profile.sh ~/.profile'
    ssh -t (get_dest $server) 'cp ~/.local/nu_base/bash/remote/profile.sh ~/.source.nu'
  }
}

export def install [alias: string@'list-server'] {
  let server = (get_server $alias)

  ssh -t (get_dest $server) 'bash ~/.local/nu_base/bash/download.sh'
  ssh -t (get_dest $server) '~/.local/bin/nu ~/.local/nu_base/bash/script.nu --remote'
}

export def shell [alias: string@'list-server'] {
  let server = (get_server $alias)

  if $server.private {
    ssh -t (get_dest $server)
  } else {
    ssh -t (get_dest $server) 'exec ~/.local/bin/nu -e "source .local/nu_base/source.nu"'
  }
}

export def copy [alias: string@'list-server', src: string, dest: string] {
  let server = (get_server $alias)
  scp $src (get_dest $server $dest)
}
