
export def --env env [
  --host: string = 'localhost'
  --port: int = 8888
] {
  $env.proxy_host = $host
  $env.proxy_port = $port
  $env.http_proxy = $'http://($host):($port)'
  $env.https_proxy = $'https://($host):($port)'
}

export def mitmproxy-crt [] {
  let src = ($env.HOME | path join .mitmproxy mitmproxy-ca-cert.pem)
  let dir = ($env.HOME | path join Documents certs)
  let dst = ($dir | path join mitmproxy.pem)
  if not ($src | path exists) {
    return
  }
  mkdir $dir
  cp $src $dst
  sudo cp $src /usr/local/share/ca-certificates/mitmproxy.crt
  sudo update-ca-certificates
}

export def proxify-crt [] {
  let src = ($env.HOME | path join .config proxify cacert.pem)
  let dir = ($env.HOME | path join Documents certs)
  let dst = ($dir | path join proxify.pem)
  if not ($src | path exists) {
    return
  }
  mkdir $dir
  cp $src $dst
  sudo cp $src /usr/local/share/ca-certificates/proxify.crt
  sudo update-ca-certificates
}
