
def host [...path: string] {
   '/user' | append $path | path join
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
   list | select id nickname | rename value description
}

export def update [id: string@ids, --enable, --disable, --block, --unblock] {
   let body = {
      enable: $enable
      disable: $disable
      block: $block
      unblock: $unblock
   }
   https put (host $id) $body | get data
}

export def detail [id: string@ids] {
   https get (host $id detail) | get data
}

export def merchant [id: string@ids] {
   https get (host $id merchant) | get data
}

export def --env login [id: string@ids] {
   let jwt = (https get (host $id login) | get data)
   user auth set "admin"
   user jwt write $jwt
}

export def graph [] {
   https get (host graph) | get data
}

export def count [] {
   https get (host count) | get data
}
