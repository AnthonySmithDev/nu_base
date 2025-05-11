
export-env {
  $env.FILE_MANAGER_PATH = ($env.HOME | path join .fm)
}

def read [action: string] {
  mkdir $env.FILE_MANAGER_PATH
  try {
    open ($env.FILE_MANAGER_PATH | path join $"($action).json")
  } catch {
    {}
  }
}

def write [action: string] {
  save --force ($env.FILE_MANAGER_PATH | path join $"($action).json")
}

def storage-get-items [action: string, group: string] {
  read $action | get -i $group
}

def storage-set-items [action: string, group: string, value: any] {
  read $action | upsert $group $value | write $action
}

export def copy [
  ...paths: path,
  --group(-g): string = "default",
] {
  let value = (storage-get-items copy $group | append $paths | uniq)
  storage-set-items copy $group $value
}

export def cut [
  ...paths: path,
  --group(-g): string = "default",
] {
  let value = (storage-get-items cut $group | append $paths | uniq)
  storage-set-items cut $group $value
}

export def ls [ --group(-g): string = "default" ] {
  {
    copy: (storage-get-items copy $group)
    cut: (storage-get-items cut $group)
  }
}

def action [] {
  [copy, cut]
}

export def clear [
  action: string@action
  --group(-g): string = "default"
] {
  storage-set-items $action $group {}
}

export def "paste copy" [
  dir?: path,
  --group(-g): string = "default",
] {
  let wd = ($dir | default $env.PWD)

  mut undo = []
  for $src in (storage-get-items copy $group) {
    let dst = ($wd | path join ($src | path basename))
    $undo = ($undo | append $dst)
    cp -v -r $src $dst
  }
  storage-set-items copy $group []
  storage-set-items undo_copy $group $undo
}

export def "paste cut" [
  dir?: path,
  --group(-g): string = "default",
] {
  let wd = ($dir | default $env.PWD)

  mut undo = []
  for $src in (storage-get-items cut $group) {
    let dst = ($wd | path join ($src | path basename))
    $undo = ($undo | append {src: $src, dst: $dst})
    mv -v $src $dst
  }
  storage-set-items cut $group {}
  storage-set-items undo_cut $group $undo
}

export def "undo copy" [ --group(-g): string = "default" ] {
  let items = (storage-get-items undo_copy $group)
  if ($items | is-empty) {
    print "No operations to undo"
    return
  }

  mut errors = []
  for $item in $items {
    if not ($item | path exists) {
      print $"Path ($item) does not exist, cannot undo"
      $errors = ($errors | append $item)
      continue
    }

    rm -v -r $item
  }

  if ($errors | length) == 0 {
    print "Operation undone successfully"
  } else {
    print $"Errors occurred while undoing:" $errors
  }

  storage-set-items undo_copy $group {}
}

export def "undo cut" [ --group(-g): string = "default" ] {
  let items = (storage-get-items undo_cut $group)
  if ($items | is-empty) {
    print "No operations to undo"
    return
  }

  mut errors = []
  for $item in $items {
    if ($item.src | path exists) {
      print $"File/directory already exists at ($item.src), cannot undo"
      $errors = ($errors | append ($item | insert type src))
      continue
    }
    if not ($item.dst | path exists) {
      print $"Destination path ($item.dst) does not exist, cannot undo"
      $errors = ($errors | append ($item | insert type dst))
      continue
    }

    mv -v $item.dst $item.src
  }

  if ($errors | length) == 0 {
    print "Operation undone successfully"
  } else {
    print $"Errors occurred while undoing:" $errors
  }

  storage-set-items undo_cut $group {}
}

export def "undo ls" [ --group(-g): string = "default" ] {
  {
    copy: (storage-get-items undo_copy $group)
    cut: (storage-get-items undo_cut $group)
  }
}
