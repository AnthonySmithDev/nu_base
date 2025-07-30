
let path = ($env.HOME | path join .env_change.pwd)

$env.config.hooks = {
  env_change: {
    PWD: [{|before, after| $after | save --force $path }]
  }
}

if ($env.ZELLIJ? | is-empty) and ($path | path exists) {
  let path = (open $path | to text)
  if ($path | path exists) {
    cd $path
  }
}
