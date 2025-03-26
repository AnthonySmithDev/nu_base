
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

export def git-down [ repo: string, dir: string, --tag(-t): string --branch(-b): string ] {
  if ($dir | path exists) {
    git -C $dir pull
  } else {
    git clone $repo $dir
  }
  if ($tag | is-not-empty) {
    git -C $dir checkout $tag
  }
  if ($branch | is-not-empty) {
    git -C $dir switch $branch
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
