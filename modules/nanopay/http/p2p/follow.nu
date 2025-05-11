
def host [...path: string] {
  '/private/advertiser/follow' | append $path | path join
}

def ids [] {
  sql from user_accounts | get id
}

export def create [id: string@ids] {
  let body = {
    user_id: $id
  }
  https post (host) $body | get data
}

export def delete [id: string@ids] {
  let body = {
    user_id: $id
  }
  https del (host) $body | get data
}

export def follower [] {
  https get (host follower) | get data
}

export def followed [] {
  https get (host followed) | get data
}

export def generate_followers [] {
  let userID = (user account view  | get id)
  let ids = (sql from user_accounts | where id != $userID | get id)
  for $id in $ids {
    create $id
  }
}
