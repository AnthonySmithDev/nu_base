
def host [...path: string] {
  '/private/order/comment' | append $path | path join
}

def order_ids [] {
  order ids
}

export def create [id: string@'order_ids'] {
  let body = {
    content: (form comment_content)
    category: (form comment_category)
  }
  https post (host $id) $body | get data
}

export def view [id: string] {
  https get (host $id) | get data
}

export def update [id: string] {
  let body = {
    content: (form comment_content)
    category: (form comment_category)
  }
  https put (host $id) $body | get data
}

export def delete [id: string] {
  https del (host $id) | get data
}
