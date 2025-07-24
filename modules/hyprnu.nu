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

def select-window [--title(-t): string, --class(-c): string] {
  let clients = clients
  let client = if ($title | is-not-empty) {
    ($clients | where title == $title | get 0?)
  } else if ($class | is-not-empty) {
    ($clients | where class == $class | get 0?)
  }
  return $client
}

const select_windows = [
  ["class", "mpv"],
  ["title", "Picture in picture"],
]

export def activeclient [] {
  let clients = clients
  mut select = {}
  for $window in $select_windows {
    let client = match $window.0 {
      "class" => ($clients | where class == $window.1)
      "title" => ($clients | where title == $window.1)
    }
    if ($client | is-not-empty) {
      $select = ($client | first)
    }
  }
  return $select
}

export def window-pos [select: record, monitor: int] {
  let waybar_is_run = (^ps -a | from ssv -m 1| where CMD =~ waybar | is-not-empty)
  let waybar_height = if $waybar_is_run {40} else {0}
  let padding = 20

  mut window_x = 0
  mut window_y = 0
  mut window_width = 0
  mut window_height = 0

  let monitor = (monitors | where id == $monitor | first)
  if $monitor.transform == 0 {
    $window_width = ($monitor.width * 0.5) - ($padding * 2)
    $window_height = (($monitor.height - $waybar_height) * 0.5) - ($padding * 2)
    $window_x = ($monitor.x + ($monitor.width * 0.5) + $padding)
    $window_y = if ("top" in $select.tags) {
      ($monitor.y + $monitor.height - $window_height - $padding)
    } else {
      ($monitor.y + $waybar_height + $padding)
    }
  } else {
    $window_width = ($monitor.height * 0.8)
    $window_height = (($monitor.width - $waybar_height) * 0.3) - ($padding * 3)
    $window_x = ($monitor.x + $padding)
    $window_y = if ("top" not-in $select.tags) {
      ($monitor.y + $monitor.width - $window_width + $padding)
    } else {
      ($monitor.y + $waybar_height + $padding)
    }
  }
  return {
    x: $window_x
    y: $window_y
    width: $window_width
    height: $window_height
  }
}

export def select-mon [--switch] {
  let path = ($env.HOME | path join .monitor.txt)
  let current_value = if ($path | path exists) { open $path | str trim } else { "0" }
  if $switch {
    let new_value = if $current_value == "1" { "0" } else { "1" }
    $new_value | save -f $path
    return ($new_value | into int)
  }
  return ($current_value | into int)
}

export def switch-pos [select: record] {
  let active = activewindow
  let monitor = select-mon
  let window = window-pos $select $monitor

  if ($select.grouped | is-not-empty) {
    hyprctl dispatch moveoutofgroup address:($select.address)
  }
  if not $select.floating {
    hyprctl dispatch setfloating address:($select.address)
    hyprctl dispatch pin address:($select.address)
  }

  hyprctl dispatch focuswindow address:($select.address)
  hyprctl dispatch moveactive exact $window.x $window.y
  hyprctl dispatch resizeactive exact $window.width $window.height

  hyprctl dispatch tagwindow top address:($select.address)
  hyprctl dispatch focuswindow address:($active.address)
}

export def switch-mon [select: record] {
  let active = activewindow
  let monitor = select-mon --switch
  let window = window-pos $select $monitor

  hyprctl dispatch focuswindow address:($select.address)
  hyprctl dispatch moveactive exact $window.x $window.y
  hyprctl dispatch resizeactive exact $window.width $window.height

  hyprctl dispatch tagwindow top address:($select.address)
  hyprctl dispatch focuswindow address:($active.address)
}

export def switch-pin [select: record] {
  if $select.floating {
    hyprctl dispatch pin address:($select.address)
  }
}

export def switch-focus [select: record] {
  let active = activewindow
  if $active.address != $select.address {
    hyprctl dispatch focuswindow address:($select.address)
  } else {
    hyprctl dispatch focuscurrentorlast
  }
}

def main [
  command?: string
  value?: string
  --title(-t): string
  --class(-c): string
] {
  match $command {
    "clients" => { clients }
    "monitors" => { monitors }
    "select-window" => { select-window --title=$title --class=$class }
    "switch-pos" => {
      let select = if ($value == "mpv") {
        select-window --class mpv
      } else if ($value == "pip") {
        select-window --title "Picture in picture"
      } else {
        activeclient
      }
      switch-pos $select
    }
    "switch-mon" => {
      let select = if ($value == "mpv") {
        select-window --class mpv
      } else if ($value == "pip") {
        select-window --title "Picture in picture"
      } else {
        activeclient
      }
      switch-mon $select
    }
    "switch-pin" => {
      let select = if ($value == "mpv") {
        select-window --class mpv
      } else if ($value == "pip") {
        select-window --title "Picture in picture"
      } else {
        activeclient
      }
      switch-pin $select
    }
    "switch-focus" => {
      let select = if ($value == "mpv") {
        select-window --class mpv
      } else if ($value == "pip") {
        select-window --title "Picture in picture"
      } else {
        activeclient
      }
      switch-focus $select
    }
    "adctrl" => {
      let select = select-window --title "adctrl"
      if ($select | is-empty) {
        kitty --title "adctrl" -- nu --login -c "adctrl whichkey"
        return
      }
      switch-focus $select
    }
    _ => {
      print "Commands:"
      print "  hyprnu clients"
      print "  hyprnu monitors"
      print "  hyprnu select-window [--title(-t) <title>] [--class(-c) <class>]"
      print "  hyprnu switch-pos [mpv|pip]"
      print "  hyprnu switch-mon [mpv|pip]"
      print "  hyprnu switch-pin [mpv|pip]"
      print "  hyprnu switch-focus [mpv|pip]"
      print "  hyprnu adctrl"
    }
  }
}
