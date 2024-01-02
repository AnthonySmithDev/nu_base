
export def servers [] {
  [
    {
      alias: 'R2'
      user: 'anthony'
      pass: '40149616'
      host: '192.168.0.141'
      private: true
    }
    {
      alias: 'S1'
      user: 'freyrecorp'
      pass: '40149616'
      host: '192.168.0.11'
      private: false
    }
    {
      alias: 'S2'
      user: 'freyrecorp'
      pass: '40149616'
      host: '192.168.0.12'
      private: false
    }
    {
      alias: 'S3'
      user: 'freyrecorp'
      pass: '40149616'
      host: '192.168.0.13'
      private: false
    }
  ]
}

export def list-server [] {
  servers | get alias
}

export def get-server [alias: string@'list-server'] {
  servers | where alias == $alias | first
}

export def 'key create' [] {
  ssh-keygen -t ed25519 -C 'anthonyasdeveloper@gmail.com'
}

export def 'key copy' [alias: string@'list-server'] {
  let server = (get-server $alias)

  ssh-copy-id $'($server.user)@($server.host)'
}

export def sync [alias: string@'list-server'] {
  let server = (get-server $alias)

  rsync --exclude '.git' -q -r $env.REPO_PATH $'($server.user)@($server.host):~/.local'

  if $server.private {
    scp -q ~/nushell/nu_base/bash/remote/profile.sh $'($server.user)@($server.host):~/.profile'
    scp -q ~/nushell/nu_base/bash/remote/source.nu $'($server.user)@($server.host):~/.source.nu'
  }
}

export def install [alias: string@'list-server'] {
  let server = (get-server $alias)

  ssh -t $'($server.user)@($server.host)' 'bash .local/nu_base/bash/nushell.sh --remote'
}

export def shell [alias: string@'list-server'] {
  let server = (get-server $alias)

  if $server.private {
    ssh -t $'($server.user)@($server.host)'
  } else {
    ssh -t $'($server.user)@($server.host)' 'exec .local/bin/nu -e "source .local/nu_base/source.nu"'
  }
}

export def copy [alias: string@'list-server', src: string, dest: string] {
  let server = (get-server $alias)
  scp $src $'($server.user)@($server.host):($dest)'
}
