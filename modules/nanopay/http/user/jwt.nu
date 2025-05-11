
def dir [] {
  ($env.HOME | path join payzum $env.NANOPAY_USER_HOST user)
}

def file [] {
  (dir | path join $"($env.NANOPAY_USER_NAME).json")
}

export def write [data: record] {
  if not (dir | path exists) {
    mkdir (dir)
  }
  $data | to json | save -f (file)
  return { status: "OK" }
}

export def read [] {
  if not (file | path exists) {
    error make -u {msg: "User session not found"}
  }
  open (file)
}

export def access [] {
  read | get jwt_access
}

export def refresh [] {
  read | get jwt_refresh
}

export def device [] {
  read | get jwt_device
}
