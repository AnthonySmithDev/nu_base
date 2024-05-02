
export-env {
   $env.SQL_USER = ''
   $env.SQL_PASS = ''
   $env.SQL_HOST = ''
   $env.SQL_PORT = ''
   $env.SQL_NAME = ''
}

export def dsn [table: bool = false] {
  let path = if $table { $env.SQL_NAME } else { "" }
  {
    "scheme": "mysql",
    "username": $env.SQL_USER,
    "password": $env.SQL_PASS,
    "host": $env.SQL_HOST,
    "port": $env.SQL_PORT,
    "path": $path,
  } | url join
}

export def u_query [ query: string, table: bool = false ] {
  let complete = (usql (dsn $table) -q -C -c $query | complete)
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

export def m_query [ query: string, table: bool = false ] {
  mycli (dsn $table) --csv -e $query | from csv
}

export def query [...query: string, --table(-t)] {
  u_query ($query | str join ' ') $table
}

export def show_databases [] {
  query SHOW DATABASES | values | first
}

export def create_database [name: string] {
  query CREATE DATABASE $name
}

export def drop_database [name: string@show_databases] {
  query DROP DATABASE $name
}

export def show_tables [] {
  query -t SHOW TABLES | values | first
}

export def drop_table [table: string@show_tables] {
  query -t DROP TABLE $table
}

export def truncate_table [table: string@show_tables] {
  query -t TRUNCATE TABLE $table
}

export def show_columns [table: string@show_tables] {
  query -t SHOW COLUMNS FROM $table
}

export def from [table: string@show_tables] {
  query -t SELECT * FROM $table
}

def surround [] {
  each {|$e|
    if ($e | is-empty) {
      "NULL"
    } else if ($e | describe) == "string" {
      $"'($e)'"
    } else {
      $e
    }
  }
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

export def insert [table: string@show_tables, data: record] {
  let columns = ($data | columns | each {|it| $"`($it)`"} | str join ", ")
  let values = ($data | values | sanitization | str join ", ")

  query -t $"INSERT INTO ($table) \( ($columns) \) VALUES \( ($values) \)"
}

export def copy [src: string, dst: string, table: string] {
  print "copy"
}

export def fields [table: string@show_tables] {
  show_columns $table | get field
}

export def clean [name: string@show_databases] {
  query -t (show_tables | each {|e| $"TRUNCATE TABLE ($e);"} | to text) | null
}

def names [] {
  fd -e sql | lines
}

export def file [name: string@names] {
  query -t (open $name)
}

export def live [name: string@names] {
  watch . --glob=**/*.sql {||
    clear
    bat $name -P -l sql
    query -t (open $name) | to json | bat -P -l json
  }
}

export def context [...tables: string@show_tables] {
   mut text = "MySQL Database: \n\n"
   for table in $tables {
      let desc = (show_columns $table | table -t markdown)
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
