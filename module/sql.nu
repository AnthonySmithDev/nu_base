
export-env {
   $env.SQL_USER = ''
   $env.SQL_PASS = ''
   $env.SQL_HOST = ''
   $env.SQL_PORT = ''
   $env.SQL_NAME = ''
}

export def dsn [] {
  $'mysql://($env.SQL_USER):($env.SQL_PASS)@($env.SQL_HOST):($env.SQL_PORT)/($env.SQL_NAME)'
}

export def u_query_raw [...query: string] {
  usql (dsn) -q -c ($query | str join ' ')
}

export def u_query_csv [...query: string] {
  usql (dsn) -q -C -c ($query | str join ' ') | from csv
}

export def m_query_raw [...query: string] {
  mycli (dsn) -e ($query | str join ' ')
}

export def m_query_csv [...query: string] {
  mycli (dsn) --csv -e ($query | str join ' ') | from csv
}

export def query [...query: string] {
  u_query_csv ($query | str join ' ')
}

export def show_databases [] {
  query 'SHOW DATABASES' | values | first
}

export def create_database [name: string] {
  query $'CREATE DATABASE ($name)'
}

export def drop_database [name: string] {
  query $'DROP DATABASE ($name)'
}

export def show_tables [] {
  query 'SHOW TABLES' | values | first
}

export def drop_table [table: string@show_tables] {
  query $'DROP TABLE ($table)'
}

export def truncate_table [table: string@show_tables] {
  query $'TRUNCATE TABLE ($table)'
}

export def from [table: string@show_tables] {
  query $'SELECT * FROM ($table)'
}

export def describe [table: string@show_tables] {
  query $'DESCRIBE ($table)'
}

export def fields [table: string@show_tables] {
  describe $table | get field
}

def names [] {
  fd -e sql | lines
}

export def file [name: string@names] {
  query (open $name)
}

export def live [name: string@names] {
  watch . --glob=**/*.sql {||
    clear
    bat $name -P -l sql
    query (open $name) | to json | bat -P -l json
  }
}
