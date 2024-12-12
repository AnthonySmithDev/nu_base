
export def filter [--multi (-m)] {
  let preview = 'eza --tree --color=always --icon=always {}'
  if $multi {
    fd --type directory | fzf --layout reverse --border --preview $preview -m | lines
  } else {
    fd --type directory | fzf --layout reverse --border --preview $preview | str trim
  }
}

export def --env open [] {
  if (fd --type directory | is-empty) {
    print 'list is empty'
  } else {
    let dir = (filter)
    if not ($dir | is-empty) {
      cd $dir
    }
  }
}

export def new [...names: string] {
  if ($names | is-empty) {
    print 'names is empty'
    return
  }
  let dest = (filter)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $name in $names {
    mkdir ($dest | path join $name)
  }
}

export def cp [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  let dest = (filter)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $dir in $src {
    ^cp -r $dir $dest
  }
}

export def cl [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  for $dir in $src {
   let dest = (gum input --value $dir)
    if ($dest | is-empty) {
      print 'destination is empty'
      return
    }
    ^cp $dir $dest
  }
}

export def mv [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  let dest = (filter)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $dir in $src {
    ^mv $dir $dest
  }
}

export def ed [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  for $dir in $src {
    let dest = (gum input --value $dir)
    if ($dest | is-empty) {
      print 'destination is empty'
      continue
    }
    ^mv $dir $dest
  }
}

export def rn [] {
  let src = (filter)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  let dirname = ($src | path dirname)
  let basename = ($src | path basename)
  let name = (gum input --value $basename)
  if ($name | is-empty) {
    print 'name is empty'
    return
  }
  let dest = ($dirname | path join $name)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  ^mv $src $dest
}

export def rm [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  try {
    gum confirm
  } catch {
    return
  }
  for $name in $src {
    ^rm -rf $name
  }
}

