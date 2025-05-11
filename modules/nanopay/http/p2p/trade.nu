use ../rand

def host [prefix: string, ...path: string] {
  ["/" $prefix trade] | append $path | path join
}

def public-query [] {
  {
    "ad_type": (form ad_id)
    "asset_type": ""
    "fiat_type": ""
    # "min_tx_amount": 191
    # "bank": (form bank_table (method bank))
    # "country": (form country (method country))
    "order_by": 1
    "order_sort": 1
  }
}

def ad-type [] {
  [
    {value: 1, description: "Buy"}
    {value: 2, description: "Sell"}
  ]
}

def fiat-type [] {
  [
    {value: 4, description: "Dolar"}
    {value: 29, description: "Pen"}
  ]
}

def asset-type [] {
  [
    {value: 1, description: "Nano"}
    {value: 2, description: "Bitcoin"}
    {value: 3, description: "USDT"}
  ]
}

export def "public list" [
  --ad(-t): int@ad-type = 2
  --fiat(-f): int@fiat-type = 4
  --asset(-a): int@asset-type = 1
  --bank-ids(-a): string
  --method-types(-a): string
  --country-id(-a): int
  --page(-p): int = 1
  --size(-s): int = 100
] {
  mut query = {
    "ad_type": $ad
    "fiat_type": $fiat
    "asset_type": $asset
    "page": $page
    "size": $size
  }
  if $bank_ids != null {
    $query = ($query | insert "bank_ids" $bank_ids)
  }
  if $method_types != null {
    $query = ($query | insert "method_types" $method_types)
  }
  if $country_id != null {
    $query = ($query | insert "country_id" $country_id)
  }
  print $query
  https get (host public) $query | get data.items
}

def public-ids [] {
  public list | each {|e| {value: $e.id, description: $"($e.advertiser.nickname)"}}
}

export def "public view" [id: string@public-ids] {
  https get (host public $id) | get data
}

export def methods [id: string@public-ids] {
  https get (host private $id methods) | get data
}

export def banks [] {
  let ad = (form ad_id)
  let asset = (form asset_id)
  let fiat = (form fiat_id)
  let country = (form country_id)
  https get (host public bank $ad $asset $fiat $country) | get data
}

export def prices [] {
  let query = {
    "ad": (form ad_id)
    "asset": (form asset_id)
    "fiat": (form fiat_id)
  }
  https get (host private prices) $query | get data
}

def get_bank_ids [] {
  let data = method bank-iso PEN
  let len = ($data | length)
  if $len < 1 {
    print "no hay bank iso para escoger"
    return
  }
  let max = $len - 1
  let rounds = (random int 1..5)
  mut ids = []
  for x in 1..$rounds {
    let id = ($data | get (random int 0..$max) | get id)
    if ($id not-in $ids) {
      $ids = ($ids | append $id)
    }
  }
  return $ids
}

def get_method_ids [] {
  let methods = method list
  if ($methods | is-empty) {
    error make -u {msg: "Methods are empty"}
  }
  let max = ($methods | length) - 1
  let rounds = (random int 1..5)
  mut ids = []
  for x in 1..$rounds {
    let id = ($methods | get (random int 0..$max) | get id)
    if ($id not-in $ids) {
      $ids = ($ids | append $id)
    }
  }
  return $ids
}

export def create-rand [ --type: int, --fiat: int, --asset: int] {

  let ad_type = if ($type | is-empty) { rand ad_type } else { $type }
  let fiat_id = if ($fiat | is-empty) { rand fiat_id } else { $fiat }
  let asset_id = if ($asset | is-empty) { rand asset_id } else { $asset }

  let bank_id = if $ad_type == 1 { get_bank_ids }
  let method_id = if $ad_type == 2 { get_method_ids }
  let country_id = [ (rand country) ]
  let price_type = rand price_type
  let asset_price = rand asset_price $fiat_id $asset_id
  let fixed_price = if $price_type == 1 { $asset_price }
  let floating_price = if $price_type == 2 {
    (random float 0.9..1.1 | math round -p 2)
  }

  let asset_amount = rand asset_amount $asset_id
  let fiat_amount = ($asset_price * $asset_amount | math round -p 3)
  let fiat_amount_min = ($fiat_amount * (rand min_asset_amount $asset_id) | math round -p 3)
  let fiat_amount_max = ($fiat_amount * (rand max_asset_amount $asset_id) | math round -p 3)

  let body = {
    "ad_type": $ad_type,
    "market_type": 1,
    "asset_id": $asset_id,
    "fiat_id": $fiat_id
    "remarks": (rand remarks),
    "auto_reply": "my auto_reply",
    "price_type": $price_type,
    "fixed_price": $fixed_price,
    "floating_price": $floating_price,
    "min_tx_fiat_amount": $fiat_amount_min,
    "max_tx_fiat_amount": $fiat_amount_max,
    "total_tx_fiat_amount": $fiat_amount,
    "bank_id": $bank_id,
    "method_id": $method_id,
    "country_id": $country_id,
    "time_limit": (random int 3..4),
    "register_day": (random int 1..4),
    "status": (random int 0..10 | $in != 0)
  }
  let type = if $ad_type == 1 { "buy" } else { "sell" }
  https post (host private $type) $body | get data
}

