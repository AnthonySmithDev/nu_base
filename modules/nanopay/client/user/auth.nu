
def host [path: string, query: record = {}] {
  https host $path $query
}

def body [r: record] {
  if $r.status == 500 {
    error make -u { msg: $"($r.body.code) - ($r.body.message): ($r.body.data?)" }
  } else {
    return $r.body
  }
}

def post [url: string, body: record, header: list = []] {
  let r = http post -f -e -t application/json -H $header $url $body
  body $r
}

def names [] {
  ["anthony" "smith" "aguirre" "bejar"]
}

def signup-create [] {
  let body = {
    "email": ($env.NANOPAY_USER_NAME + "@gmail.com")
    "password": $env.NANOPAY_USER_PASS
  }
  post (host /auth/email/signup) $body | get data
}

def signup-register [authorization: string] {
  let body = {code: '000000'}
  let header = [
    User-Device terminal
    Authorization $authorization
  ]
  post (host /auth/email/signup/register) $body $header | get data
}

export def --env signup [name: string@names] {
  set $name
  let r = signup-create
  let jwt = signup-register $r
  jwt write $jwt
}

def signin-create [] {
  let body = {
    "email": ($env.NANOPAY_USER_NAME + "@gmail.com")
    "password": $env.NANOPAY_USER_PASS
  }
  post (host /auth/email/signin) $body | get data
}

def signin-register [authorization: string] {
  let query = {
    otp_code: "111111"
    email_code: "111111"
    phone_code: "111111"
  }
  let header = [
    User-Device terminal
    Authorization $authorization
  ]
  post (host /auth/2fa/login $query) {} $header | get data
}

export def --env signin [name: string@names] {
  set $name
  let r = signin-create
  let jwt = signin-register $r.jwt_2fa
  jwt write $jwt
}

export def --env set [name: string@names] {
  $env.NANOPAY_USER_NAME = $name
}
