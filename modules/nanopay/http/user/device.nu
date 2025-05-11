
def host [...path: string] {
  '/security/device' | append $path | path join
}

export def list [
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host) $query | get data.items
}

def ids [] {
   list | get id
}

export def delete [id: string@ids] {
   https del (host $id) | get data
}

export def login [id: string@ids] {
   https get (host $id login) | get data
}
