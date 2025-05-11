
def host [path: string = ''] {
   '/kyc' | path join $path
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
   list | select id user_account.email | rename value description
}

export def view [id: string@ids] {
   https get (host $id) | get data
}

export def update [id: string@ids] {
   let body = {
      status: (form kyc_status)
   }
   https put (host $id) $body | get data
}

export def count [] {
   https get (host count) | get data
}
