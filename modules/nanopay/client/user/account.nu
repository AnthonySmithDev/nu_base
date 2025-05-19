
def host [...path: string] {
  '/account' | append $path | path join
}

export def view [] {
  https get (host) | get data
}

export def update [] {
  let body = {
    "nickname": (form nickname)
  }
  https put (host profile) $body | get data
}

export def nickname [name: string] {
  let body = {
    "nickname": $name
  }
  https put (host profile) $body | get data
}
