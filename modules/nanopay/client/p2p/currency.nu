
def host [path: string = ''] {
  '/public/currency' | path join $path
}

export def list [] {
  https get (host) | get data
}

export def view [] {
  https get (host 'PEN') | get data
}
