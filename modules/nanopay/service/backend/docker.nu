
def 'nu-complete services' [] {
  open $env.BACKEND_COMPOSE | get services | transpose key value | get key
}

def --wrapped compose [...args] {
  docker compose --env-file $env.CONFIG_ENV --env-file $env.DATABASE_ENV --file $env.BACKEND_COMPOSE ...$args
}

export def up [...name: string@'nu-complete services'] {
  compose up -d ...$name
}

export def down [...name: string@'nu-complete services'] {
  compose down ...$name
}

export def rm [] {
  compose down --volumes
}

export def restart [...name: string@'nu-complete services'] {
  compose restart ...$name
}

export def logs [...name: string@'nu-complete services'] {
  let args = if ($name | is-empty) { [] } else { [--no-log-prefix] }
  compose logs -f ...$args ...$name
}

export def toggle [name?: string@'nu-complete services'] {
  if ($name | is-empty) {
    return
  }
  
  let service = $"nanopay-backend-($name)"
  let ps = (docker ps | from ssv -a | where NAMES =~ $service)
  
  if ($ps | is-empty) {
    print $'(ansi green_bold)Up(ansi reset)'
    up $name
  } else {
    print $'(ansi red_bold)Down(ansi reset)'
    down $name
  }
}

export def "exec insert" [] {
  let names = [
    'nanopay-backend-user'
    'nanopay-backend-admin'
    'nanopay-backend-p2p'
    'nanopay-backend-nanod'
    'nanopay-backend-bitcoind'
  ]
  
  for $name in $names {
    docker exec -it $name go run ./cmd/app db insert
  }
}

export def "exec index" [] {
  docker exec -it "nanopay-backend-user" go run ./cmd/app db index
}
