
let path = $env.HOME | path join .env_change.pwd
let closure = { |before, after| $after | save --force $path }
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD | append $closure

if ($env.ZELLIJ? | is-empty) and ($path | path exists) {
  let path = open $path | to text
  if ($path | path exists) { cd $path }
}
