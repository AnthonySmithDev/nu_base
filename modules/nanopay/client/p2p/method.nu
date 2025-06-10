use ../rand

def host [prefix: string, ...path: string] {
  ['/' $prefix payment method] | append $path | path join
}

export def country [] {
  https get (host public country) | get data
}

export def asset [] {
  https get (host public asset) | get data
}

export def bank [] {
  https get (host public bank) | get data
}

def iso-code [] {
  bank | get iso_code? | where {is-not-empty} | uniq
}

export def bank-iso [iso: string@iso-code] {
  https get (host public bank $iso) | get data
}

export def fiat [] {
  https get (host public fiat) | get data
}

def form-basic [] {
  {
    "fiat_id": (form fiat_id)
    "bank_id": (form bank_id (bank))
    "bank_user_name": (form bank_user_name)
    "bank_user_account": (rand bank-number)
  }
}

export def 'create basic' [body?: record] {
  let query = {otp_code: "111111"}
  let body = if ($body | is-not-empty) { $body } else { form-basic }
  https post (host private basic) $body $query | get data
}

def "rand bank_ids" [total: int = 10] {
  let iso = rand iso
  let banks = (bank-iso $iso | get id)
  let end = ($banks | length) - 1
  mut list = []
  for _ in 1..$total {
    let index = random int 0..$end
    let value = $banks | get $index
    $list = ($list | append $value)
  }
  return $list
}

export def "rand basic" [ --total(-n): int = 10 ] {
  for $bank_id in (rand bank_ids $total) {
    let body = {
      "fiat_id": (rand fiat_id)
      "bank_id": $bank_id
      "bank_user_name": (faker name full)
      "bank_user_account": (rand card-number)
    }
    create basic $body
    # print $body
  }
}

def form-custom [] {
  {
    "fiat_id": (form fiat_id)
    "bank_name": (form bank_name)
    "bank_user_name": (form bank_user_name)
    "bank_user_account": (rand bank-number)
  }
}

export def 'create custom' [body?: record] {
  let query = {otp_code: "111111"}
  let body = if ($body | is-not-empty) { $body } else { form-custom }
  https post (host private custom) $body $query | get data
}

export def "rand custom" [ --total(-n): int = 10] {
  for _ in 1..$total {
    let body = {
      "fiat_id": (rand fiat_id)
      "bank_name": (rand bank)
      "bank_user_name": (faker name full)
      "bank_user_account": (rand card-number)
    }
    create custom $body
    # print $body
  }
}

def form-specific [] {
  {
    "fiat_id": (form fiat_id)
    "bank_name": (form bank_name)
  }
}

export def 'create specific' [body?: record] {
  let query = {otp_code: "111111"}
  let body = if ($body | is-not-empty) { $body } else { form-specific }
  https post (host private specific) $body $query | get data
}

export def "rand specific" [ --total(-n): int = 10] {
  for _ in 1..$total {
    let body = {
      "fiat_id": (rand fiat_id)
      "bank_name": (rand bank)
      "bank_user_name": (faker name full)
    }
    create specific $body
    # print $body
  }
}

export def list [
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host private) $query | get data.items
}

def to-string [e: record] {
  $"($e.bank?.name | default $e.bank_name?) ($e.fiat?.currency_code) ($e.bank_user_name?) ($e.bank_user_account?)"
}

export def ids [] {
  list | each {|e| { value: $e.id, description: (to-string $e) } }
}

export def view [id: string@ids] {
  https get (host private $id) | get data
}

export def update [id: string@ids] {
  let method = view $id
  mut body = { "fiat_id": (form fiat_id) }
  if ($method.bank_name? | is-not-empty) {
    $body = ($body | insert bank_name (form bank_name $method.bank_name))
  }
  if ($method.bank_user_account? | is-not-empty) {
    $body = ($body | insert bank_user_account (form bank_user_account $method.bank_user_account))
  }
  https put (host private $id) $body | get data
}

export def delete [id: string@ids] {
  https del (host private $id) | get data
}
