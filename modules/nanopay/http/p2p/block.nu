
def host [...path: string] {
  '/private/advertiser/block' | append $path | path join
}

def ids [] {
  sql from user_accounts | get id
}

export def create [id: string@ids] {
  let reason = form block_reason
  let desc = if $reason == 5 { form block_desc }
  let body = {
    user_id: $id
    reason: $reason
    desc: $desc
  }
  http post (host) $body | get data
}

export def delete [id: string@ids] {
  let body = {
    user_id: $id
  }
  https del (host) $body | get data
}

export def list [] {
  https get (host) | get data
}

export def view [id: string@ids] {
  https get (host $id) | get data
}
