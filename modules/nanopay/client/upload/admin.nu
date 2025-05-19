
def host [...path: string] {
  [admin] | append $path | path join
}

export def create [category: string, file: path] {
  https post --jwt (admin jwt access) (host $category) $file | get data
}

export def view [id: string] {
  https get --jwt (admin jwt access) (host $id) | get data
}
