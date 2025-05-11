export module remarks.nu
export module item.nu
export module shop.nu
export module ticket.nu
export module message.nu
export module bank.nu

const PRICE_TYPE = {
  FIXED: 1
  FLOAT: 2
}

const ISO_TYPE = {
  USD: "USD"
  PEN: "PEN"
}

export def iso [] {
  $ISO_TYPE | values | get (random int 0..1)
}

const COUNTRY = {
  PERU: 168
  VENEZUELA: 237
}

export def country [] {
  $COUNTRY | values | get (random int 0..1)
}

const ORDER_TYPE = {
  BUY: 1
  SELL: 2
}

export def order_type [] {
  $ORDER_TYPE | values | get (random int 0..1)
}

const ORDER_STATUS = {
  PROCESS: 1
  CANCELED: 2
  NOTIFIED: 3
  RELEASED: 4
}

export def order_status [] {
  let rand = (random int 1..100)
  if $rand == 0 {
    return $ORDER_STATUS.CANCELED
  } else if $rand == 1 {
    return $ORDER_STATUS.NOTIFIED
  } else {
    return $ORDER_STATUS.RELEASED
  }
}

const AD_TYPE = {
  BUY: 1
  SELL: 2
}

export def ad_type [] {
  $AD_TYPE | values | get (random int 0..1)
}

const FIAT_TYPE = {
  DOLLAR: 1
  SOLES: 29
}

export def fiat_id [] {
  $FIAT_TYPE | values | get (random int 0..1)
}

const MERCHANT_FIAT_TYPE = {
  DOLLAR: 1
  EURO: 2
}

export def merchat_fiat_type [] {
  $MERCHANT_FIAT_TYPE | values | get (random int 0..1)
}

const MERCHANT_ASSET_TYPE = {
  XNO: 1
  BTC: 2
  USTD: 3
}

export def merchat_asset_type [] {
  $MERCHANT_ASSET_TYPE | values | get (random int 0..1)
}

export def merchat_asset_types [] {
  let values = ($MERCHANT_ASSET_TYPE | values)
  let length = ($values | length)
  $values | first (random int 1..$length)
}

const ASSET_TYPE = {
  NANO: 1
  BITCOIN: 2
  USDT: 3
}

export def asset_id [] {
  $ASSET_TYPE | values | get (random int 0..2)
}

export def price_type [] {
  let rand = (random int 0..10)
  if ($rand == 0) {
    return $PRICE_TYPE.FLOAT
  } else {
    return $PRICE_TYPE.FIXED
  }
}

export def asset_amount [asset: int] {
  if ($asset == $ASSET_TYPE.NANO) {
    return (random int 100..10_000)
  }
  if ($asset == $ASSET_TYPE.BITCOIN) {
    return (random int 10..100)
  }
  if ($asset == $ASSET_TYPE.USDT) {
    return (random int 100..1_000)
  }
}

export def asset_price [fiat: int, asset: int] {
  if ($fiat == $FIAT_TYPE.DOLLAR) {
    if ($asset == $ASSET_TYPE.NANO) {
      return (random float 1.20..1.30 | math round -p 3)
    }
    if ($asset == $ASSET_TYPE.BITCOIN) {
      return (random float 64_700.0..64_800.0 | math round -p 3)
    }
    if ($asset == $ASSET_TYPE.USDT) {
      return (random float 0.9..1.1 | math round -p 3)
    }
  }
  if ($fiat == $FIAT_TYPE.SOLES) {
    if ($asset == $ASSET_TYPE.NANO) {
      return (random float 4.1..4.9 | math round -p 3)
    }
    if ($asset == $ASSET_TYPE.BITCOIN) {
      return (random float 239_400.0..239_500.0 | math round -p 3)
    }
    if ($asset == $ASSET_TYPE.USDT) {
      return (random float 3.7..3.8 | math round -p 3)
    }
  }
}

export def min_asset_amount [asset: int] {
  if ($asset == $ASSET_TYPE.NANO) {
    return (random float 0.1..0.3 | math round -p 1)
  }
  if ($asset == $ASSET_TYPE.BITCOIN) {
    return (random float 0.001..0.003 | math round -p 3)
  }
  if ($asset == $ASSET_TYPE.USDT) {
    return (random float 0.1..0.3 | math round -p 1)
  }
}

export def max_asset_amount [asset: int] {
  if ($asset == $ASSET_TYPE.NANO) {
    return (random float 0.7..0.9 | math round -p 1)
  }
  if ($asset == $ASSET_TYPE.BITCOIN) {
    return (random float 0.007..0.009 | math round -p 3)
  }
  if ($asset == $ASSET_TYPE.USDT) {
    return (random float 0.7..0.9 | math round -p 1)
  }
}

export def card-number [] {
  $"4557-8800-(random int 1000..9999)-(random int 1000..9999)"
}

export def bank-number [] {
  $"077-00(random int 10000..99999)"
}

export def bank-cci [] {
  $"009-253-2007700(random int 10000..99999)-(random int 10..99)"
}
