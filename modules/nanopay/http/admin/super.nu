
def host [...path: string] {
   '/super' | append $path | path join
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

export def ids [] {
   list | select id username | rename value description
}

export def create [username: string] {
   let body = { username: $username }
   let password = (https post (host) $body | get data)
   auth password $username $password
}

export def option [id: string@ids, --enable, --disable, --super --nosuper] {
   let body = {
      admin_enable: $enable
      admin_disable: $disable
      super_enable: $super
      super_disable: $nosuper
   }
   https put (host option $id) $body | get data
}

export def password [id: string@ids] {
   https put (host password $id) {} | get data
}
