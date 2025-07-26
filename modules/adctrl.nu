#!/usr/bin/env nu

const DISPLAY = {
  WIDTH: 1080
  HEIGHT: 2400
}

def cord_x [value: float] {
  $value / 100 * $DISPLAY.WIDTH | math round -p 3
}

def cord_y [value: float] {
  $value / 100 * $DISPLAY.HEIGHT | math round -p 3
}

const KEYCODE = {
  POWER: 'KEYCODE_POWER'
  SLEEP: 'KEYCODE_SLEEP'

  VOLUME_UP: 'KEYCODE_VOLUME_UP'
  VOLUME_DOWN: 'KEYCODE_VOLUME_DOWN'
  VOLUME_MUTE: 'KEYCODE_VOLUME_MUTE'

  MEDIA_NEXT: 'KEYCODE_MEDIA_NEXT'
  MEDIA_PREVIOUS: 'KEYCODE_MEDIA_PREVIOUS'
  MEDIA_PLAY_PAUSE: 'KEYCODE_MEDIA_PLAY_PAUSE'
  MEDIA_STOP: 'KEYCODE_MEDIA_STOP'

  BRIGHTNESS_UP: 'KEYCODE_BRIGHTNESS_UP'
  BRIGHTNESS_DOWN: 'KEYCODE_BRIGHTNESS_DOWN'
}

def --wrapped adb [...rest] {
  try { ^adb ...$rest }
}

export def "tiktok open" [] {
  adb shell am start -n com.zhiliaoapp.musically/com.ss.android.ugc.aweme.splash.SplashActivity
}

export def "tiktok back" [] {
  adb shell input tap (cord_x 6.2) (cord_y 6.2)
}

export def "tiktok foryou" [] {
  adb shell input tap (cord_x 75) (cord_y 6.2)
}

export def "tiktok friends" [] {
  adb shell input tap (cord_x 55) (cord_y 6.2)
}

export def "tiktok profile" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (52 - $adjust))
}

export def "tiktok like" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (60 - $adjust))
}

export def "tiktok comment" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (67 - $adjust))
}

export def "tiktok bookmark" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (74 - $adjust))
}

export def "tiktok shared" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (82 - $adjust))
}

export def "tiktok audio" [--adjust(-a): float = 0.0] {
  adb shell input tap (cord_x 92.5) (cord_y (89 - $adjust))
}

export def "tiktok register close" [] {
  adb shell input tap (cord_x 93) (cord_y 10)
}

export def "tiktok comment close" [] {
  adb shell input tap (cord_x 93) (cord_y 37)
}

export def "tiktok press" [] {
  adb shell input swipe (cord_x 50) (cord_y 46) (cord_x 50) (cord_y 46) 1000
}

export def "tiktok unlike" [] {
  tiktok press
  sleep 500ms
  adb shell input tap (cord_x 25) (cord_y 85)
}

export def "tiktok download" [] {
  tiktok press
  sleep 500ms
  adb shell input tap (cord_x 45) (cord_y 85)
}

export def "tiktok fast" [] {
  adb shell input swipe (cord_x 85) (cord_y 50) (cord_x 85) (cord_y 50) 3000
}

export def "tiktok tap" [] {
  adb shell input tap (cord_x 50) (cord_y 46)
}

export def "tiktok dtap" [] {
  tiktok tap
  sleep 100ms
  tiktok tap
}

export def "swipe left" [] {
  adb shell input swipe (cord_x 20) (cord_y 50) (cord_x 80) (cord_y 50) 100
}

export def "swipe right" [] {
  adb shell input swipe (cord_x 80) (cord_y 50) (cord_x 20) (cord_y 50) 100
}

export def "swipe down" [] {
  adb shell input swipe (cord_x 50) (cord_y 70) (cord_x 50) (cord_y 20) 100
}

export def "swipe up" [] {
  adb shell input swipe (cord_x 50) (cord_y 20) (cord_x 50) (cord_y 70) 100
}

export def "power" [] {
  adb shell input keyevent $KEYCODE.POWER
}

export def "input sleep" [] {
  adb shell input keyevent $KEYCODE.SLEEP
}

export def "volumen up" [] {
  adb shell input keyevent $KEYCODE.VOLUME_UP
}

export def "volumen down" [] {
  adb shell input keyevent $KEYCODE.VOLUME_DOWN
}

export def "volumen mute" [] {
  adb shell input keyevent $KEYCODE.VOLUME_MUTE
}

export def "brightness up" [] {
  adb shell input keyevent $KEYCODE.BRIGHTNESS_UP
}

export def "brightness down" [] {
  adb shell input keyevent $KEYCODE.BRIGHTNESS_DOWN
}

export def "system brightness" [value: int] {
  adb shell settings put system screen_brightness 50
}

export def "media next" [] {
  adb shell input keyevent $KEYCODE.MEDIA_NEXT
}

export def "media previous" [] {
  adb shell input keyevent $KEYCODE.MEDIA_PREVIOUS
}

export def "media play" [] {
  adb shell input keyevent $KEYCODE.MEDIA_PLAY_PAUSE
}

export def "screen-off" [] {
  adb shell cmd display power-off 0
  hyprctl dispatch focuscurrentorlast
  exit
}

export def "screen-on" [] {
  adb shell cmd display power-on 0
}

export def "scrcpy quit" [] {
  ps | where name =~ scrcpy | first | kill $in.pid
  exit
}

export def "scrcpy no-window" [] {
  job spawn { scrcpy --no-window }
}

