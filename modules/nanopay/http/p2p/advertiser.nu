
def host [modifier: string, ...path: string] {
  ["/" $modifier 'advertiser'] | append $path | path join
}

export def profile [] {
  https get (host private) | get data
}

export def update [nickname: string = ""] {
  let n = if ($nickname | is-empty) {
    (faker trade nickname)
  } else {
    $nickname
  }
  let body = {
    nickname: $n 
  }
  https put (host private) $body | get data
}

export def list [
  --page: int = 1
  --size: int = 100
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host public) $query | get data.items
}

export def ids [] {
  list | select user_id nickname | rename value description
}

export def view [id: string@ids] {
  https get (host public $id) | get data
}

export def ads [
  id: string@ids
  --page: int = 1
  --size: int = 100
  --ad-type: int = 1
] {
  let query = {
    page: $page
    size: $size
    ad_type: $ad_type
  }
  https get (host public $id ads) $query | get data
}

export def comment [] {
  https get (host private comment) | get data
}
