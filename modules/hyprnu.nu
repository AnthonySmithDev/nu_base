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

  let monitor = (monitors | where id == $active.monitor | first)
  if $monitor.transform == 0 {
    if ("top" in $client.tags) {
      hyprctl dispatch moveactive exact 1000 560
    } else {
      hyprctl dispatch moveactive exact 1000 20
    }
    hyprctl dispatch resizeactive exact 900 500
  } else if $monitor.transform == 1  {
    if ("top" in $client.tags) {
      hyprctl dispatch moveactive exact 1940 -100
    } else {
      hyprctl dispatch moveactive exact 1940 940
    }
    hyprctl dispatch resizeactive exact 860 500
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
