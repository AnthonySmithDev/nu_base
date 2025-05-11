
export-env {
  $env.CLOCK_DIR = ($env.HOME | path join .clock)
}

export def run [name: string, duration: duration, closure: closure] {
  mkdir $env.CLOCK_DIR
  let filename = ($env.CLOCK_DIR | path join $name)

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
  rm -rf ($env.CLOCK_DIR | path join $name)
}

export def clean [] {
  rm -rf $env.CLOCK_DIR
}
