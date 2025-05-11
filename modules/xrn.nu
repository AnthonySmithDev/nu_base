
export def main [
  path: string = ".",
  --search(-s): string,
  --file(-f),
  --dir(-d),
] {
  if not ($path | path exists) {
    print "La ruta especificada no existe."
    return
  }

  let type = if $file { "file" } else if $dir { "dir" } else { null }
  let list_paths = paths -p $path -s $search -t $type
  if ($list_paths | is-empty) {
    print "No hay elementos para eliminar."
    return
  }

  let selected_paths = (tempeditor $list_paths --suffix .txt --output | lines)
  if ($selected_paths | length) == ($list_paths | length) {
    print "Hay el mismo numero de elementos no se eliminara nada."
    return
  }

  let deleted_paths = ($list_paths | where { |it| $it not-in $selected_paths })
  for path in $deleted_paths {
    rm -rf $path
  }
  return $deleted_paths
}
