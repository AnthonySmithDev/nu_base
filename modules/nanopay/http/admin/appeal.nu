
def host [...path: string] {
  '/order/appeal' | append $path | path join
}

export def list [
  --page: int = 1
  --size: int = 10
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

export def view [id: string@ids] {
  https get (host $id) | get data
}
