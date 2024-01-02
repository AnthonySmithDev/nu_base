
export-env {
  $env.FM_TMP_DIR = ($env.HOME | path join 'tmp')
  mkdir $env.FM_TMP_DIR
}

def path_join [mark: string] {
  if ($mark | is-empty) {
    $env.FM_TMP_DIR | path join 'default'
  } else {
    $env.FM_TMP_DIR | path join $mark
  }
}

export def clean [] {
  rm -rf $'($env.FM_TMP_DIR)/*'
}

export def tree [] {
  let dirs = (ls -s $env.FM_TMP_DIR | where type == dir | get name)
  mut marks = {}
  for $it in $dirs {
    let value = (ls -s ($env.FM_TMP_DIR | path join $it) | get name)
    $marks = ($marks | insert $it $value)
  }
  $marks
}

export def list [
    --mark (-m): string
  ] {

  let destination = (path_join $mark)

  if ($destination | path exists) {
    ls -a $destination
  }
}

export def cut [
    ...names: string
    --mark (-m): string
  ] {

  let destination = (path_join $mark)
  mkdir $destination

  for $name in $names {
    let source = ($env.PWD | path join $name)
    mv $source $destination
  }
}

export def copy [
    ...names: string
    --mark (-m): string
  ] {

  let destination = (path_join $mark)
  mkdir $destination

  for $name in $names {
    let source = ($env.PWD | path join $name)
    cp -r $source $destination
  }
}

export def paste [
    --mark (-m): string
  ] {

  let destination = ($env.PWD)

  let source = (path_join $mark)
  if ($source | path exists) {
    let files = (ls $source | get name)
    for $file in $files {
      mv $file $destination
    }
    rm -rf $source
  }
}
