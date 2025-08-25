
export-env {
  $env.MONGO_ADMIN = true
  $env.MONGO_FILE = ($env.HOME | path join .mongo.js)
}

export def 'admin uri' [] {
  $'mongodb://($env.MONGO_ROOT_USER):($env.MONGO_ROOT_PASS)@($env.MONGO_HOST):($env.MONGO_PORT)/($env.MONGO_NAME)'
}

export def 'user uri' [] {
  $'mongodb://($env.MONGO_USER):($env.MONGO_PASS)@($env.MONGO_HOST):($env.MONGO_PORT)/($env.MONGO_NAME)'
}

export def cli [] {
  if $env.MONGO_ADMIN {
    mongosh --quiet --authenticationDatabase admin (admin uri)
  } else {
    mongosh --quiet (user uri)
  }
}

export def run [] {
  let path = mktemp -t --suffix .js
  cp --force $env.MONGO_FILE $path
  hx $path
  eval (open $path)
}

export def eval [ eval: string, json: bool = true ] {
  $eval | save --force $env.MONGO_FILE
  mut args = [--eval $eval]
  if $json {
    $args = ($args | append [--json])
  }
  if $env.MONGO_ADMIN {
    $args = ($args | append [--authenticationDatabase admin (admin uri)])
  } else {
    $args = ($args | append [(user uri)])
  }
  let complete = (mongosh --quiet ...$args | complete)
  if $complete.exit_code != 0 {
    error make -u { msg: $complete.stderr }
  }
  if $json {
    $complete.stdout | from json
  } else {
    $complete.stdout
  }
}

export def file [ filename: string ] {
  eval (open $filename)
}

export def --env toggle [] {
  $env.MONGO_ADMIN = (not $env.MONGO_ADMIN)
}

def confirm [] {
  try {
    gum confirm "Are you sure to run this query?"
    return true
  } catch {
    return false
  }
}

export def 'user create' [] {
  let record = {
    user: "payzum_user",
    pwd:  "payzum_pass",
    roles: [ { role: "readWrite", db: "payzum" } ]
  }
  eval $"db.createUser\( ($record | to json) )"
}

export def 'show users' [] {
  eval "show users" | get value.user
}

export def 'db show' [] {
  eval "show databases" | get value.name
}

export def 'db drop' [ name: string@'db show', --yes(-y) ] {
  if $yes or (confirm) {
    eval "db.dropDatabase()"
  }
}

export def 'coll show' [] {
  eval "show collections" | get value.name
}

export def 'coll create' [ name: string ] {
  eval $"db.createCollection\('($name)')"
}

export def 'coll insertOne' [ name: string@'coll show', document: record ] {
  eval $"db.($name).insertOne\( ($document | to json) )"
}

export def 'coll insertMany' [ name: string@'coll show', document: list ] {
  eval $"db.($name).insertMany\( ($document | to json) )"
}

export def 'coll find' [ name: string@'coll show', filter: record = {}, --skip: int = 0, --limit: int = 1000 ] {
  eval $"db.($name).find\( ($filter | to json) ).skip\(($skip)).limit\(($limit)).toArray\()"
}

export def 'coll drop' [ ...names: string@'coll show', --yes(-y) ] {
  mut lines = []
  for $name in $names {
    $lines = ($lines | append $"db.($name).drop\()" )
  }
  if $yes or (confirm) {
    eval ($lines | to text)
  }
}

export def 'coll deleteMany' [ name: string@'coll show', filter: record = {}, --yes(-y) ] {
  if $yes or (confirm) {
    eval $"db.($name).deleteMany\( ($filter | to json) )"
  }
}

export def 'coll updateMany' [ name: string@'coll show', filter: record, document: record, --yes(-y) ] {
  if $yes or (confirm) {
    eval $"db.($name).updateMany\( ($filter | to json) , { $set: ($document | to json) })"
  }
}

export def 'coll count' [ name: string@'coll show', filter: record = {} ] {
  eval $"db.($name).countDocuments\( ($filter | to json) )" false | into int
}

export def 'coll watch' [ name: string@'coll show', filter: record = {}, --sleep(-s): duration = 3sec, --enter(-e) ] {
  mut docs_count = coll count $name $filter
  mut loop_count = 0

  loop {
    let docs = coll find $name $filter --skip $docs_count
    if ($docs | is-not-empty) {
      clear
      print $' (ansi green_bold)($loop_count)(ansi reset) (date now | format date "%Y-%m-%d %I:%M:%S %p")'

      $loop_count += 1
      $docs_count += ($docs | length)

      mut show_help = true

      for $doc in $docs {
        print ($doc | table --expand)
        if ($docs | length) > 1 and $enter {
          if $show_help {
            print "Enter to show next:"
            $show_help = false
          }
          loop {
            let input = input listen --types [key]
            if $input.code == "enter" {
              break
            }
          }
        } else {
          sleep 1sec
        }
      }
    }
    sleep $sleep
  }
}
