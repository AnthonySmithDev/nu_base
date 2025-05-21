#!/usr/bin/env -S nu --stdin

export-env {
  $env.CLIPBOARD_PATH = ($env.HOME | path join .clipboard)
}

export def copy [] {
  wl-copy
}

export def write [] {
  try { save --force $env.CLIPBOARD_PATH }
}

export def main [] {
  let stdin = $in
  $stdin | copy
  $stdin | write
}

export def read [] {
  try { open $env.CLIPBOARD_PATH }
}

export def paste [] {
  wl-paste
}

export def sync [] {
  paste | write
}

const default_host = "anthony-desktop-work"
const default_port = 12345

export def serv [
  --port: int = $default_port,
] {
  try {
    nc -l -W 1 -p $port
  } catch {
    error make -u { msg: "Error starting clipboard server" }
  }
}

export def post [
  --host: string = $default_host,
  --port: int = $default_port,
] {
  try {
    nc $host $port
  } catch {
    error make -u { msg: "Error connecting to clipboard server" }
  }
}

def time-sleep [] {
  try {
    sleep 250ms
  } catch {
    error make -u { msg: "Cancel" }
  }
}

export def receiver [
  --port: int = $default_port
] {
  print "Start Receiver"
  mut last = ""
  loop {
    let clipboard = nc serv $port
    if $clipboard == $last {
      time-sleep
      continue
    }

    $clipboard | write
    $clipboard | copy

    print " - clipboard received"
    $last = $clipboard
  }
}

export def watch [
  --host: string = $default_host,
  --port: int = $default_port,
] {
  print "Start Watch"
  mut last = ""
  loop {
    let clipboard = read
    if $clipboard == $last {
      time-sleep
      continue
    }

    $clipboard | nc post $host $port

    print " - clipboard send"
    $last = $clipboard
  }
}

def "main write" [] { write }

def "main read" [] { read }

def "main copy" [] { copy }

def "main paste" [] { paste }

def "main sync" [] { sync }

def "main serv" [
  --port: int,
] {
  serv --port $port
}

def "main post" [
  --host: string = $default_host,
  --port: int = $default_port,
] {
  post --host $host --port $port
}

def "main receiver" [
  --port: int
] {
  receiver --port $port
}

def "main watch" [
  --host: string = $default_host,
  --port: int = $default_port,
] {
  watch --host $host --port $port
}
