
export-env {
  $env.IMMICH_DIR = ($env.HOME | path join immich-app)
  $env.IMMICH_COMPOSE = ($env.IMMICH_DIR | path join docker-compose.yml)
}

def disks [] {
  [B3 B2 B1]
}

export def --env set [disk: string@disks] {
  $env.IMMICH_DIR = ('/media/anthony' | path join $disk immich-app)
  $env.IMMICH_COMPOSE = ($env.IMMICH_DIR | path join docker-compose.yml)
}

export def download [ --force ] {
  mkdir $env.IMMICH_DIR

  let docker = ($env.IMMICH_DIR | path join docker-compose.yml)
  let enviroment = ($env.IMMICH_DIR | path join .env)
  let ml = ($env.IMMICH_DIR | path join hwaccel.ml.yml)
  let transcoding = ($env.IMMICH_DIR | path join hwaccel.transcoding.yml)

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
}

export def ps [] {
  if ($env.IMMICH_COMPOSE | path exists) {
    docker compose -f $env.IMMICH_COMPOSE ps | from ssv
  }
}

def all-services [] {
  open $env.IMMICH_COMPOSE | get services | columns
}

def active-services [] {
  ps | get name
}

export def up [ ...services: string@all-services ] {
  if ($env.IMMICH_COMPOSE | path exists) {
    docker compose -f $env.IMMICH_COMPOSE up -d ...$services
  }
}

export def down [ ...services: string@active-services ] {
  if ($env.IMMICH_COMPOSE | path exists) {
    docker compose -f $env.IMMICH_COMPOSE down ...$services
  }
}

export def logs [ ...services: string@active-services ] {
  if ($env.IMMICH_COMPOSE | path exists) {
    docker logs --follow ...$services
  }
}

export def pull [ ...services: string@all-services ] {
  if ($env.IMMICH_COMPOSE | path exists) {
    docker compose -f $env.IMMICH_COMPOSE pull
  }
}

def commands [] {
  [
    [value, description];
    [reset-admin-password, 'Reset the admin password']
    [enable-password-login, 'Enable password login']
    [disable-password-login, 'Disable password login']
    [enable-oauth-login, 'Enable OAuth login']
    [disable-oauth-login, 'Disable OAuth login']
    [list-users, 'List Immich users']
    [help, 'display help for command']
  ]
}

export def --wrapped admin [ command: string@commands, ...rest ] {
  if not (dock container exists immich_server) {
    docker exec -it immich_server immich-admin $command ...$rest
  }
}

export def machine_learning [] {
  if not (dock volume exists model-cache) {
    docker volume create model-cache
  }
  if not (dock container exists immich_machine_learning) {
    docker run -d --name immich_machine_learning -v model-cache:/cache --restart always -p 3003:3003 ghcr.io/immich-app/immich-machine-learning:release
  }
}

export def --wrapped upload [...rest] {
  let key = 'RX6AWkBzV9Gn4VFtej4TH3ky70OZVo2N0alkX3fA4'
  let url = 'http://localhost:2283'
  immich-go -server=($url) -key=($key) upload ...$rest
}

export def sync [src_disk: string@disks = 'B3', dst_disk: string@disks = 'B2'] {
  let src = $'/media/anthony/($src_disk)/immich-app'
  let dst = $'/media/anthony/($dst_disk)/immich-app'
  sudo rclone sync --progress --check-first --metadata --fast-list --create-empty-src-dirs -v $src $dst
}
