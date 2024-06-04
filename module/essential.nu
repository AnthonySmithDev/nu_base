
export def is_debian [] {
  (sys host | get name) in ["Ubuntu"]
}

export def git_clone [repo: string, path: string] {
  if ($path | path exists) {
    git -C $path pull
  } else {
    git clone $repo $path
  }
}

export def with-wd [path: string, closure: closure] {
  let pwd = pwd
  cd $path
  do $closure
  cd $pwd
}
