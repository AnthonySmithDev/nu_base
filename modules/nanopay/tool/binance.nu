
export def currency [] {
  http get 'https://www.binance.com/bapi/asset/v1/public/asset-service/product/currency' | get data
}

export def country [] {
  http get 'https://accounts.binance.com/bapi/accounts/v1/public/country/list' | get data 
}

export def asset [] {
  http get 'https://p2p.binance.com/bapi/asset/v2/public/asset/asset/get-all-asset' | get data
}

export def fiat [] {
  http post 'https://p2p.binance.com/bapi/c2c/v1/friendly/c2c/trade-rule/fiat-list' '' | get data
}

export def bank [] {
  http get 'https://p2p.binance.com/bapi/c2c/v2/public/c2c/trade-method/list-by-page?page=1&rows=1000' | get data
}

def trade_type [] {
  ["BUY" "SELL"]
}

export def advs [trade_type: string@trade_type, --fiat: string = "PEN", --page: int = 1, --rows: int = 20] {
  let body = {
    "fiat": $fiat,
    "page": $page,
    "rows": $rows,
    "tradeType": $trade_type,
    "asset": "USDT",
    "countries": [],
    "proMerchantAds": false,
    "shieldMerchantAds": false,
    "publisherType": "merchant",
    "payTypes": [],
    "classifies": ["mass", "profession"],
  }
  http post -t application/json https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search $body | get data
}

export def advNo [trade_type: string@trade_type] {
  advs $trade_type | get adv.advNo
}

export def detail [advNo: string] {
  http get https://p2p.binance.com/bapi/c2c/v2/public/c2c/adv/detail?advNo=($advNo) | get data
}

export def gen_remarks [] {
  let ids = advNo BUY
  for $id in $ids {
    let detail = detail $id
    $"\nXXXXXXXXXX\n'($detail.remarks)'" | save -a remarks.txt
  }
}
