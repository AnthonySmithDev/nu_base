
export-env {
  $env.NANOPAY_USER_NAME = 'anthony'
  $env.NANOPAY_USER_PASS = 'asdASD123'
  $env.NANOPAY_ADMIN_NAME = 'superadmin'
  $env.NANOPAY_ADMIN_PASS = 'asdASD123'
}

def local [host: string] {
  return {
    DB: {
      MONGO_ROOT_USER: 'nanopay_root_user'
      MONGO_ROOT_PASS: 'nanopay_root_pass'
      MONGO_USER: 'nanopay_user'
      MONGO_PASS: 'nanopay_pass'
      MONGO_HOST: $host
      MONGO_PORT: 27018
      MONGO_NAME: 'nanopay'

      REDIS_PASS: 'nanopay_pass'
      REDIS_HOST: $host
      REDIS_PORT: 6380
    }
    API: {
      NANOPAY_SCHEME: 'http'
      NANOPAY_USER_HOST: $host
      NANOPAY_USER_PORT: '3001'
      NANOPAY_ADMIN_HOST: $host
      NANOPAY_ADMIN_PORT: '3002'
      NANOPAY_P2P_HOST: $host
      NANOPAY_P2P_PORT: '3010'
      NANOPAY_UPLOAD_HOST: $host
      NANOPAY_UPLOAD_PORT: '3003'
    }
  }
}

def kube [host: string] {
  return {
    DB: {
      MONGO_ROOT_USER: 'payzum_admin'
      MONGO_ROOT_PASS: 'wiweh7FOG3WJWGT0PSOX8GDSdambSvm2k6tLicj00pZlw6wS3N'
      MONGO_USER: 'nanopay_admin'
      MONGO_PASS: 'wiweh7FOG3WJWGT0PSOX8GDSdambSvm2k6tLicj00pZlw6wS3N'
      MONGO_HOST: 'localhost'
      MONGO_PORT: 17018
      MONGO_NAME: 'nanopay'

      REDIS_PASS: '73dOyIwLaKZ88adiUZypJufiq4e4y7C4PYmFAq4EkfLi9uTWYW'
      REDIS_HOST: 'localhost'
      REDIS_PORT: 16380
    }
    API: {
      NANOPAY_SCHEME: 'https'
      NANOPAY_USER_HOST: $'api_user.($host)'
      NANOPAY_USER_PORT: ''
      NANOPAY_ADMIN_HOST: $'api_admin.($host)'
      NANOPAY_ADMIN_PORT: ''
      NANOPAY_P2P_HOST: $'api-p2p.($host)'
      NANOPAY_P2P_PORT: ''
      NANOPAY_UPLOAD_HOST: $'service-upload.($host)'
      NANOPAY_UPLOAD_PORT: ''
    }
  }
}

const hosts = {
  local: {
    local: "0.0.0.0"
    anthony: "192.168.0.20"
    jean: "192.168.0.21"
  }
  tailscale: {
    anthony: "100.100.194.113"
    jean: "100.97.221.20"
  }
  kube: {
    dev: "nanopay.one"
    prod: "payzum.com"
  }
}

const colors = {
  local: {
    anthony: "green_bold"
    jean: "blue_bold"
  }
  tailscale: {
    anthony: "light_green_bold"
    jean: "light_blue_bold"
  }
  kube: {
    dev: "cyan_bold"
    prod: "purple_bold"
  }
}

def get-host-type [] {
  $hosts | columns
}

def get-host-name [context: string] {
  $hosts | get ($context | split words | get 2) | columns
}

def get-config [
  type: string@get-host-type = "local",
  name: string@get-host-name = "anthony",
] {
  let ip = ($hosts | get $type | get $name)
  if $type == "kube" {
    return (kube $ip)
  } 
  return (local $ip)
}

export def --env api [
  type: string@get-host-type = "local",
  name: string@get-host-name = "anthony",
] {
  load-env (get-config $type $name | get API)
}

export def --env db [
  type: string@get-host-type = "local",
  name: string@get-host-name = "anthony",
] {
  load-env (get-config $type $name | get DB)
}

const CONFIG_FILE = ("~/.mode.json" | path expand)

def write-mode [host: record] {
  $host | save --force $CONFIG_FILE
}

export def --env set [
  type: string@get-host-type = "local",
  name: string@get-host-name = "anthony",
] {
  let color = ($colors | get $type | get $name)
  print $color
  print $'(ansi $color) Mode: ($type) ($name) (ansi reset)'
  let host = {
    type: $type
    name: $name
  }
  write-mode $host
  load
}

def read-mode [] {
  if ($CONFIG_FILE | path exists) {
    return (open $CONFIG_FILE)
  }
  return {
    type: local
    name: local
  }
}

export def --env load [] {
  let host = read-mode
  db $host.type $host.name
  api $host.type $host.name
}
