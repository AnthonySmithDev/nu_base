
export-env {
  $env.IMMICH_DIR = ($env.HOME | path join immich-app)
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
