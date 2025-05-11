
export def 'main account' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/main/account $query | get data
}

export def 'main tx' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/main/tx $query | get data
}

export def 'payment account' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/payment/account $query | get data
}

export def 'payment tx' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/payment/tx $query | get data
}

export def 'funding account' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/funding/account $query | get data
}

export def 'funding tx' [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get /wallet/bitcoin/funding/tx $query | get data
}

export def 'payment count' [] {
  https get /wallet/bitcoin/payment/count | get data
}

export def 'payment graph' [] {
  https get /wallet/bitcoin/payment/graph | get data
}
