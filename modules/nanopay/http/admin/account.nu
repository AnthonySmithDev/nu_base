
def host [...path: string] {
   '/account' | append $path | path join
}

export def view [] {
   https get (host) | get data
}
