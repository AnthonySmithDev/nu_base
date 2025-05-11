const dsn = "mysql://payzum_user:payzum_password@0.0.0.0:3307/payzum"

export def main [table: string] {
  let args = [
    --language sql
    --color always
    --plain
  ]
  usql $dsn -q -c $'describe ($table)' | bat ...$args
}
