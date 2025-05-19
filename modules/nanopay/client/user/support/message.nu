
def host [...path: string] {
  '/support/message' | append $path | path join
}

export def ticket_ids [] {
  ticket ids_process | append (ticket ids_closed)
}

export def rand-body [] {
  let r = rand message
  return {
    msg_type: $r.msg_type
    msg_data: $r.msg_data
  }
}

export def create [ ticket_id: string@ticket_ids, --rand(-r) ] {
  let r = rand-body
  let body = if $rand { $r } else {
    {
      msg_type: (form message_type $r.msg_type)
      msg_data: (form message_data $r.msg_data)
    }
  }
  https post (host $ticket_id) $body | get data
}

export def repeat [ ticket_id: string@ticket_ids, n: int = 10, sleep: duration = 1sec ] {
  typing $ticket_id true
  for $x in 1..$n {
    print (create $ticket_id --rand | get data)
    sleep $sleep
  }
  typing $ticket_id false
}

export def list [
  ticket_id: string@ticket_ids
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host $ticket_id) $query | get data.items
}

export def receive-all [] {
  https get (host receive) | get data
}

export def read-many [ ticket_id: string@ticket_ids ] {
  https get (host $ticket_id read) | get data
}

export def typing [ ticket_id: string@ticket_ids, status: bool] {
  let body = { status: $status, }
  https post (host $ticket_id typing) $body | get data
}

def message_ids [context: string] {
  let ticket_id = ($context | str trim | split row " " | skip 4 | first)
  list $ticket_id | get id
}

export def view [ ticket_id: string@ticket_ids, message_id: string@message_ids ] {
  https get (host $ticket_id $message_id) | get data
}

export def receive [ ticket_id: string@ticket_ids, message_id: string@message_ids ] {
  https get (host $ticket_id $message_id receive) | get data
}

export def read [ ticket_id: string@ticket_ids, message_id: string@message_ids ] {
  https get (host $ticket_id $message_id read) | get data
}
