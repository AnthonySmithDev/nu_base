
def host [...path: string] {
  '/private/order' | append $path | path join
}

export def select-trade [trades: table] {
  if ($trades | is-empty) {
    error make -u {msg: "Trades are empty"}
  }
  let data = ($trades |
    select id advertiser.nickname price_type asset.code fiat.currency_code price total_tx_fiat_amount min_tx_fiat_amount max_tx_fiat_amount )
  let value = (form fzf-table "Select Ad" $data [id nickname type asset fiat price total min max])
  if ($value | is-empty) {
    error make -u {msg: "Select trade is empty"}
  }
  return ($trades | where id == $value.id | first)
}

export def select-buy-method-id [trade_id: string] {
  let trade = trade public view $trade_id
  let data = ($trade.methods | select id bank.name bank_user_name bank_user_account)
  let value = (form fzf-table "Select Method" $data [id bank_name bank_user bank_account])
  if ($value | is-empty) {
    error make -u {msg: "Select method is empty"}
  }
  return ($value | get id)
}

export def create-buy [] {
  let trade = select-trade (trade public list --ad 1)
  let amount = if (form buy-type) == 0 {
    (form asset_amount) * $trade.price
  } else {
    (form fiat_amount)
  }

  let body = {
    "fiat_amount": $amount
    "method_id": (select-buy-method-id $trade.id)
    "terms": true
  }

  https post (host buy $trade.id) $body | get data
}

export def select-sell-method-id [trade_id: string] {
  let methods = (trade methods $trade_id)
  if ($methods | is-empty) {
    error make -u {msg: "Payment methods are empty"}
  }
  let values = ($methods | select id bank.name bank.iso_code bank_user_name bank_user_account)
  let value = (form fzf-table "Select methods" $values [id bank fiat name account])
  if ($value | is-empty) {
    error make -u {msg: "Order finder are empty"}
  }
  return ($value | get id)
}

export def create-sell [] {
  let trade = select-trade (trade public list --ad 2)

  let body = {
    "asset_amount": (form asset_amount),
    "method_id": (select-sell-method-id $trade.id)
    "terms": true
  }

  https post (host sell $trade.id) $body | get data
}

export def list [--status(-s): int = 0] {
  let query = {
    status: $status
    # type: (form order_type)
    # asset_id: (form asset_id)
  }
  https get (host) $query | get data.items
}

export def ids [] {
  list | get id
}

export def view [id: string@ids] {
  https get (host $id) | get data
}

export def cancel [id: string@ids_pending] {
  let body = { type: (form order_cancel_type) }
  https put (host $id cancel) $body | get data
}

export def notify [id: string@ids_pending] {
  https put (host $id notify) {} | get data
}

export def release [id: string@ids_pending] {
  let query = {otp_code: "111111"}
  https put (host $id release) {} $query | get data
}

export def method [id: string@ids] {
  https get (host $id method) | get data
}

export def pending [id: string = ""] {
  list --status 9
}

export def ids_pending [] {
  pending | get id
}
