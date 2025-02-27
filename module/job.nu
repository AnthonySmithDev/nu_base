
export-env {
  $env.JOB_DIR = ($env.HOME | path join job)
}

export def run [name: string, duration: duration, closure: closure] {
  mkdir $env.JOB_DIR
  let filename = ($env.JOB_DIR | path join $name)

  let should_execute_closure = if ($filename | path exists) {
    let output = (open $filename | str trim)
    if ($output | is-empty) {
      true
    } else {
      let modified = (ls $filename | first | get modified)
      ($modified + $duration) <= (date now)
    }
  } else { true }

  if $should_execute_closure {
    let output = do $closure
    $output | save --force $filename
    return $output
  }

  return (open $filename)
}

export def delete [name: string] {
  rm -rf ($env.JOB_DIR | path join $name)
}

export def clean [] {
  rm -rf $env.JOB_DIR
}
