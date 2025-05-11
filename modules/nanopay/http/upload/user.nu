
def host [...path: string] {
  [user] | append $path | path join
}

export def create [category: string, file: path] {
  https post --jwt (user jwt access) (host $category) $file | get data
}

export def view [id: string] {
  https get --jwt (user jwt access) (host $id) | get data
}
