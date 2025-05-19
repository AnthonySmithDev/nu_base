
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

def write [--header: string, --value: any, --required, --int, --float] {
  let out = (gum write --header $header --value $value | str trim)
  handle $out $header $required $int $float
}

export def nickname [] {
  input --header 'Nickname'
}

export def ticket_title [default: string = ""] {
  input --header 'Ticket Title' --value $default
}

export def ticket_desc [default: string = ""] {
  write --header 'Ticket Description' --value $default
}

export def message_data [default: string = ""] {
  input --required --header 'Message Content' --value $default
}

export def api_name [] {
  input --header 'API Name'
}

export def api_desc [] {
  input --header 'API Description'
}

export def merchant_name [default: string = ""] {
  input --header 'Merchant Name' --value $default
}

export def merchant_email [default: string = ""] {
  input --header 'Merchant Email' --value $default
}

export def merchant_desc [default: string = ""] {
  write --header 'Merchant Desc' --value $default
}

export def fiat_amount [default: int = 10] {
  input --header 'Fiat Amount' --value $default --float
}

export def success_url [default: string = ""] {
  input --header 'Success URL' --value $default
}

export def cancel_url [default: string = ""] {
  input --header 'Cancel URL' --value $default
}

export def ipn_url [default: string = ""] {
  input --header 'IPN URL' --value $default
}

export def ipn_secret [default: string = ""] {
  input --header 'IPN Secret' --value $default
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

const FIAT_TYPE = {
  Dollar: 1,
  Euro: 2,
}

export def fiat_type [default: int = 0] {
  choose --shuffle --header 'Fiat Type' --value ($default | into string) $FIAT_TYPE
}

const ASSET_TYPE = {
  XNO: 1,
  BTC: 2,
  USDT: 3,
}

export def asset_type [default: int = 0] {
  choose --shuffle --header 'Asset Type' --value ($default | into string) $ASSET_TYPE
}

export def asset_types [default: list<int> = []] {
  choose --multi --header 'Asset Types' --value ($default | str join ,) $ASSET_TYPE
}

const MESSAGE = {
  TEXT: 1
  IMAGE: 2
}

export def message_type [default: int = 0] {
  choose --header 'Message Type' --value ($default | into string) $MESSAGE
}
