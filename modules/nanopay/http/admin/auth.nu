
def body [r: record] {
  if $r.status == 500 {
    error make -u { msg: $"($r.body.code) - (ansi red_bold)($r.body.message)(ansi reset) ($r.body.data?)" }
  } else {
    return $r.body
  }
}

def names [] {
  sql from admin_accounts | get username
}

def post [path: string, data: record] {
  let r = http post -f -e -t application/json (https host $path) $data
  body $r
}

export def --env signin [name: string@names] {
  $env.NANOPAY_ADMIN_NAME = $name
  let body = {
    username: $env.NANOPAY_ADMIN_NAME
    password: $env.NANOPAY_ADMIN_PASS
  }
  jwt write (post '/auth/signin' $body | get data)
}

export def password [name: string@names, password: string] {
  let body = {
    username: $name
    old_password: $password
    new_password: $env.NANOPAY_ADMIN_PASS
  }
  post '/auth/password/change' $body | get data
}

export def --env set [name: string@names] {
  $env.NANOPAY_ADMIN_NAME = $name
}
