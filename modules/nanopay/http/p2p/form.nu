
def input [--header: string, --value: any, --required, --int, --float] {
  let out = (gum write --header $header --value $value --show-help | str trim)
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

export def bank_name [value: string = ""] {
  input --header 'Bank Name' --value $value
}

export def bank_user_name [value: string = ""] {
  input --header 'Bank User Name' --value $value
}

export def bank_user_account [value: string = ""] {
  input --header 'Bank User Account' --value $value
}

export def fixed_price [value: float = 5.0] {
  input --header 'Fixed Price' --value $value --float
}

export def floating_price [value: float = 0.9] {
  input --header 'Floating Price' --value $value --float
}

export def asset_amount [value: int = 100] {
  input --header 'Asset Amount' --value $value --required --int
}

export def fiat_amount [value: int = 100] {
  input --header 'Fiat Amount' --value $value --required --int
}

export def min_tx_amount [value: int = 25] {
  input --header 'Min Tx Amount' --value $value --required --int
}

export def max_tx_amount [value: int = 75] {
  input --header 'Max Tx Amount' --value $value --required --int
}

export def total_tx_amount [value: int = 100] {
  input --header 'Total Tx Amount' --value $value --required --int
}

export def block_desc [value: string = ""] {
  input --header 'Block Description' --value $value
}

export def comment_content [value: string = ""] {
  input --header 'Order Comment Content' --value $value
}

export def msg_data [value: string = ""] {
  input --header 'Message data' --value $value
}

export def choose [--header: string, data: record] {
  let height = ($data | columns | length) + 5
  let key = gum filter --header $header ...($data | columns) --height $height
  if ($key | is-empty) {
    return
  }
  return ($data | get $key)
}

const BUY_TYPE = {
  ASSET: 0,
  FIAT: 1,
}

export def buy-type [] {
  choose --header 'Buy Type' $BUY_TYPE
}

const COUNTRY = {
  'Null': 0,
  'Peru': 168
}

export def country_id [] {
  choose --header 'Country ID' $COUNTRY
}

const AD = {
  BUY: 1
  SELL: 2
}

export def ad_id [] {
  choose --header 'Ad Type' $AD
}

const ASSET = {
  NANO: 1,
  BITCOIN: 2,
  USDT: 3,
}

export def asset_id [] {
  choose --header 'Asset Type' $ASSET
}

const MARKET = {
  PUBLIC: 1
  PRIVATE: 2
}

export def market_type [] {
  choose --header 'Market Type' $MARKET
}

const FIAT = {
  PEN: 29,
  USD: 4,
  EUR: 7
}

export def fiat_id [] {
  choose --header 'Fiat Type' $FIAT
}

const PRICE = {
  FIXED: 1,
  FLOATING: 2,
}

export def price_type [] {
  choose --header 'Price Type' $PRICE
}

const TIME_LIMIT = {
  '15 min': 1,
  '30 min': 2,
  '45 min': 3,
  '60 min': 4
}

export def time_limit [] {
  choose --header 'Payment Time Limit' $TIME_LIMIT
}

const REGISTER_DAY = {
  '0 - 10 dias': 1,
  '10 - 30 dias': 2,
  '30 - 60 dias': 3,
  'min 60 dias': 4
}

export def register_day [] {
  choose --header 'Register Day' $REGISTER_DAY
}

const TRADE_STATUS = {
  TRUE: true,
  FALSE: false,
}

export def trade_status [] {
  choose --header 'Trade Status' $TRADE_STATUS
}

const ORDER_STATUS = {
  PROGRESS: 1,
  COMPLETE: 2,
  CANCEL: 3
}

export def order_status [] {
  choose --header 'Order Status' $ORDER_STATUS
}

const MESSAGE_TYPE = {
  TEX: 1
  IMAGE: 2
}

export def msg_type [] {
  choose --header 'Message Type' $MESSAGE_TYPE
}

const CANCEL_TYPE = {
  "No he podido realizar el pago": 1,
  "No se como pagar": 2,
  "He acordado con el vendedor no seguir adelante": 3,
  "Mala actitud del vendedor": 4,
  "No puedo contactar con el vendedor": 5,
  "Vendedor suspendido o fraudulento": 6,
  "Otras razones": 7,
}

export def order_cancel_type [] {
  choose --header 'Order Cancel Type' $CANCEL_TYPE
}

const COMMENT_CATEGORY = {
  'Null': 0,
  'Positive': 1,
  'Negative': 2
}

export def comment_category [] {
  choose --header 'Order Comment Category' $COMMENT_CATEGORY
}

const BLOCK_REASON = {
  "Harassment": 1
  "Bad credibility": 2
  "Malicious feedback": 3
  "Scam suspicion": 4
  "Other": 5
}

export def block_reason [] {
  choose --header 'Block Reason' $BLOCK_REASON
}

const ORDER_STATUS = {
    "All": 0
    "InProcess": 1
    "UserCanceled": 2
    "UserNotified": 3
    "UserRelease": 4
    "UserAppeal": 5
    "InProcessTimeCancel": 6
    "UserNotifyTimeAppeal": 7

    "Pending": 8
    "Complete": 9
    "Cancel": 10
    "Appeal": 11
}

export def order_status_list [] {
  choose --header 'Order Status' $ORDER_STATUS
}

const ORDER_TYPE = {
  "ALL": 0
  "SELL": 1
  "BUY": 2
}

export def order_type [] {
  choose --header 'Order Type' $ORDER_TYPE
}

const APPEAL_STATUS = {
  "Negotiation Failed": 1
  "Consensus Reached": 2
}

export def appeal_status [] {
  choose --header 'Appeal Status' $APPEAL_STATUS
}

def height [] {
  let height = (term size | get rows)
  if $height >= 25 {
    return 25
  }
  return ($height / 2 | math round)
}

export def fzf-table [label: string, data: table, columns: list, --required, --multi] {
  mut opts = [
    --exact
    --style full
    --header-lines 1
    --input-label $label
    --layout reverse
    --color gutter:-1
    --height (height)
  ]
  if $multi {
    $opts = ($opts | append "--multi")
  }
  let value = ($data | rename ...$columns | to csv | column -t -s, | fzf ...$opts | complete)
  if $required and ($value.exit_code == 130) {
    error make -u {msg: $"($label) is required"}
  }
  if ($value.stdout | is-empty) {
    return {}
  }
  let table = ($value.stdout | from ssv -n | rename ...$columns)
  if $multi {
    return $table
  }
  return ($table | first)
}
