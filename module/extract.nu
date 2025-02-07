
export def tar [
  file?: string
  --dir(-d): string
] {
  mut args = ['-xf' $file]
  if $dir != null {
    mkdir $dir
    $args = ($args | append ['-C' $dir])
  }
  if (exists-external gum) {
    gum spin --spinner dot --title 'Extract tar...' -- tar ...$args
  } else {
    ^tar ...$args
  }
  rm -rf $file
}

export alias t = tar

export def zip [
  file?: string
  --dir(-d): string
] {
  mut args = ['-q' $file]
  if $dir != null {
    mkdir $dir
    $args = ($args | append ['-d' $dir])
  }
  if (^which gum | is-not-empty) {
    gum spin --spinner dot --title 'Extract zip...' -- unzip ...$args
  } else {
    unzip ...$args
  }
  rm -rf $file
}

export alias z = zip
