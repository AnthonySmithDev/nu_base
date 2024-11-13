
export def seed [] {
  ^cat /dev/urandom | tr -dc '0-9A-F' | head -c 64
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

def cat [file: string@files] {
  bat -P --plain $file
}
