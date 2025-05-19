
def host [...path: string] {
  '/api/management' | append $path | path join
}

export def list [
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host) $query | get data
}

def ids [] {
  list | get id
}

export def create [] {
  let body = {
    name: (form api_name),
    desc: (form api_desc),
    account_address: true,
    account_balance: true,
    withdrawal_info: true
    withdrawal_create: true,
    withdrawal_history: true,
    transaction_info: true,
    transaction_create: true,
    transaction_history: true,
  }
  https post (host) $body | get data
}

export def view [id: string@ids] {
  https get (host $id) | get data
}

export def keys [id: string@ids] {
  https get (host 'keys' $id) | get data
}

export def update [id: string@ids] {
  let body = {
    name: (form api_name),
    desc: (form api_desc),
    account_address: false,
    account_balance: false,
    withdrawal_info: false
    withdrawal_create: false,
    withdrawal_history: false,
    transaction_info: false,
    transaction_create: false,
    transaction_history: false,
  }
  https put (host $id) $body | get data
}

export def delete [id: string@ids] {
  https del (host $id) | get data
}

export def delete_all [] {
  https del (host) | get data
}
