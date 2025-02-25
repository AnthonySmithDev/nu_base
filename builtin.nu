
export def seed [] {
  open /dev/urandom | tr -dc '0-9A-F' | head -c 64
}

export def path-safe [] {
  tr -cd '[:alnum:] ' | str trim
}

export def exists-group [group: string] {
  open /etc/group | str contains $group
}

export def exists-user [user: string] {
  open /etc/passwd | str contains $user
}

export def exists-external [app: string] {
  which $app --all | where type == external | is-not-empty
}

export def path-not-exists [] {
  not ($in | path exists)
}

export def add-execute [file: path] {
  chmod 777 $file
}

export def --env mkcd [name: string] {
  mkdir $name
  cd $name
}

export def --env with-wd [path: string, closure: closure] {
  let pwd = pwd
  cd $path
  do $closure
  cd $pwd
}

export def git-down [repository: string, path: string, tag?: string] {
  if ($path | path exists) {
    git -C $path pull
  } else {
    git clone $repository $path
  }
  if ($tag | is-not-empty) {
    git -C $path switch $tag
  }
}

def files [] {
  fd --type file | lines
}

def dirs [] {
  fd --type dir | lines
}

def json [] {
  to json | jless --mode line
}

def to-table [] {
  to csv | tr ',' '\t'
}

def from-table [] {
  tr '\t' ',' | from csv
}

def split-tabs [] {
  split column "\t"
}

def "url filename" [] {
  url parse | get path | path parse | $"($in.stem).($in.extension)"
}

def "http download" [url: string, --output(-o): string] {
  let filename = if ($output | is-not-empty) { $output } else {
    $url | url filename
  }
  try {
    http get $url | save --progress --force $filename
  } catch {
    error make -u { msg: $"URL not found: ($url)" }
  }
}

def tempeditor [] {
  let input = $in

  let temp = mktemp --tmpdir
  if ($input | is-not-empty) {
    $input | str trim | save --force $temp
  }

  hx $temp
  return (open $temp | str trim)
}
