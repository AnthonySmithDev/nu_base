
def host [...path: string] {
  '/private/order' | append $path | path join
}

def order_ids [] {
  order ids_pending
}

export def create [id: string@order_ids] {
  let order = (order view $id)
  let user_id = if $order.is_buyer {
    $order.buyer_id
  } else {
    print "Only buyer create appeal"
    return
  }

  let body = {
    user_id: $user_id
    reason: 1
    desc: "no tengo un descripcion"
    files: []
  }
  https post (host $id appeal) $body | get data
}

export def ids [] {
  order list -s 11 | get appeal_id
}

export def view [id: string@ids] {
  https get (host appeal $id) | get data
}

export def update [id: string@ids] {
  let body = {
    "status": 1
  }
  https put (host appeal $id) $body | get data
}

export def cancel [id: string@ids] {
  https del (host appeal $id) | get data
}
