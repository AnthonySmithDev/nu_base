
def dir [] {
  ($env.HOME | path join payzum $env.NANOPAY_ADMIN_HOST admin)
}

def file [] {
  (dir | path join $"($env.NANOPAY_ADMIN_NAME).json")
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
    error make -u {msg: "Admin session not found"}
  }
  open (file)
}

export def access [] {
  read | get access
}

export def refresh [] {
  read | get refresh
}

export def device [] {
  read | get device
}
