
export-env {
  $env.WS_HOST = "0.0.0.0"
  $env.WS_PORT = "9999"
}

export def server [token: string] {
  let url = $"ws://($env.HOST):3010/ws/v1/connect?token=($token)"
  http-to-ws --host $env.WS_HOST --port $env.WS_PORT $url
}

export def send [ data: record ] {
  http post http://($env.WS_HOST):($env.WS_PORT) ($data | to json)
}

export def typing [] {
  send {
    path: "/order/message/typing"
    body: {
      user_id: "3333"
      order_id: (random uuid)
    }
  }
}

export def --env set [port: string] {
  $env.WS_PORT = $port
}
