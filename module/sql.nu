
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

export def u_query [ query: string, dbname: bool = false ] {
  let complete = (usql (dsn $dbname) -q -C -c $query | complete)
  if $complete.exit_code == 1 {
    let stderr = ($complete.stderr | str trim)
    error make -u { msg: $stderr }
  }
  let stdout = ($complete.stdout | str trim)
  if $stdout =~ "INSERT" {
    return { status: "OK" }
  }
  return ($complete.stdout | from csv)
}

export def m_query [ query: string, dbname: bool = false ] {
  mycli (dsn $dbname) --csv -e $query | from csv
}

export def query [...query: string, --dbname(-n), --confirm(-c)] {
  let query = ($query | str join ' ')

  if $confirm {
    print ""
    $query | bat -pp -l sql

    do { gum confirm  "Are you sure to run this query?"}
    if ($env.LAST_EXIT_CODE == 0) {
      u_query $query $dbname
    }
  } else {
    u_query $query $dbname
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

export def drop-table [table: string@show-tables] {
  query -c -n DROP TABLE $table
}

export def truncate-table [table: string@show-tables] {
  query -c -n TRUNCATE TABLE $table
}

export def show-columns [table: string@show-tables] {
  query -n SHOW COLUMNS FROM $table
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

export def insert [table: string@show-tables, data: record] {
  let columns = ($data | columns | each {|it| $"`($it)`"} | str join ", ")
  let values = ($data | values | sanitization | str join ", ")

  query -n $"INSERT INTO ($table) \( ($columns) \) VALUES \( ($values) \)"
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
      let desc = (show-columns $table | table -t markdown)
      let result = (["Table: ", $table, "\n" $desc] | str join)
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
