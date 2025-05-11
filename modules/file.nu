
export def filter [--multi (-m)] {
  let preview = 'bat --plain --number --color=always {}'
  if $multi {
    fd --type file | fzf --layout reverse --border --preview $preview -m | lines
  } else {
    fd --type file | fzf --layout reverse --border --preview $preview | str trim
  }
}

export def open [] {
  if (fd --type file | is-empty) {
    print 'list is empty'
  } else {
    let file = (filter)
    if not ($file | is-empty) {
      hx $file
    }
  }
}

export def new [...names: string] {
  if ($names | is-empty) {
    print 'names is empty'
    return
  }
  let dest = (dir filter -m)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $dir in $dest {
    for $name in $names {
      touch ($dir | path join $name)
    }  
  }
}

export def cp [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  let dest = (dir filter)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $file in $src {
    ^cp $file $dest
  }
}

export def cl [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  for $file in $src {
   let dest = (gum input --value $file)
    if ($dest | is-empty) {
      print 'destination is empty'
      return
    }
    ^cp $file $dest
  }
}

export def mv [] {
  let src = (filter -m)
  if ($src | is-empty) {
    print 'source is empty'
    return
  }
  let dest = (dir filter)
  if ($dest | is-empty) {
    print 'destination is empty'
    return
  }
  for $file in $src {
    ^mv $file $dest
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
  let srcs = (filter -m)
  if ($srcs | is-empty) {
    print 'source is empty'
    return
  }
  for $src in $srcs {
    let dirname = ($src | path dirname)
    let basename = ($src | path basename)
    let name = (gum input --value $basename --header $dirname)
    if ($name | is-empty) {
      print 'name is empty'
      return
    }
    let dest = ($dirname | path join $name)
    if ($dest | is-empty) {
      print 'destination is empty'
      return
    }
    if ($basename == $name) {
      return
    }
    ^mv $src $dest
  }
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
    ^rm $name
  }
}

