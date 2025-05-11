
export-env {
  $env.IMMICH_DIR = ($env.HOME | path join immich-app)
}

def disks [] {
  [B3 B2 B1]
}

export def --env disk [disk: string@disks] {
  $env.IMMICH_DIR = ('/media/anthony' | path join $disk immich-app)
}

export def --env set [dir: string] {
  $env.IMMICH_DIR = ($env.PWD | path join $dir)
}

def dir [path?: string] {
  if ($path | is-not-empty) { $env.PWD | path join $path } else { $env.IMMICH_DIR }
}

def file [path?: string] {
  return (dir $path | path join docker-compose.yml)
}

export def download [ --path(-p): string, --force ] {
  let dir = dir $path

  mkdir $dir

  let docker = ($dir | path join docker-compose.yml)
  let enviroment = ($dir | path join .env)
  let ml = ($dir | path join hwaccel.ml.yml)
  let transcoding = ($dir | path join hwaccel.transcoding.yml)

  if $force or ($docker | path-not-exists) {
    http download https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml -o $docker
  }
  if $force or ($enviroment | path-not-exists) {
    http download https://github.com/immich-app/immich/releases/latest/download/example.env -o $enviroment
  }
  if $force or ($ml | path-not-exists) {
    http download https://github.com/immich-app/immich/releases/latest/download/hwaccel.ml.yml -o $ml
  }
  if $force or ($transcoding | path-not-exists) {
    http download https://github.com/immich-app/immich/releases/latest/download/hwaccel.transcoding.yml -o $transcoding
  }
}

export def ps [ --path(-p): string ] {
  let compose = file $path
  if ($compose | path exists) {
    docker compose --file $compose ps | from ssv
  }
}

def all-services [ --path(-p): string ] {
  let compose = file $path
  if ($compose | path exists) {
    open $compose | get services | columns
  }
}

def active-services [] {
  ps | get name
}

export def up [ --path(-p): string, ...services: string@all-services ] {
  let compose = file $path
  if ($compose | path exists) {
    docker compose --file $compose up -d ...$services
  }
}

export def down [ --path(-p): string, ...services: string@active-services ] {
  let compose = file $path
  if ($compose | path exists) {
    docker compose --file $compose down ...$services
  }
}

export def logs [ --path(-p): string, ...services: string@active-services ] {
  let compose = file $path
  if ($compose | path exists) {
    docker logs --follow ...$services
  }
}

export def pull [ --path(-p): string, ...services: string@all-services ] {
  let compose = file $path
  if ($compose | path exists) {
    docker compose --file $compose pull
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
    let version = ($env.IMMICH_VERSION? | default "release")
    let args = [
      --name immich_machine_learning
      --volume model-cache:/cache
      --publish 3003:3003
      --restart always
      --gpus all
      --env MACHINE_LEARNING_DEVICE_IDS="1,2"
      --env MACHINE_LEARNING_WORKERS=5
      $"ghcr.io/immich-app/immich-machine-learning:($version)-cuda"
    ]
    docker run -d ...$args
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
  sudo rclone sync --progress --metadata --fast-list --create-empty-src-dirs $src $dst
}