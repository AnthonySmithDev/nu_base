
def host [...path: string] {
  '/private/order/message' | append $path | path join
}

def order_ids [] {
  order ids
}

export def create [id: string@order_ids] {
  let body = {
    msg_type: (form msg_type),
    msg_data: (form msg_data),
  }
  https post (host $id) $body | get data
}

export def list [
  id: string@order_ids
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host $id) $query | get data
}

export def read [id: string@order_ids] {
  https get (host $id read) | get data
}

export def receive [id: string@order_ids] {
  https get (host $id receive) | get data
}
