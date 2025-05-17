
def paths [
  --path(-p): string = ".",
  --search(-s): string
  --type(-t): string
  ] {
  mut paths = []
  if ($search != null) {
    $paths = if ($type != null) {
      fd  --hidden --type $type $search --full-path $path | lines
    } else { fd  --hidden  $search --full-path $path | lines }
  } else {
    let list = ls -la $path
    $paths = if ($type != null) {
      $list | where type == $type | get name
    } else { $list | get name }
  }
  return $paths
}

export def main [
  path: string = ".",
  basename?: string,
  --search(-s): string,
  --file(-f),
  --dir(-d),
] {
  if not ($path | path exists) {
    print "La ruta especificada no existe."
    return
  }

  let type = if $file { "file" } else if $dir { "dir" } else { null }
  if ($path != ".") and ($search == null) and ($type == null) {
    let destination_path = if ($basename | is-empty) {
      gum input --header "Rename" --value ($path | path basename)
    } else {
      ($path | path dirname | path join $basename)
    }
    mv $path $destination_path
    return
  }

  let list_paths = paths -p $path -s $search -t $type
  if ($list_paths | is-empty) {
    print "No hay elementos para renombrar."
    return
  }

  let renamed_paths = (tempeditor $list_paths --suffix .txt --output | lines)
  if ($renamed_paths | length) != ($list_paths | length) {
    print "No hay el mismo numero de elementos para renombrar."
    return
  }

  for index in ($list_paths | enumerate | get index) {
    let source = ($list_paths | get $index)
    let destination = ($renamed_paths | get $index)
    if $source != $destination {
      mv -i $source $destination
    }
  }
}
