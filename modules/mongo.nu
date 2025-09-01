
export-env {
  $env.MONGO_ADMIN = true
  $env.MONGO_DIR = ($env.HOME | path join .mongo)
  $env.MONGO_DB_DIR = ($env.MONGO_DIR | path join db)
  $env.MONGO_QUERY_FILE = ($env.MONGO_DIR | path join query.js)
  $env.MONGO_CONN_CONFIG = ($env.MONGO_DIR | path join conn_config.json)
  $env.MONGO_CONN_CURRENT = ($env.MONGO_DIR | path join conn_current.txt)
}

def config-uri [config: record, db_name: string = ""] {
  if $env.MONGO_ADMIN {
    $"mongodb://($config.root_user):($config.root_pass)@($config.host):($config.port)/($db_name)"
  } else {
    $"mongodb://($config.user):($config.pass)@($config.host):($config.port)/($db_name)"
  }
}

def complete_conn [] {
  if not ($env.MONGO_CONN_CONFIG | path exists) {
    return []
  }
  open $env.MONGO_CONN_CONFIG | transpose conn config | each {|row|
    { value: $row.conn, description: (config-uri $row.config) }
  }
}

export def "conn set" [conn?: string@complete_conn] {
  mkdir $env.MONGO_DB_DIR
  if not ($env.MONGO_CONN_CONFIG | path exists) {
    error make -u {msg: $"MongoDB connection config file not found at: ($env.MONGO_CONN_CONFIG)"}
  }
  let current = if ($conn != null) { $conn } else {
    open $env.MONGO_CONN_CONFIG | columns | to text | gum choose
  }
  if ($current | is-not-empty) {
    $current | save --force $env.MONGO_CONN_CURRENT
  }
}

def conn_config [] {
  let conn_config = open $env.MONGO_CONN_CONFIG
  let conn_current = open $env.MONGO_CONN_CURRENT
  $conn_config | get $conn_current
}

def conn_hash_path [config: record] {
  let db_hash = (config-uri $config | hash md5)
  $env.MONGO_DB_DIR | path join $db_hash
}

export def "conn get" [] {
  if not ($env.MONGO_CONN_CONFIG | path exists) {
    error make -u {msg: $"MongoDB connection config file not found at: ($env.MONGO_CONN_CONFIG)"}
  }
  if not ($env.MONGO_CONN_CURRENT | path exists) {
    conn set
  }

  let conn_config = conn_config
  let conn_hash_path = conn_hash_path $conn_config
  let db_name = if ($conn_hash_path | path exists) { open $conn_hash_path  } else { $conn_config.db_name }

  config-uri $conn_config $db_name
}

export def cli [] {
  mut args = []
  if $env.MONGO_ADMIN {
    $args = ($args | append [--authenticationDatabase admin])
  }
  mongosh --quiet ...$args (conn get)
}

export def eval [ eval: string, json: bool = true ] {
  $eval | save --force $env.MONGO_QUERY_FILE

  mut args = [--eval $eval]
  if $json {
    $args = ($args | append [--json])
  }
  if $env.MONGO_ADMIN {
    $args = ($args | append [--authenticationDatabase admin])
  }

  let conn_uri = conn get
  let complete = (mongosh --quiet ...$args $conn_uri | complete)
  if $complete.exit_code != 0 {
    error make -u { msg: $complete.stderr }
  }
  if $json {
    $complete.stdout | from json
  } else {
    $complete.stdout
  }
}

export def run [] {
  let path = mktemp -t --suffix .js
  cp --force $env.MONGO_QUERY_FILE $path
  hx $path
  eval (open $path)
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
    user: "test_user",
    pwd:  "test_pass",
    roles: [ { role: "readWrite", db: "test_role" } ]
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

export def 'db get' [] {
  let conn_config = conn_config
  let conn_hash_path = conn_hash_path $conn_config
  if ($conn_hash_path | path exists) {
    open $conn_hash_path
  }
}

export def 'db set' [ db_name: string@'db show' ] {
  let conn_config = conn_config
  let conn_hash_path = conn_hash_path $conn_config
  $db_name | save --force $conn_hash_path
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

export def 'coll find' [ name: string@'coll show', filter: record = {}, --skip(-s): int = 0, --limit(-l): int = 1000 ] {
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

export def query [ name: string@'coll show', filter: record = {}, --skip(-s): int = 0, --limit(-l): int = 1000, --delete(-d), --yes(-y) ] {
  if $delete {
    coll deleteMany $name $filter --yes=($yes)
  } else {
    coll find $name $filter --skip=($skip) --limit=($limit)
  }
}

export alias cs = conn set
export alias cg = conn get
export alias dg = db get
export alias ds = db set
