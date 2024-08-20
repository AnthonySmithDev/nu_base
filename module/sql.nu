
export-env {
   $env.SQL_USER = 'root'
   $env.SQL_PASS = 'pass'
   $env.SQL_HOST = 'localhost'
   $env.SQL_PORT = 3306
   $env.SQL_NAME = 'example'
}

export def dsn [dbname: bool = false] {
  let name = if $dbname { $env.SQL_NAME } else { "" }
  {
    "scheme": "mysql",
    "username": $env.SQL_USER,
    "password": $env.SQL_PASS,
    "host": $env.SQL_HOST,
    "port": $env.SQL_PORT,
    "path": $name,
  } | url join
}

export def u_query [ dsn: string, query: string, --csv ] {
  mut args = [
    "--command" $query
    "--quiet"
  ]
  if $csv {
    $args = ($args | append "--csv")
  }
  let complete = (usql $dsn ...$args | complete)
  if $complete.exit_code == 1 {
    let stderr = ($complete.stderr | str trim)
    error make -u { msg: $stderr }
  }
  let stdout = ($complete.stdout | str trim)
  if $stdout =~ "INSERT" {
    return { status: "OK" }
  }
  if $csv {
    return ($complete.stdout | from csv)
  }
  return $complete.stdout
}

export def m_query [ dsn: string, query: string, --csv ] {
  mut args = [
    "--execute" $query
  ]
  if $csv {
    $args = ($args | append "--csv")
  }
  return (mycli $dsn ...$args | from csv)
}

export def query [...query: string, --dbname(-n), --confirm(-c)] {
  let query = ($query | str join ' ') + "\n\n"

  if $confirm {
    print ""
    $query | bat -pp -l sql

    do { gum confirm  "Are you sure to run this query?"}
    if ($env.LAST_EXIT_CODE == 0) {
      u_query --csv (dsn $dbname) $query
    }
  } else {
    u_query --csv (dsn $dbname) $query
  }
}

export def show-databases [] {
  query SHOW DATABASES | values | first
}

export def create-database [name: string] {
  query CREATE DATABASE $name
}

export def drop-database [name: string@show-databases] {
  query -c DROP DATABASE $name
}

export def truncate-database [name: string@show-databases] {
  query -c -n (show-tables | each {|e| $"TRUNCATE TABLE ($e);"} | to text)
}

export def show-tables [] {
  query -n SHOW TABLES | values | first
}

export def drop-table [...tables: string@show-tables] {
  mut query = []
  for $table in $tables {
    $query = ($query | append $"DROP TABLE ($table);")
  }
  query -c -n ($query | str join "\n")
}

export def truncate-table [...tables: string@show-tables] {
  mut query = []
  for $table in $tables {
    $query = ($query | append $"TRUNCATE TABLE ($table);")
  }
  query -c -n ($query | str join "\n")
}

export def show-columns [table: string@show-tables] {
  query -n SHOW COLUMNS FROM $table
}

export def show-indexes [table: string@show-tables] {
  query -n SHOW INDEXES FROM $table
}

export def fields [table: string@show-tables] {
  show-columns $table | get field
}

export def from [table: string@show-tables] {
  query -n SELECT * FROM $table
}

export def sanitization [] {
  each {|it|
    match ($it | describe) {
      "string" => $"'($it)'"
      "nothing" => "DEFAULT"
      "int" => $it
      "float" => $it
      "bool" => ($it | into string | str upcase)
    }
  }
}

export def to-column [data: list] {
  $"\( ($data | each {|it| $'`($it)`'} | str join ', ') \)"
}

export def to-row [data: list] {
  $"\( ($data | sanitization | str join ', ') \)"
}

export def insert [table: string@show-tables, data: record] {
  let columns = to-column ($data | columns)
  let values = to-row ($data | values)

  query -n $"INSERT INTO ($table) ($columns) VALUES ($values)"
}

export def copy [src: string, dst: string, table: string] {
  print "copy"
}

def names [] {
  fd -e sql | lines
}

export def file [name: string@names] {
  query -n (open $name)
}

export def live [name: string@names] {
  watch . --glob=**/*.sql {||
    clear
    bat $name -P -l sql
    query -n (open $name) | to json | bat -P -l json
  }
}

export def context [...tables: string@show-tables] {
   mut text = "MySQL Database: \n\n"
   for table in $tables {
      let desc = (u_query (dsn true) $"SHOW COLUMNS FROM ($table)")
      let result = (["\n", "Table: ", $table, "\n" $desc] | str join)
      $text = ($text ++ $result)
   }
   return $text
}

export def usql_copy [] {
  let src = "mysql://root:payzum_password@100.97.221.20:3307/payzum"
  let dst = "mysql://root:payzum_password@100.72.33.76:3307/payzum"
  let query = "'SELECT * FROM orden'"
  let table = "orden"
  usql -c $'\copy ($src) ($dst) ($query) ($table)'
}
