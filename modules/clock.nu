
export-env {
  $env.CLOCK_DIR = ($env.HOME | path join .clock)
}

export def filename [name: string] {
  mkdir $env.CLOCK_DIR
  return ($env.CLOCK_DIR | path join $name)
}

def complete-names [] {
  ls -s $env.CLOCK_DIR | get name
}

export def run [
  name: string@complete-names,
  duration: duration,
  closure: closure,
  --json(-j),
] {
  let filename = filename $name
  let should_execute_closure = should_execute_closure $filename $duration

  if $should_execute_closure {
    execute_and_cache $closure $filename $json
  } else {
    get_cached_result $filename $json
  }
}

def should_execute_closure [filename: string, duration: duration] {
  if not ($filename | path exists) { return true }

  let output = (open $filename | str trim)
  if ($output | is-empty) { return true }

  let modified = (ls $filename | first | get modified)
  ($modified + $duration) <= (date now)
}

def execute_and_cache [
  closure: closure,
  filename: string,
  json: bool
] {
  let output = do $closure

  if $json {
    let json_output = ($output | to json)
    $json_output | save --force $filename
    $json_output
  } else {
    $output | save --force $filename
    $output
  }
}

export def clean [] {
  rm -rfp $env.CLOCK_DIR
}

export def list [name: string@complete-names] {
  let filename = filename $name
  if not ($filename | path exists) {
    error make {msg: "File not found"}
  }
  open $filename | from json
}

export def add [name: string@complete-names, value: string] {
  let filename = filename $name
  if not ($filename | path exists) {
    error make {msg: "File not found"}
  }
  open $filename | from json
  | append $value | to json
  | save --force $filename
}

export def delete [name: string@complete-names, value?: string] {
  let filename = filename $name
  if not ($filename | path exists) {
    error make {msg: "File not found"}
  }
  if ($value | is-empty) {
    rm -rfp $filename
    return $"Delete ($name)"
  }
  let data = (open $filename | from json)
  let filtered = ($data | where {|x| $x != $value})
  $filtered | to json | save --force $filename
  return $"Delete ($value) in ($name)"
}
