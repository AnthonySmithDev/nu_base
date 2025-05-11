
def host [...path: string] {
  '/private/wallet' | append $path | path join
}

def asset [] {
  [nano bitcoin usdt]
}

export def account [asset: string@asset = ""] {
  https get (host account $asset) | get data
}

export def transac [asset: string@asset = ""] {
  https get (host transac $asset) | get data
}

def object-id [] {
  $"67ec714572d3(random chars --length 12)"
}

def gen [user_id: string, asset_id: int, amount: int] {
  {
    "_id": (object-id),
    "from_tx_id": "__generado__",
    "to_user_id": $user_id,
    "asset_type": $asset_id,
    "asset_amount": $amount,
    "tx_type": 1,
    "tx_status": 2,
  }
}

def insert [user_id: string, amount: int] {
  let gens = [
    (gen $user_id 1 $amount)
    (gen $user_id 2 $amount)
    (gen $user_id 3 $amount)
  ]
  mongo coll insertMany virtual_tx $gens
}

export def create [--amount(-m): int = 100_000] {
  let user_id = (user account view | get id)
  insert $user_id $amount
}