export def select-banks [] {
  let banks = (method bank | sort-by iso_code)
  if ($banks | is-empty) {
    error make -u {msg: "Methods banks are empty"}
  }
  let data = ($banks | default 'nothing' iso_code | select name iso_code)
  let select = (form fzf-table "Select Bank" $data [name iso_code] --required --multi)
  return ($banks | where name in ($select | get name))
}

export def create-buy [] {
  let bank_id = (select-banks | get id)
  let body = (form-create | insert bank_id $bank_id)
  https post (host private buy) $body | get data
}

export def select-methods [] {
  let methods = method list
  if ($methods | is-empty) {
    error make -u {msg: "Methods are empty"}
  }
  let data = ($methods | each {|e| {
    id: $e.id
    bank: ($e.bank_name? | default $e.bank?.name)
    fiat: $e.fiat?.currency_code
    name: $e.bank_user_name?
    account: ($e.bank_user_account? | default ('' | fill --character '─' --width 10))
  }})
  let select = (form fzf-table "Select Method" $data [id bank fiat name account] --required --multi)
  return $select
}

export def create-sell [] {
  let method_id = (select-methods | get id)
  let body = (form-create | insert method_id $method_id)
  https post (host private sell) $body | get data
}

export def select-country [] {
  let country = (method country)
  if ($country | is-empty) {
    error make -u {msg: "Country are empty"}
  }
  let data = ($country | select name iso3)
  let select = (form fzf-table "Select Country" $data [name iso] --multi)
  if ($select | is-empty) {
    return [{ id: 0 }]
  }
  return ($country | where name in ($select | get name))
}

def form-create [] {
  let market_type = (form market_type)
  let asset_id = (form asset_id)
  let fiat_id = (form fiat_id)

  let price_type = (form price_type)
  let fixed_price = if $price_type == 1 { (form fixed_price) }
  let floating_price = if $price_type == 2 { (form floating_price) }

  return {
    "market_type": $market_type,
    "asset_id": $asset_id,
    "fiat_id": $fiat_id,
    "remarks": (rand remarks),
    "auto_reply": (faker lorem sentences 4 | to text),
    "price_type": $price_type,
    "fixed_price": $fixed_price,
    "floating_price": $floating_price,
    "min_tx_fiat_amount": ((form min_tx_amount) * $fixed_price),
    "max_tx_fiat_amount": ((form max_tx_amount) * $fixed_price),
    "total_tx_fiat_amount": ((form total_tx_amount) * $fixed_price),
    "country_id": (select-country | get id),
    "time_limit": (form time_limit),
    "register_day": (form register_day),
    "status": (form trade_status)
  }
}

def private-query [] {
  {
    "ad_type": (form ad_type)
    "market_type": (form market_type)
    "start_date": (form market_type)
  }
}

export def "private list" [
  --ad(-t): int@ad-type = 0
  --fiat(-f): int@fiat-type = 0
  --asset(-a): int@asset-type = 0
  --bank-ids(-a): string
  --bank-types(-a): string
  --country-id(-a): int
  --page(-p): int = 1
  --size(-s): int = 100
] {
  mut query = {
    "ad_type": $ad
    "fiat_type": $fiat
    "asset_type": $asset
    "page": $page
    "size": $size
  }
  if $bank_ids != null {
    $query = ($query | insert "bank_ids" $bank_ids)
  }
  if $bank_types != null {
    $query = ($query | insert "bank_types" $bank_types)
  }
  if $country_id != null {
    $query = ($query | insert "country_id" $country_id)
  }
  print $query
  https get (host private) $query | get data.items
}

def private-ids [] {
  private list | each {|e| {value: $e.id, description: $"($e.advertiser.nickname)"}}
}

export def "private view" [id: string@private-ids] {
  https get (host private $id) | get data
}

export def status [] {
  let body = {
    "status": (form trade_status)
    "ids": (ids_private | to text | gum filter --no-limit | lines)
  }
  https put (host private) $body | get data
}

export def update [id: string@private-ids] {
  let trade = (view_private $id)
  let ad_type = ($trade | get ad_type)
  let price_type = (form price_type)

  let fixed_price = if $price_type == 1 { (form fixed_price) }
  let floating_price = if $price_type == 2 { (form floating_price) }

  let bank_id = if $ad_type == 1 {
    let banks = form bank_id -m (method bank)
    {
      add: $banks
      del: []
    }
  }
  let method_id = if $ad_type == 2 {
    let methods = form method_table -m (method list)
    {
      add: $methods
      del: []
    }
  }
  let country_id = {
    add: []
    del: []
  }

  let body = {
    "remarks": (rand remarks),
    "auto_reply": "my auto_reply",
    "price_type": $price_type,
    "fixed_price": $fixed_price,
    "floating_price": $floating_price,
    "min_tx_fiat_amount": (form min_tx_amount),
    "max_tx_fiat_amount": (form max_tx_amount),
    "total_tx_fiat_amount": (form total_tx_amount),
    "bank_id": $bank_id,
    "method_id": $method_id,
    "country_id": $country_id,
    "time_limit": (form time_limit),
    "register_day": (form register_day),
    "status": (form trade_status)
  }
  https put (host private $id) $body | get data
}

export def delete [id: string@private-ids] {
  https del (host private $id) | get data
}

export def balance [] {
  let query = { asset_id: 1, fiat_id: 1 }
  https get (host private sell balance) $query | get data
}