export def "scrcpy tiktok" [] {
  job spawn { scrcpy --no-window --start-app=com.zhiliaoapp.musically }
}

export def "stay-on" [] {
  adb shell svc power stayon true
}

export def "stay-off" [] {
  adb shell svc power stayon false
}

export def "stay-plug" [] {
  adb shell settings put global stay_on_while_plugged_in 3
}

export def list-apps [] {
  scrcpy --list-apps | awk '/^\s*[*-]/ {sub(/^\s*[*-]\s*/, " "); print}' | from ssv -n | rename name package
}

export def hooks [] {
  {
    "on_run": { hyprctl dispatch focuscurrentorlast }
    "on_exit": { hyprctl dispatch focuscurrentorlast }
  }
}

export def keybindings [] {
  {
    "q": { tiktok back }

    "j": { swipe down }
    "k": { swipe up }
    "h": { swipe left }
    "l": { swipe right }

    "y": { media play }
    "n": { media next }
    "p": { media previous }

    "C-k": { volumen up }
    "C-j": { volumen down }
    "C-m": { volumen mute }

    "C-u": { brightness up }
    "C-d": { brightness down }

    "S-k": { system brightness 50 }
    "S-j": { system brightness 0 }

    "1": { hyprctl dispatch moveactive exact 2145 728 }
    "2": { hyprctl dispatch moveactive exact 2145 1304 }
    "3": { hyprctl dispatch moveactive exact 2145 1390 }

    "s": {
      "s": { stay-on }
      "f": { stay-off }
      "p": { stay-plug }
      "u": { screen-on }
      "d": { screen-off }
      "q": { scrcpy quit }
      "n": { scrcpy no-window }
    }

    "t": {
      "o": { tiktok open }
      "q": { tiktok back }
      "f": { tiktok foryou }
      "S-f": { tiktok friends }
      "t": { tiktok tap }
      "S-t": { tiktok dtap }
      "S-p": { tiktok press }

      "p": { tiktok profile }
      "l": { tiktok like }
      "c": { tiktok comment }
      "m": { tiktok bookmark }
      "s": { tiktok shared }
      "a": { tiktok audio }

      "A-p": { tiktok profile -a 4 }
      "A-l": { tiktok like -a 4 }
      "A-c": { tiktok comment -a 4 }
      "A-m": { tiktok bookmark -a 4 }
      "A-s": { tiktok shared -a 4 }
      "A-a": { tiktok audio -a 4 }

      "u": { tiktok unlike }
      "d": { tiktok download }

      "x": { tiktok comment close }
      "S-x": { tiktok register close }
    }
  }
}

export def whichkey-show [keybindings: record] {
  mut list = ($keybindings | transpose key value | each {|e|
    let type = ($e.value | describe --detailed | get type)
    let key = ($e.key | fill -w 4 -c " ")
    if $type == "record"  {
      return $"(ansi blue_bold)($key)(ansi reset) (ansi default_dimmed)->(ansi reset) (ansi green_bold)+($e.value | columns | length) keymaps(ansi reset)"
    }
    if $type == "string"  {
      return $"(ansi blue_bold)($key)(ansi reset) (ansi default_dimmed)->(ansi reset) (ansi light_red_bold)($e.value)(ansi reset)"
    }
    if $type == "closure"  {
      let words = (view source $e.value | split words)
      let cmd = if ($words | length) > 3 {
        $words | first 3 | append "..." | str join " "
      } else {
        $words | str join " "
      }
      return $"(ansi blue_bold)($key)(ansi reset) (ansi default_dimmed)->(ansi reset) (ansi light_red_bold)($cmd)(ansi reset)"
    }
  })
  # let fill = (term size | get rows) - ($list | length) - 3
  # if $fill > 0 {
  #   $list = ($list | append ("" | fill -w $fill -c "\n") | lines)
  # }
  clear
  print ($list | to text)
}

export def whichkey [--hooks] {
  let default = keybindings
  mut keybindings = $default
  mut inner = false

  whichkey-show $keybindings
  mut last = (date now) - 250ms

  loop {
    let input = input listen --types ["key" "resize"]
    if $input.type == "resize" {
      continue
    }
    let now = date now
    if ($now - $last) < 250ms {
      continue
    }
    $last = $now

    let key = match ($input | get -o modifiers | default []) {
      $mod if "keymodifiers(control)" in $mod => $"C-($input.code | str downcase)",
      $mod if "keymodifiers(shift)" in $mod => $"S-($input.code | str downcase)",
      $mod if "keymodifiers(alt)" in $mod => $"A-($input.code | str downcase)",
      _ => $input.code
    }

    if $key == "C-c" or $key == "C-q" {
      do (hooks | get on_exit)
      exit
    }

    if $key == "esc" {
      if not $inner {
        do (hooks | get on_exit)
        exit
      }
    }

    if ($key in $keybindings) {
      let value = ($keybindings | get $key)
      let type = ($value | describe --detailed | get type)

      if $type == "record" {
        $keybindings = $value
        $inner = true
      }

      if $type == "string" {
        $keybindings = $default
        $inner = false
        nu -c $value | ignore
        if $hooks { do (hooks | get on_run) }
      }

      if $type == "closure" {
        $keybindings = $default
        $inner = false
        do $value | ignore
        if $hooks { do (hooks | get on_run) }
      }
    } else {
      $keybindings = $default
      $inner = false
    }

    whichkey-show $keybindings
  }
}

def "main whichkey" [] {
  whichkey
}

def main [] {}
