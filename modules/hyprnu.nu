#!/usr/bin/env nu

export def monitors [] {
  hyprctl monitors -j | from json
}

export def clients [] {
  hyprctl clients -j | from json
}

export def activewindow [] {
  hyprctl activewindow -j | from json
}

def filter [value: string, --title(-t), --class(-c)] {
  let clients = clients
  let client = if $title {
    ($clients | where title == $value | get 0?)
  } else if $class {
    ($clients | where class == $value | get 0?)
  }
  return $client
}

export def move [value: string, --title, --class] {
  let active = activewindow
  let client = filter $value --title=$title --class=$class

  if ($client.grouped | is-not-empty) {
    hyprctl dispatch moveoutofgroup address:($client.address)
  }

  if not $client.floating {
    hyprctl dispatch setfloating address:($client.address)
  }

  if not $client.pinned {
    hyprctl dispatch pin address:($client.address)
  }

  hyprctl dispatch focuswindow address:($client.address)

  let waybar_is_run = (^ps -a | from ssv -m 1| where CMD =~ waybar | is-not-empty)
  let resize_height = if $waybar_is_run { 480 } else { 500 }

  let monitor = (monitors | where id == $active.monitor | first)
  let monitor_y = if $waybar_is_run { $monitor.y + 40 } else { $monitor.y }
  if $monitor.transform == 0 { # horizontal
    let width = $monitor.width
    let monitor_height = $monitor.height
    let waybar_height = if $waybar_is_run {40} else {0}
    let padding = 20

    let window_width = 920
    let window_height = ((($monitor_height - $waybar_height) * 0.5) - ($padding * 2))

    if ("top" in $client.tags) {
      hyprctl dispatch moveactive exact ($monitor.x + 980) ($monitor_height - $window_height - $padding)
    } else {
      hyprctl dispatch moveactive exact ($monitor.x + 980) ($monitor.x + $waybar_height + $padding)
    }
    hyprctl dispatch resizeactive exact $window_width $window_height
  } else if $monitor.transform == 1  { # vertical
    let monitor_width = $monitor.height
    let monitor_height = $monitor.width
    let waybar_height = if $waybar_is_run {40} else {0}
    let padding = 20

    let window_width = 860
    let window_height = ((($monitor_width - $waybar_height) * 0.5) - ($padding * 2))

    if ("top" in $client.tags) {
      hyprctl dispatch moveactive exact ($monitor.x + $padding) ($monitor.y + $waybar_height + $padding)
    } else {
      hyprctl dispatch moveactive exact ($monitor.x + $padding) ($monitor_height - $window_height - $padding)
    }
    hyprctl dispatch resizeactive exact $window_width $window_height
  }

  hyprctl dispatch tagwindow top address:($client.address)
  hyprctl dispatch focuswindow address:($active.address)
}

export def focus [value: string, --title, --class] {
  let client = filter $value --title=$title --class=$class
  if $client.focusHistoryID != 0 {
    hyprctl dispatch focuswindow address:($client.address)
  } else {
    hyprctl dispatch focuscurrentorlast
  }
}

export def adctrl [] {
  let client = filter "adctrl" --title
  if ($client | is-empty) {
    return (kitty --title "adctrl" -- nu --login -c "adctrl whichkey")
  }
  if $client.focusHistoryID != 0 {
    hyprctl dispatch focuswindow address:($client.address)
  } else {
    hyprctl dispatch focuscurrentorlast
  }
}

def "main clients" [] {
  clients
}

def "main monitors" [] {
  monitors
}

def "main filter" [value: string, --title(-t), --class(-c)] {
  filter $value --title=$title --class=$class
}

def "main move mpv" [] {
  move --class "mpv"
}

def "main move pip" [] {
  move --title "Picture in picture"
}

def "main focus mpv" [] {
  focus --class "mpv"
}

def "main focus pip" [] {
  focus --title "Picture in picture"
}

def "main switch mpv" [] {
  switch --class "mpv"
}

def "main switch pip" [] {
  switch --title "Picture in picture"
}

def "main adctrl" [] {
  adctrl
}

def "main" [] {
}
