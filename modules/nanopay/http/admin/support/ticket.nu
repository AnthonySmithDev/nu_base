
def host [...path: string] {
  '/support/ticket' | append $path | path join
}

const STATUS = {
   PENDING: 1
   PROCESS: 2
   CLOSED: 3
   DELETED: 4
}

export def list [
   --page: int = 1
   --size: int = 100
   --status: int = 0
   --owner,
] {
   let query = {
      page: $page
      size: $size
      status: $status
      owner: ($owner | into string)
   }
   https get (host) $query | get data.items
}

export def ids [] {
   list | select id title | rename value description
}

export def owner [] {
   list --owner
}

export def ids_owner [] {
   owner | select id title | rename value description
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

export def deleted [] {
   list --status $STATUS.DELETED
}

export def ids_deleted [] {
   deleted | select id title | rename value description
}

export def view [id: string@ids_owner] {
   https get (host $id) | get data
}

export def update [id: string@ids_pending] {
   https put (host $id) {} | get data
}

export def close [id: string@ids_process] {
   https del (host $id) | get data
}

export def count [] {
   https get (host count) | get data
}
