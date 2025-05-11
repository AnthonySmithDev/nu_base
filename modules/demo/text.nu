const dsn = "mysql://payzum_user:payzum_password@0.0.0.0:3307/payzum"

export def main [] {
  let tables = (usql $dsn -q -C -c "show tables" | lines | skip | to text | lines)

  for $table in $tables {
    mut text = (usql $dsn -q -c $'describe ($table)')
    $text | prepend $table | append "\n" | save -a tables.txt 
  }
}
