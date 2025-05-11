
export-env {
  $env.TPLINK_HOST = "192.168.0.1"
  $env.TPLINK_USER = "Anthony"
  $env.TPLINK_PASS = "Smith"
}

def token [] {
  [$env.TPLINK_USER $env.TPLINK_PASS] | str join ':' | encode base64
}

def authorization [] {
  $"Authorization=Basic (token)"
}

def LAN_WLAN [ --ssid: string, --channel: int, --enable ] {
  mut data = []
  if ($ssid != null) {
    $data = ($data | append $"SSID=($ssid)")
  }
  if ($channel != null) {
    $data = ($data | append $"Channel=($channel)")
  }
  if ($enable != null) {
    $data = ($data | append $"Enable=($enable | into int)")
  }
  let length = ($data | length)
  $data | prepend $"[LAN_WLAN#1,1,0,0,0,0#0,0,0,0,0,0]0,($length)" | each {|it| $it + "\r\n"} | str join
}

def request [body: string] {
  let headers = [
    Cookie (authorization)
    Origin $"http://($env.TPLINK_HOST)"
    Referer $"http://($env.TPLINK_HOST)/mainFrame.htm"
  ]
  http post --headers $headers $"http://($env.TPLINK_HOST)/cgi?2&" $body
}

export def on [] {
  request (LAN_WLAN --enable)
}

export def off [] {
  request (LAN_WLAN)
}
