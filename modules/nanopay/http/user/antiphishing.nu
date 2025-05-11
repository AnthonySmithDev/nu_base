
def host [...path: string] {
  '/security/anti/phishing' | append $path | path join
}

export def create [] {
  let body = {
    antiphishing_code: "AASSDD"
  }
  https post (host) $body | get data
}

export def view [] {
  https get (host) | get data
}

export def update [] {
  let body = {
    antiphishing_code: "DDSSAA"
  }
  https put (host) $body | get data
}
