
def host [...path: string] {
  '/support/ticket' | append $path | path join
}

export def rand-body [] {
  let r = rand ticket
  return {
    title: $r.title
    desc: $r.desc
  }
}

export def create [ --rand(-r) ] {
  let r = rand-body
  let body = if $rand { $r } else {
    {
      title: (form ticket_title $r.title)
      desc: (form ticket_desc $r.desc)
    }
  }
  https post (host) $body | get data
}

const STATUS = {
   PENDING: 1
   PROCESS: 2
   CLOSED: 3
}

export def list [
  --page: int = 1
  --size: int = 100
  --status: int = 0
] {
  let query = {
    page: $page
    size: $size
    status: $status
  }
  https get (host) $query | get data.items
}

export def ids [] {
  list | select id title | rename value description
}

export def pending [] {
   list --status $STATUS.PENDING
}

export def ids_pending [] {
   pending | select id title | rename value description
}

export def process [] {
   list --status $STATUS.PROCESS
}

export def ids_process [] {
   process | select id title | rename value description
}

export def closed [] {
   list --status $STATUS.CLOSED
}

export def ids_closed [] {
   closed | select id title | rename value description
}

export def view [id: string@ids] {
  https get (host $id) | get data
}

export def count [] {
  https get (host count) | get data
}
