
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

export def eval [ eval: string ] {
  $eval | save --force $env.MONGO_FILE
  if $env.MONGO_ADMIN {
    mongosh --quiet --json --eval $eval --authenticationDatabase admin (admin uri) | from json
  } else {
    mongosh --quiet --json --eval $eval (user uri) | from json
  }
}

export def file [ filename: string ] {
  eval (open $filename)
}

export def --env toggle [] {
  $env.MONGO_ADMIN = (not $env.MONGO_ADMIN)
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

export def 'db drop' [ name: string@'db show' ] {
  eval "db.dropDatabase()"
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

export def 'coll drop' [ name: string@'coll show' ] {
  eval $"db.($name).drop\()"
}

export def 'coll deleteMany' [ name: string@'coll show', filter: record = {} ] {
  eval $"db.($name).deleteMany\( ($filter | to json) )"
}

export def 'coll updateMany' [ name: string@'coll show', filter: record, document: record ] {
  eval $"db.($name).updateMany\( ($filter | to json) , { $set: ($document | to json) })"
}
