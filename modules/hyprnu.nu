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

const select_clients = [
  ["class", "mpv"],
  ["title", "Picture in picture"],
]

export def activeclient [] {
  let clients = clients
  mut select = {}
  for $client in $select_clients {
    let client = match $client.0 {
      "class" => ($clients | where class == $client.1)
      "title" => ($clients | where title == $client.1)
    }
    if ($client | is-not-empty) {
      $select = ($client | first)
    }
  }
  return $select
}

export def move [select: record] {
  let active = activewindow

  if ($select.grouped | is-not-empty) {
    hyprctl dispatch moveoutofgroup address:($select.address)
  }
  if not $select.floating {
    hyprctl dispatch setfloating address:($select.address)
  }
  if not $select.pinned {
    hyprctl dispatch pin address:($select.address)
  }

  hyprctl dispatch focuswindow address:($select.address)
  # hyprctl dispatch tagwindow $"monitor_($active.monitor)" address:($select.address)

  let waybar_is_run = (^ps -a | from ssv -m 1| where CMD =~ waybar | is-not-empty)
  let waybar_height = if $waybar_is_run {40} else {0}
  let padding = 20

  let monitor = (monitors | where id == $active.monitor | first)
  if $monitor.transform == 0 { # horizontal
    let monitor_width = $monitor.width
    let monitor_height = $monitor.height

    let window_width = 920
    let window_height = ((($monitor_height - $waybar_height) * 0.5) - ($padding * 2))

    mut window_x = 0
    mut window_y = 0

    if ("top" in $select.tags) {
      $window_x = ($monitor.x + 980)
      $window_y = ($monitor_height - $window_height - $padding)
    } else {
      $window_x = ($monitor.x + 980)
      $window_y = ($monitor.x + $waybar_height + $padding)
    }
    hyprctl dispatch moveactive exact $window_x $window_y
    hyprctl dispatch resizeactive exact $window_width $window_height
  } else if $monitor.transform == 1  { # vertical
    let monitor_width = $monitor.height
    let monitor_height = $monitor.width

    let window_width = 860
    let window_height = ((($monitor_width - $waybar_height) * 0.5) - ($padding * 2))

    mut window_x = 0
    mut window_y = 0

    if ("top" in $select.tags) {
      $window_x = ($monitor.x + $padding)
      $window_y = ($monitor.y + $waybar_height + $padding)
    } else {
      $window_x = ($monitor.x + $padding)
      $window_y = (920 + $waybar_height)
    }
    hyprctl dispatch moveactive exact $window_x $window_y
    hyprctl dispatch resizeactive exact $window_width $window_height
  }

  hyprctl dispatch tagwindow top address:($select.address)
  hyprctl dispatch focuswindow address:($active.address)
}

export def focus [select: record] {
  if $select.focusHistoryID != 0 {
    hyprctl dispatch focuswindow address:($select.address)
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
  let select = filter --class mpv
  move $select
}

def "main move pip" [] {
  let select = filter --title "Picture in picture"
  move $select
}

def "main move toggle" [] {
  let select = activeclient
  move $select
}

def "main focus mpv" [] {
  let select = filter --class mpv
  focus $select
}

def "main focus pip" [] {
  let select = filter --title "Picture in picture"
  focus $select
}

def "main focus toggle" [] {
  let select = activeclient
  focus $select
}

def "main adctrl" [] {
  let select = filter "adctrl" --title
  if ($select | is-empty) {
    kitty --title "adctrl" -- nu --login -c "adctrl whichkey"
    return
  }
  focus $select
}

def "main" [] {
}
