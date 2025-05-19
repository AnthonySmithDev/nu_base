
export def host [path: string, query: record = {}] {
  {
    "scheme": $env.NANOPAY_SCHEME,
    "host": $env.NANOPAY_P2P_HOST,
    "port": $env.NANOPAY_P2P_PORT,
    "path": (['/api/v1/user' $path] | str join),
    "query": ($query | url build-query)
  } | url join
}

def header [] {
  [
    X-Device-Jwt (user jwt device)
    Authorization (user jwt access)
  ]
}

def body [r: record] {
  if $r.status == 500 {
    error make -u { msg: $"($r.body.code) - (ansi red_bold)($r.body.message)(ansi reset) ($r.body.data?)" }
  } else {
    return $r.body
  }
}

export def get [path: string, query: record = {}] {
  let r = http get -f -e -H (header) (host $path $query)
  body $r
}

export def post [path: string, data: record = {}, query: record = {}] {
  let r = http post -f -e -H (header) -t application/json (host $path $query) $data
  body $r
}

export def put [path: string, data: record = {}, query: record = {}] {
  let r = http put -f -e -H (header) -t application/json (host $path $query) $data
  body $r
}

export def del [path: string, data: record = {}, query: record = {}] {
  let r = http delete -f -e -H (header) -t application/json (host $path $query) -d $data
  body $r
}
