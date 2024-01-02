
export def tar [
  file: string
  --dir(-d): string
] {
  if $dir != null {
    mkdir $dir
    if not (^which gum | is-empty) {
      gum spin --spinner dot --title 'Extract tar...' -- ['tar' '-xf' $file '-C' $dir]
    } else {
      ^tar -xf $file -C $dir
    }
  } else {
    if not (^which gum | is-empty) {
      gum spin --spinner dot  --title 'Extract tar...' -- ['tar' '-xf' $file]
    } else {
      ^tar -xf $file
    }
  }
  rm -rf $file
}

export def zip [
  file: string
  --dir(-d): string
] {
  if $dir != null {
    mkdir $dir
    if not (^which gum | is-empty) {
      gum spin --spinner dot --title 'Extract zip...' -- unzip -q $file -d $dir
    } else {
      unzip -q $file -d $dir
    }
  } else {
    if not (^which gum | is-empty) {
      gum spin --spinner dot --title 'Extract zip...' -- unzip -q $file
    } else {
      unzip -q $file
    }
  }
  rm -rf $file
}
