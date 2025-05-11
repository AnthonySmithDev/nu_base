
def host [...path: string] {
  '/merchant/inter' | append $path | path join
}

export def create [] {
  let body = {
    name: (form merchant_name)
    email: (form merchant_email)
  }
  https post (host) $body | get data
}

export def view [] {
  https get (host) | get data
}

export def update [] {
  let view = view
  let body = {
    name: (form merchant_name $view.name)
    email: (form merchant_email $view.email)
  }
  https put (host) $body | get data
}

export def "item rand-body" [] {
  let r = rand item
  return {
    name: $r.name
    desc: $r.desc

    asset_type: (rand merchat_asset_type)
    asset_types: (rand merchat_asset_types)

    fiat_type: (rand merchat_fiat_type)
    fiat_amount: $r.price

    success_url: "http://localhost:3005/merchant/success"
    cancel_url: "http://localhost:3005/merchant/cancel"

    ipn_url: "http://localhost:3005/merchant/ipn"
    ipn_secret: "myipnsecret"
  }
}

export def "item create" [ --rand(-r) ] {
  let r = item rand-body
  let body = if $rand { $r } else {
    {
      name: (form merchant_name $r.name)
      desc: (form merchant_desc $r.desc)

      asset_type: (form asset_type $r.asset_type)
      asset_types: (form asset_types $r.asset_types)

      fiat_type: (form fiat_type $r.fiat_type)
      fiat_amount: (form fiat_amount $r.fiat_amount)

      success_url: (form success_url $r.success_url)
      cancel_url: (form cancel_url $r.cancel_url)

      ipn_url: (form ipn_url $r.ipn_url)
      ipn_secret: (form ipn_secret $r.ipn_secret)
    }
  }
  https post (host item) $body | get data
}

export def "item list" [--page(-p): int = 1, --size(-s): int = 100] {
  let query = {
    page: $page
    size: $size
  }
  https get (host item) $query | get data.items | reject -i created_at updated_at
}

export def "item_ids" [] {
  item list | select id name | rename value description
}

export def "item view" [id: string@item_ids] {
  https get (host item $id) | get data
}

export def "item update" [id: string@item_ids] {
  let view = item view $id
  let body = {
    name: (form merchant_name $view.name)
    desc: (form merchant_desc $view.desc)

    asset_type: (form asset_type $view.asset_type)
    asset_types: (form asset_types $view.asset_types)

    fiat_type: (form fiat_type $view.fiat_type)
    fiat_amount: (form fiat_amount $view.fiat_amount)

    success_url: (form success_url $view.success_url)
    cancel_url: (form cancel_url $view.cancel_url)

    ipn_url: (form ipn_url $view.ipn_url)
    ipn_secret: (form ipn_secret $view.ipn_secret)
  }
  https put (host item $id) $body | get data
}

export def "item delete" [id: string@item_ids] {
  https del (host item $id) | get data
}
