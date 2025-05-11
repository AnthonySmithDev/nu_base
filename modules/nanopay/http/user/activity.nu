
def host [...path: string] {
  '/security/activity' | append $path | path join
}

export def login [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host login) | get data
}

export def security [
  --page: int = 1
  --size: int = 10
] {
  let query = {
    page: $page
    size: $size
  }
  https get (host security) | get data
}
