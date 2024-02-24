
export-env {
   $env.SQL_USER = ''
   $env.SQL_PASS = ''
   $env.SQL_HOST = ''
   $env.SQL_PORT = ''
   $env.SQL_NAME = ''
}

export def dsn [name: bool = false] {
  let path = if $name { $env.SQL_NAME } else { "" }
  {
    "scheme": "mysql",
    "username": $env.SQL_USER,
    "password": $env.SQL_PASS,
    "host": $env.SQL_HOST,
    "port": $env.SQL_PORT,
    "path": $path,
  } | url join
}

export def u_query [ query: string, name: bool = false ] {
  usql (dsn $name) -q -C -c $query | from csv
}

export def m_query [ query: string, name: bool = false ] {
  mycli (dsn $name) --csv -e $query | from csv
}

export def query [...query: string, --name(-n)] {
  u_query ($query | str join ' ') $name
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
  query -n SHOW TABLES | values | first
}

export def drop_table [table: string@show_tables] {
  query -n DROP TABLE $table
}

export def truncate_table [table: string@show_tables] {
  query -n TRUNCATE TABLE $table
}

export def from [table: string@show_tables] {
  query -n SELECT * FROM $table
}

export def describe [table: string@show_tables] {
  query -n DESCRIBE $table
}

export def fields [table: string@show_tables] {
  describe $table | get field
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
    query (open $name) | to json | bat -P -l json
  }
}

export def context [...tables: string@show_tables] {
   mut text = "MySQL Database: \n\n"
   for table in $tables {
      let desc = (describe $table | table -t markdown)
      let result = (["Table: ", $table, "\n" $desc] | str join)
      $text = ($text ++ $result)
   }
   return $text
}
