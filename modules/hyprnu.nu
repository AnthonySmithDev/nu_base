#!/usr/bin/env nu

def get-client [value: string, --title, --class] {
  let clients = (hyprctl clients -j | from json)
  let client = if $title {
    ($clients | where title == $value | get 0?)
  } else if $class {
    ($clients | where class == $value | get 0?)
  }
  return $client
}

export def move [value: string, --title, --class] {
  let client = get-client $value --title=$title --class=$class

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
  hyprctl dispatch resizeactive exact 50% 45%

  if ("top" in $client.tags) {
    hyprctl dispatch moveactive exact 49% 53%
  } else {
    hyprctl dispatch moveactive exact 49% 4%
  }

  hyprctl dispatch tagwindow top address:($client.address)
  hyprctl dispatch focuscurrentorlast
}

def "main move mpv" [] {
  move --class "mpv"
}

def "main move pip" [] {
  move --title "Picture in picture"
}

export def focus [value: string, --title, --class] {
  let client = get-client $value --title=$title --class=$class
  if $client.focusHistoryID != 0 {
    hyprctl dispatch focuswindow address:($client.address)
  } else {
    hyprctl dispatch focuscurrentorlast
  }
}

def "main focus mpv" [] {
  focus --class "mpv"
}

def "main focus pip" [] {
  focus --title "Picture in picture"
}

export def adctrl [] {
  let client = get-client "adctrl" --title
  if ($client | is-empty) {
    return (kitty --title "adctrl" -- nu --login -c "adctrl whichkey")
  }
  if $client.focusHistoryID != 0 {
    hyprctl dispatch focuswindow address:($client.address)
  } else {
    hyprctl dispatch focuscurrentorlast
  }
}

def "main adctrl" [] {
  adctrl
}

export def main [] {
}
