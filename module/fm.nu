
export-env {
  $env.FM_TMP_DIR = ($env.HOME | path join 'tmp')
}

def dest [mark?: string] {
  mkdir $env.FM_TMP_DIR
  if ($mark == null) {
    $env.FM_TMP_DIR | path join 'default'
  } else {
    $env.FM_TMP_DIR | path join $mark
  }
}

export def clean [] {
  rm -rf $'($env.FM_TMP_DIR)/*'
}

export def dirs [] {
  ls -s $env.FM_TMP_DIR | where type == dir | get name
}

export def tree [] {
  mut marks = {}
  for $it in (dirs) {
    let value = (ls -s ($env.FM_TMP_DIR | path join $it) | get name)
    $marks = ($marks | insert $it $value)
  }
  $marks
}

export def list [
    --mark (-m): string
  ] {

  let destination = (dest $mark)

  if ($destination | path exists) {
    ls -a $destination
  }
}

export def cut [
    ...names: string
    --mark (-m): string
  ] {

  let destination = (dest $mark)
  mkdir $destination

  for $name in $names {
    let source = ($env.PWD | path join $name)
    mv -p $source $destination
  }
}

export def copy [
    ...names: string
    --mark (-m): string
  ] {

  let destination = (dest $mark)
  mkdir $destination

  for $name in $names {
    let source = ($env.PWD | path join $name)
    cp -p -v -r $source $destination
  }
}

export def paste [
    dir: path = ''
    --mark (-m): string
  ] {

  let destination = ($env.PWD | path join $dir)

  let source = (dest $mark)
  if ($source | path exists) {
    let files = (ls -a $source | get name)
    for $file in $files {
      mv -p -v $file $destination
    }
    if (ls -a $source | is-empty) {
      rm -rf $source
    }
  }
}

