
def host [...path: string] {
  '/wallet' | append $path | path join
}

export def list [] {
  https get (host) | get data
}

export def 'nano address' [] {
  https get (host nano address) | get data
}

export def 'nano balance' [] {
  https get (host nano balance) | get data
}

export def 'nano tx' [] {
  https get (host nano tx) | get data
}

export def 'nano send' [address: string, amount: string] {
  let body = {
    amount: $amount
    address: $address
  }
  https post (host nano send) $body | get data
}

export def 'nano graph type' [] {
  https get (host nano graph type) | get data
}

export def 'nano graph month' [type: int = 1] {
  let query = {tx_type: $type}
  https get (host nano graph month) $query | get data
}

export def 'bitcoin address' [] {
  https get (host bitcoin address) | get data
}

export def 'bitcoin balance' [] {
  https get (host bitcoin balance) | get data
}

export def 'bitcoin tx' [] {
  https get (host bitcoin tx) | get data
}

export def 'bitcoin graph type' [] {
  https get (host bitcoin graph type) | get data
}

export def 'bitcoin graph month' [type: int = 1] {
  let query = {tx_type: $type}
  https get (host bitcoin graph month) $query | get data
}

export def 'bitcoin send' [address: string, amount: string] {
  let body = {
    amount: $amount
    address: $address
  }
  https post (host bitcoin send) $body | get data
}
