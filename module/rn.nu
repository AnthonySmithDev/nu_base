
export def main [
  source_path: string = ".",
  basename?: string,
  --file(-f),
  --dir(-d)
] {
  if not ($source_path | path exists) {
    print "La ruta especificada no existe."
    return
  }

  if (not $file and not $dir) and ($source_path != ".") {
    let destination_path = if ($basename | is-empty) {
      gum input --header "Rename" --value ($source_path | path basename)
    } else {
      ($source_path | path dirname | path join $basename)
    }
    mv $source_path $destination_path
    return
  }

  let list = ls $source_path

  mut paths_to_rename = []
  if $file or $dir {
    let path_type = if $file { "file" } else { "dir" }
    $paths_to_rename = ($list | where type == $path_type | get name)
  } else if $source_path == "." {
    $paths_to_rename = ($list | get name)
  }

  if ($paths_to_rename | is-empty) {
    print "No hay elementos para renombrar."
    return
  }

  let temp_file = mktemp --tmpdir --suffix .txt
  $paths_to_rename | save --force $temp_file
  hx $temp_file
  let renamed_paths = (open $temp_file | lines)

  for index in ($paths_to_rename | enumerate | get index) {
    let source = ($paths_to_rename | get $index)
    let destination = ($renamed_paths | get $index)
    if $source != $destination {
      mv -i $source $destination
    }
  }

  rm $temp_file
}
