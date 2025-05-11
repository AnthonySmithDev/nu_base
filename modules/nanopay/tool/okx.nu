
export def listCurrency [] {
  http get 'https://www.okx.com/v3/users/common/list/currencies' | get data
}

def isoCode [] {
  listCurrency | get isoCode
}

export def paymentMethod [] {
  http get 'https://www.okx.com/v3/c2c/configs/payment/methods' | get data
}

export def mostUsed [iso: string@isoCode] {
 http get $'https://www.okx.com/v3/c2c/tradingOrders/mostUsedPaymentMethod?fiatCurrency=($iso)' | get data
}

export def currencyQuote [] {
  http get https://www.okx.com/v3/c2c/currency/quote?type=2 | get data | where blockTrade == false | select quoteCurrency quoteSymbol
}

def quoteCurrency [] {
  currencyQuote | get quoteCurrency
}

export def bankCurrency [quoteCurrency: string@quoteCurrency] {
  http get https://www.okx.com/v3/c2c/configs/receipt/templates?quoteCurrency=($quoteCurrency) | get data | reject fieldJson instantSettlePayment mostUsed
}

def add [banks: list] {
  let filename = 'banks.json'
  if not ($filename | path exists) {
    touch $filename
  }
  open $filename | append $banks | save -f $filename
}

# mods como convertir esto: "0x0072E3" a "rgb(0, 114, 227)"
export def createBanks [] {
  for quote in (quoteCurrency) {
    let mostUsed = (mostUsed $quote)

    let banks = (bankCurrency $quote | each {|e|
      if ($e.paymentMethod == "bank") {
        return
      }
      $e | insert isoCode $quote | insert mostUsed ($e.paymentMethod in $mostUsed)
    })

    add $banks
    print $quote
    sleep 1sec
  }
}
