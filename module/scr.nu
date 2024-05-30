
export def go [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls"
    "--background" "#0B0E14"
    "--language" "go"
  ]
  $input | silicon ...$args
}

export def js [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls"
    "--background" "#0B0E14"
    "--language" "js"
  ]
  $input | silicon ...$args
}

export def json [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls"
    "--background" "#0B0E14"
    "--language" "json"
  ]
  $input | to json | silicon ...$args
}
