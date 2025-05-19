
def handle [out: string, header: string, required: bool, int: bool, float: bool] {
  if $required and ($out | is-empty) {
    error make -u {msg: $"($header) is required"}
  }
  if ($out | is-empty) {
    return
  }
  if $int {
    return ($out | into int)
  }
  if $float {
    return ($out | into float)
  }
  return $out
}

def input [--header: string, --value: any, --required, --int, --float] {
  let out = (gum input --header $header --value $value | str trim)
  handle $out $header $required $int $float
}

export def message_data [default: string = ""] {
  input --required --header 'Message Content' --value $default
}

export def kyc_status [] {
  let data = {'enable': 1, 'pending': 2, 'disable': 3}
  let value = gum choose --header 'Kyc Status' ...($data | columns)
  if ($value | is-empty) {
    return 0
  }
  $data | get ($value | str trim)
}

export def user_block [] {
  let data = {'null': null, 'true': true, 'false': false}
  let value = gum choose --header 'User Block' ...($data | columns)
  if ($value | is-empty) {
    return null
  }
  $data | get ($value | str trim)
}

export def user_enable [] {
  let data = {'null': null, 'true': true, 'false': false}
  let value = gum choose --header 'User Enable' ...($data | columns)
  if ($value | is-empty) {
    return null
  }
  $data | get ($value | str trim)
}

export def choose [
  --shuffle(-s)
  --multi(-m)
  --header(-h): string
  --value(-v): string
  data: record
] {
  let table = ($data | transpose key value)
  let height = ($data | columns | length) + 5
  let columns = if $shuffle { $data | columns | shuffle } else { $data | columns }

  let selected = if $multi {
    let values = ($value | split row , | into int)
    $table | where value in $values | get key | str join ,
  } else {
    let values = ($table | where value == ($value | into int))
    $values | get key | str join ,
  }

  mut args = [
    --height $height
    --header $header
    --selected $selected
    ...$columns
  ]

  if $multi {
    $args = ($args | append [--no-limit])
  }

  let key = gum filter ...$args

  if ($key | is-empty) {
    return
  }

  if $multi {
    return ($table | where key in ($key | lines) | get value)
  }

  return ($data | get $key)
}

const MESSAGE = {
  TEXT: 1
  IMAGE: 2
}

export def message_type [default: int = 0] {
  choose --header 'Message Type' --value ($default | into string) $MESSAGE
}
