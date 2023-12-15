
export def spawn [
    command: closure   # the command to spawn
] {
  if (ps | where name =~ pueued | is-empty) {
    pueued -d
  }
  let commands = (view source $command | str trim -l -c '{' | str trim -r -c '}')
  let args = [
    'nu'
    '--config' ($nu.config-path)
    '--env-config' ($nu.env-path)
    $'--commands "($commands)"'
  ]
  let job_id = (pueue add -p $args)
  {"job_id": $job_id}
}
