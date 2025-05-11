
export def ssh-path [ip: string, dir: string = '/root'] {
  return $'root@($ip):($dir)'
}

export def install [ip: string] {
  let server = ssh-path $ip /usr/local/bin/
  let bin = (^ssh root@($ip) ls /usr/local/bin/ | lines)

  if ('nu' not-in $bin) {
    scp (nushell) $server
  }
  if ('bore' not-in $bin) {
    scp (bore) $server
  }
  if ('btm' not-in $bin) {
    scp (btm) $server
  }
  if ('pueued' not-in $bin) {
    scp (pueued) $server
  }
  if ('pueue' not-in $bin) {
    scp (pueue) $server
  }
}

const GROUP = 'tunnel'

export def --wrapped 'bg run' [...cmd] {
  if (ps | where name =~ pueued | is-empty) {
    ^pueued -d
  }
  let groups = (^pueue group --json | from json | columns)
  if ($GROUP not-in $groups) {
    ^pueue group add $GROUP
  }
  ^pueue add --group $GROUP -- ...$cmd
}

export def --wrapped 'bg ls' [...cmd] {
  if (ps | where name =~ pueued | is-empty) {
    ^pueued -d
  }
  let groups = (^pueue group --json | from json | columns)
  if ($GROUP not-in $groups) {
    ^pueue group add $GROUP
  }
  ^pueue status --group $GROUP
}

# ^pueue status -g my -j | from json | get tasks | columns

def nushell [] {
  let dst = ($env.HOME | path join Downloads nu)
  wget --quiet --show-progress https://github.com/nushell/nushell/releases/download/0.100.0/nu-0.100.0-x86_64-unknown-linux-musl.tar.gz
  tar -xf nu-0.100.0-x86_64-unknown-linux-musl.tar.gz
  rm -rf nu-0.100.0-x86_64-unknown-linux-musl.tar.gz
  mv nu-0.100.0-x86_64-unknown-linux-musl/nu $dst
  rm -rf nu-0.100.0-x86_64-unknown-linux-musl
  return $dst
}

def zellij [] {
  let dst = ($env.HOME | path join Downloads zellij)
  wget --quiet --show-progress https://github.com/zellij-org/zellij/releases/download/v0.41.1/zellij-x86_64-unknown-linux-musl.tar.gz
  tar -xf zellij-x86_64-unknown-linux-musl.tar.gz
  rm zellij-x86_64-unknown-linux-musl.tar.gz
  mv zellij $dst
  return $dst
}

def bore [] {
  let dst = ($env.HOME | path join Downloads bore)
  wget --quiet --show-progress https://github.com/ekzhang/bore/releases/download/v0.5.1/bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz
  tar -xf bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz
  rm bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz
  mv bore $dst
  return $dst
}

def btm [] {
  let dst = ($env.HOME | path join Downloads btm)
  wget --quiet --show-progress https://github.com/ClementTsang/bottom/releases/download/0.10.2/bottom_x86_64-unknown-linux-musl.tar.gz
  mkdir bottom_x86_64-unknown-linux-musl
  tar -xf bottom_x86_64-unknown-linux-musl.tar.gz -C bottom_x86_64-unknown-linux-musl
  rm -rf bottom_x86_64-unknown-linux-musl.tar.gz
  mv bottom_x86_64-unknown-linux-musl/btm $dst
  rm -rf bottom_x86_64-unknown-linux-musl
  return $dst
}

def pueue [] {
  let dst = ($env.HOME | path join Downloads pueue)
  wget --quiet --show-progress https://github.com/Nukesor/pueue/releases/download/v3.4.1/pueue-linux-x86_64 -O pueue
  chmod 777 pueue
  mv pueue $dst
  return $dst
}

def pueued [] {
  let dst = ($env.HOME | path join Downloads pueued)
  wget --quiet --show-progress https://github.com/Nukesor/pueue/releases/download/v3.4.1/pueued-linux-x86_64 -O pueued
  chmod 777 pueued
  mv pueued $dst
  return $dst
}

export def immich [ ip: string, --force ] {
  let immich = ($env.HOME | path join immich-app)
  mkdir $immich

  let docker = ($immich | path join docker-compose.yml)
  let enviroment = ($immich | path join .env)
  let ml = ($immich | path join hwaccel.ml.yml)
  let transcoding = ($immich | path join hwaccel.transcoding.yml)

  if $force or ($docker | path-not-exists) {
    https download https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml -o $docker
  }
  if $force or ($enviroment | path-not-exists) {
    https download https://github.com/immich-app/immich/releases/latest/download/example.env -o $enviroment
  }
  if $force or ($ml | path-not-exists) {
    https download https://github.com/immich-app/immich/releases/latest/download/hwaccel.ml.yml -o $ml
  }
  if $force or ($transcoding | path-not-exists) {
    https download https://github.com/immich-app/immich/releases/latest/download/hwaccel.transcoding.yml -o $transcoding
  }

  let server = ssh-path $ip /root/immich-app
  scp -r $immich $server
}
