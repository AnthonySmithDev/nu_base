const dsn = "mysql://payzum_user:payzum_password@0.0.0.0:3307/payzum"

export def main [] {
  let tables = (usql $dsn -q -C -c "show tables" | lines | skip | to text)
  let args = [
    --margin 1
    --padding 1
    --border
    --info inline
    --layout reverse
    --preview "nu describe.nu {}"
    --preview-label '[ SQL query ]'
    --preview-window 'right,75%,border-none'
  ]
  $tables | fzf ...$args
}
