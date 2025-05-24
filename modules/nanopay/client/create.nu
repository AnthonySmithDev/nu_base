use rand
use user
use admin
use upload
use p2p

export def --env create_user [name: record] {
  print $"Creando User: ($name.first) ($name.middle) ($name.last)"
 
  let full = ([$name.first $name.middle $name.last] | str join '')
  let email = ($full | str downcase)
  let nickname = ($full + "_user")

  user auth signup $email
  user account nickname $nickname
}

export def advertiser [name: record] {
  print $"  Creando Advertiser"

  let nickname = $name.first + (faker trade nickname)
  p2p advertiser update $nickname
}

export def kyc [
  first?: string
  middle?: string
  last?: string
] {
  print $"  Creando KYC"

  user kyc create_info $first $middle $last
  user kyc create_doc
  user kyc create
  user kyc verify
}

export def balance [] {
  print $"  Creando Balance"

  user wallet list 
  p2p wallet create
}

export def methods [] {
  print $"  Creando Metodos"

  p2p method rand basic --total 10
  p2p method rand custom --total 10
  p2p method rand specific --total 10
}

export def ads [] {
  print $"  Creando Anuncios"
 
  for $x in 1..5 {
    p2p trade create-rand --type 1
  }

  for $x in 1..5 {
    p2p trade create-rand --type 2
  }
}

def accounts_id [] {
 sql query -n SELECT id, nickname FROM user_accounts ORDER BY created_at | get id | skip 2
}

def rand_user_id [user_id: string] {
  let ids = (accounts_id)
  let len = ($ids | length)
  if $len == 1 {
    return ($ids | first)
  }
  let max = $len - 1
  loop {
    let index = (random int 0..$max)
    let id = ($ids | get $index)
    if $id != $user_id {
      return $id
    }
  }
}

export def order [--min: int = 100, --max: int = 600] {
  print $"  Creando Ordenes"

  let user_id = (user account view | get id)
  let rand_id = (rand_user_id $user_id)

  let columns = sql to-columns [id number status order_type buyer_id seller_id asset_id fiat_id price asset_amount fiat_amount]
  mut query = $"INSERT INTO orden ($columns) \nVALUES\n"
  let total = (random int $min..$max)

  for $index in 1..$total {
    # agregar dias de registrado, promedio de liberacion y de pago
    # reseñas positivas y negativasj
    # createad at
    # notifiead_at

    mut buyer = ""
    mut seller = ""

    let rand = (random int 1..2)
    if $rand == 1 {
      $buyer = $user_id
      $seller = $rand_id
    } else {
      $buyer = $rand_id
      $seller = $user_id
    }

    let id = (random uuid)
    let number = (random int)
    let status = (rand order_status)
    let type = (rand order_type)
    let fiat_id = (rand fiat_id)
    let asset_id = (rand asset_id)
    let asset_price = (rand asset_price $fiat_id $asset_id)
    let asset_amount = (rand asset_amount $asset_id)
    let fiat_amount = ($asset_price * $asset_amount | math round -p 3)

    $query = $query + (sql to-values [$id $number $status $type $buyer $seller $asset_id $fiat_id $asset_price $asset_amount $fiat_amount])
    if $index != $total {
      $query = $query + ",\n"
    } else {
      $query = $query + ";\n"
    }

  }
  sql query -n $query | null
}

export def --env new [
  first: string = "",
  middle: string = "",
  last: string = "",
  --orders
] {
  let name = {
    first: $first,
    middle: $middle,
    last: $last,
  }
  let fullname = $"($name.first) ($name.middle) ($name.last)"
  try {
    create_user $name
    advertiser $name
    kyc $name.first $name.middle $name.last
    balance
    methods
    ads
  } catch { |err|
    print $err.msg
  }
  # if ($orders) {
  #   order
  # }
  # print "\n"
}

export def --env random_user [--empty] {
  let first = (faker name first)
  let middle = (faker name first)
  let last = (faker name last)

  if ($empty) {
    new $first $middle $last
  } else {
    new $first $middle $last --orders
  }
}

export def --env users [ --max: int = 1000 ] {
  for $n in 1..$max {
    print $"User Random: ($n) -> ($max)"
    random_user
  }
}

export def --env default_users [] {
  new "Cleyson"
  new "Jose"

  random_user --empty
  new "Anthony" --orders
  new "Smith" --orders
  new "Aguirre" --orders
  new "Bejar" --orders
  new "Jeanmg" --orders
}

def sql_truncate [] {
  let tables = [
    user_accounts,
    user_passwords,
    user_emails,
    user_phones,
    user_login,
    advertiser,

    trade,
    method,
    know_your_customer,

    orden,
    order_appeal,
    order_appeal_history,
    order_cancel,
    order_comment,
    order_file,
    order_message,
    order_report,

    wallet_nano_seed
    wallet_nano_account
    wallet_nano_transac

    wallet_bitcoin_seed
    wallet_bitcoin_account
    wallet_bitcoin_transac
  ]
  sql truncate-table ...$tables | null
}

def sql_empty [id: string] {
  let query = $"DELETE FROM orden WHERE seller_id = '($id)' OR buyer_id = '($id)'"
  print $query
  sql query -n $query
}

def sql_order_notified [] {
  let query = "UPDATE orden SET notified_at = DATE_ADD(created_at, INTERVAL 5 MINUTE) WHERE status = 3"
  print $query
  sql query -n $query
}

def mongo_drop [] {
  let collections = [
    user_account
    user_password
    user_email
    user_phone
    user_login
    advertiser

    email_code
    phone_code

    kyc
    personal_info
    personal_doc

    trade
    method

    nano_wallet_seed
    nano_wallet_account
    nano_wallet_tx

    bitcoin_wallet_seed
    bitcoin_wallet_account
    bitcoin_wallet_tx
  ]
  use .../mongo.nu 
  use ../service/backend

  mongo coll drop ...$collections
  backend docker exec insert
}

export def clean [] {
  mongo_drop 
}
