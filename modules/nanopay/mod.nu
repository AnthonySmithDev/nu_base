
export-env {
  $env.NANOPAY_DOCKER = ($env.NU_WORK_PATH | path join files/nanopay/docker)

  $env.NANOPAY_BACKEND = ($env.HOME | path join Documents/gitlab/nanopay/backend)
  $env.NANOPAY_FRONTEND = ($env.HOME | path join Documents/gitlab/nanopay/frontend)

  $env.CONFIG_ENV = ($env.NANOPAY_DOCKER | path join env/config.env)
  $env.DATABASE_ENV = ($env.NANOPAY_DOCKER | path join env/database.env)

  $env.DATABASE_COMPOSE = ($env.NANOPAY_DOCKER | path join compose/database/docker-compose.yml)
  $env.BACKEND_COMPOSE = ($env.NANOPAY_DOCKER | path join compose/backend_dev/docker-compose.yml)
  $env.FRONTEND_COMPOSE = ($env.NANOPAY_DOCKER | path join compose/frontend_dev/docker-compose.yml)
}

export use tool/okx.nu
export use tool/binance.nu

export use service/database
export use service/backend
export use service/frontend
export use service/kube.nu

export use mode.nu

def verify [] {
  if not (exists-external tailscale) {
    return "tailscale not found"
  }

  let complete = (tailscale status | complete)
  if ($complete.exit_code == 1) {
    return $complete.stderr
  }

  if not ($env.HOME | path join .ssh/id_ed25519.pub | path exists) {
    keygen restore
  }
}

def create_image [] {
  let name = "local/air"
  if (docker image ls | from ssv | where REPOSITORY =~ $name | is-empty) {
    docker build -t local/air:latest ($env.NANOPAY_DOCKER | path join air)
  }
}

def create_network [] {
  let name = "nanopay-network"
  if (docker network ls | from ssv | where NAME =~ $name | is-empty) {
    docker network create $name
  }
}

export def up [] {
  verify

  create_image
  create_network

  mkdir $env.NANOPAY_BACKEND
  mkdir $env.NANOPAY_FRONTEND

  backend git clone
  frontend git clone

  backend git zoxide
  frontend git zoxide

  database docker up
  backend docker up

  backend docker exec insert
  backend docker exec index

  frontend docker up
}

export def down [] {
  database docker down
  backend docker down
  frontend docker down
}

export def pull [] {
  backend git pull
  frontend git pull
}

export def nanopay-each [] {
  let nanopay = [
    'nanopay-backend-all'
    'nanopay-backend-main'
    'nanopay-backend-price'
    'nanopay-backend-upload'
    'nanopay-backend-out'
    'nanopay-backend-lnd'
    'nanopay-backend-nanod'
    'nanopay-backend-bitcoind'
    'nanopay-backend-payment'
    'nanopay-backend-p2p'
    'nanopay-backend-ws'
    'nanopay-backend-bot'
  ]

  for $name in ($nanopay) {
    cd ($env.HOME | path join Documents/gitlab/nanopay/backend | path join $name)

    git remote remove origin
    glab repo create --internal --group nanopay/backend --name $name

    git push --set-upstream origin --all
    git push --set-upstream origin --tags
  }
}
