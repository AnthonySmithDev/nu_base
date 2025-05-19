
def host [path: string] {
  let path = (['/api/v1/upload' $path] | path join)
  {
    "scheme": $env.NANOPAY_SCHEME,
    "host": $env.NANOPAY_UPLOAD_HOST,
    "port": $env.NANOPAY_UPLOAD_PORT,
    "path": $path,
  } | url join
}

export def post [params: string, filename: path, --jwt: string] {
  if not ($filename | path exists) {
    error make -u { msg: $"(ansi red_bold)File not found: (ansi reset) ($filename)" }
  }
  let r = (https -f POST (host $params) Authorization:($jwt) file@($filename) | from json)
  if $r.status == "ERROR" {
    error make -u { msg: $"($r.code) - (ansi red_bold)($r.message)(ansi reset) ($r.data?)" }
  }
  return $r
}

export def get [path: string, --jwt: string] {
  let r = http get -f -e -H ['Authorization' $jwt] (host $path)
  if $r.status == 500 {
    error make -u { msg: $"($r.body.code) - (ansi red_bold)($r.body.message)(ansi reset) ($r.body.data?)" }
  }
  return $r.body
}
