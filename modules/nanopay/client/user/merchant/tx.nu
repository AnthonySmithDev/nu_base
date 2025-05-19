
def host [...path: string] {
  '/merchant/transaction' | append $path | path join
}

export def list [] {
  https get (host) | get data
}

export def export [] {
  https get (host export)
}

def asset [] {
  [
    { value: "1" description: "Nano" }
    { value: "2" description: "Bitcoin" }
  ]
}

export def total [asset: string@asset] {
  let query = {
    "asset_type": $asset
  }
  https get (host total) $query | get data
}

export def count [] {
  https get (host count) | get data
}

export def "graph month" [] {
  https get (host graph month) | get data
}

export def "graph asset total" [] {
  https get (host graph asset total) | get data
}

export def "graph asset month" [] {
  https get (host graph asset month) | get data
}

export def "graph asset day" [] {
  https get (host graph asset day) | get data
}

def dates [] {
  [day month total]
}

export def "graph by" [date: string@dates] {
  https get (host graph by $date) | get data
}
