
def host [...path: string] {
  '/merchant/exter' | append $path | path join
}

export def rand-body [] {
  let r = rand shop
  return {
    name: $r.name
    desc: $r.desc

    asset_type: (rand merchat_asset_type)
    asset_types: (rand merchat_asset_types)

    ipn_url: "http://localhost:3005/merchant/ipn"
    ipn_secret: "myipnsecret"
  }
}

export def create [ --rand(-r) ] {
  let r = rand-body
  let body = if $rand { $r } else {
    {
      name: (form merchant_name $r.name)
      desc: (form merchant_desc $r.desc)

      asset_type: (form asset_type $r.asset_type)
      asset_types: (form asset_types $r.asset_types)

      ipn_url: (form ipn_url $r.ipn_url)
      ipn_secret: (form ipn_secret $r.ipn_secret)
    }
  }
  https post (host) $body | get data
}

export def list [
  --page(-p): int = 1
  --size(-s): int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host) $query | get data.items | reject -i created_at updated_at
}

export def ids [] {
  list | select id name | rename value description
}

export def view [id: string@ids] {
  https get (host $id) | get data
}

export def keys [id: string@ids] {
  let query = {otp_code: "000000"}
  https get (host keys $id) $query | get data
}

export def update [id: string@ids] {
  let view = view $id
  let body = {
    name: (form merchant_name $view.name)
    desc: (form merchant_desc $view.desc)

    asset_type: (form asset_type $view.asset_type)
    asset_types: (form asset_types $view.asset_types)

    ipn_url: (form ipn_url $view.ipn_url)
    ipn_secret: (form ipn_secret $view.ipn_secret)
  }
  https put (host $id) $body | get data
}

export def delete [id: string@ids] {
  https del (host $id) | get data
}
