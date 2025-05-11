const dsn = "mysql://payzum_user:payzum_password@0.0.0.0:3307/payzum"

export def main [table: string] {
  let query = $'describe ($table)'
  let args = [
    --pad-vert 2
    --pad-horiz 2
    --window-title $table
    --no-line-number
    --no-window-controls
    --background '#fff'
    --language sql
    --output test.png
  ]
  usql $dsn -q -c $query | silicon ...$args
}
