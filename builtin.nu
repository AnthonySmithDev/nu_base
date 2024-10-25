
export def seed [] {
  cat /dev/urandom | tr -dc '0-9A-F' | head -c 64
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
