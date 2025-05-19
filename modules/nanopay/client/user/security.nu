
def host [...path: string] {
  '/security' | append $path | path join
}

export def view [] {
  https get (host) | get data
}

export def password [] {
  let body = {
    password: $env.NANOPAY_USER_PASS
    new_password: $env.NANOPAY_USER_PASS
  }
  https put (host password) $body | get data
}
