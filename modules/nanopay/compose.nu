
def 'nu-complete categories' [] {
  [backend frontend]
}

def 'nu-complete services' [context: string] {
  let category = ($context | split words | get 2)
  match $category {
      "backend" => {
        (open $env.BACKEND_COMPOSE | get services | transpose key value | get key)
      }
      "frontend" => {
        (open $env.FRONTEND_COMPOSE | get services | transpose key value | get key)
      }
  }
}

def --wrapped compose [category: string@'nu-complete categories', ...args] {
  match $category {
    "backend" => {
      docker compose --env-file $env.CONFIG_ENV --env-file $env.DATABASE_ENV --file $env.BACKEND_COMPOSE ...$args
    },
    "frontend" => {
      docker compose --env-file $env.CONFIG_ENV --file $env.FRONTEND_COMPOSE ...$args
    },
  }
}

export def up [category: string@'nu-complete categories', ...name: string@'nu-complete services'] {
  compose $category up -d ...$name
}

export def down [category: string@'nu-complete categories', ...name: string@'nu-complete services'] {
  compose $category down ...$name
}

export def rm [category: string@'nu-complete categories'] {
  compose $category down --volumes
}

export def restart [category: string@'nu-complete categories', ...name: string@'nu-complete services'] {
  compose $category restart ...$name
}

export def logs [category: string@'nu-complete categories', ...name: string@'nu-complete services'] {
  let args = if ($name | is-empty) { [] } else { [--no-log-prefix] }
  compose $category logs -f ...$args ...$name
}

export def toggle [category: string@'nu-complete categories', name?: string@'nu-complete services'] {
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
