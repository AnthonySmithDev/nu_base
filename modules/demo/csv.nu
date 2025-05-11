const dsn = "mysql://payzum_user:payzum_password@0.0.0.0:3307/payzum"

export def main [] {
  let tables = (usql $dsn -q -C -c "show tables" | lines | skip | to text | lines)

  for $table in $tables {
    mut text = $"($table)\n\n" + (usql $dsn -q -C -c $'describe ($table)') + $"\n\n\n"
    $text | save -a "listo.txt"
  }
}
