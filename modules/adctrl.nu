#!/usr/bin/env nu

const BUTTON = {
  TIKTOK: {
    BACK: "70 150"
  
    PROFILE: "1000 1100"
    LIKE: "1000 1300"
    COMMENT: "1000 1450"
    BOOKMARK: "1000 1650"
    SHARED: "1000 1800"
    AUDIO: "1000 2000"
  
    UNLIKE: "280 1850"
    DOWNLOAD: "450 1850"
  }
  
  INSTAGRAM: {
    BACK: "70 150"
  
    PROFILE: "1000 1100"
    LIKE: "1000 1300"
    COMMENT: "1000 1450"
    BOOKMARK: "1000 1650"
    SHARED: "1000 1800"
    AUDIO: "1000 2000"
  
    UNLIKE: "280 1850"
    DOWNLOAD: "450 1850"
  }
}

const DISPLAY = {
  WIDTH: 1080
  HEIGHT: 2400
}

const SCREEN = {
  INSTAGRAM: {
    TOP: {
      LEFT: $"($DISPLAY.WIDTH * 0.1) ($DISPLAY.HEIGHT * 0.1)"
      CENTER: $"($DISPLAY.WIDTH * 0.5) ($DISPLAY.HEIGHT * 0.1)"
      RIGHT: $"($DISPLAY.WIDTH * 0.9) ($DISPLAY.HEIGHT * 0.1)"
    }
    CENTER: {
      LEFT: $"($DISPLAY.WIDTH * 0.1) ($DISPLAY.HEIGHT * 0.5)"
      CENTER: $"($DISPLAY.WIDTH * 0.5) ($DISPLAY.HEIGHT * 0.5)"
      RIGHT: $"($DISPLAY.WIDTH * 0.9) ($DISPLAY.HEIGHT * 0.5)"
    }
    BOTTOM: {
      LEFT: $"($DISPLAY.WIDTH * 0.1) ($DISPLAY.HEIGHT * 0.9)"
      CENTER: $"($DISPLAY.WIDTH * 0.5) ($DISPLAY.HEIGHT * 0.9)"
      RIGHT: $"($DISPLAY.WIDTH * 0.9) ($DISPLAY.HEIGHT * 0.9)"
    }
  }
}

const CENTER = {
  LEFT: "200 1000"
  CENTER: "500 1000"
  RIGHT: "800 1000"
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
}

def --wrapped adb [...rest] {
  try { ^adb ...$rest }
}

export def "tiktok back" [] {
  adb shell input tap $BUTTON.TIKTOK.BACK
}

export def "tiktok profile" [] {
  adb shell input tap $BUTTON.TIKTOK.PROFILE
}

export def "tiktok like" [] {
  adb shell input tap $BUTTON.TIKTOK.LIKE
}

export def "tiktok comment" [] {
  adb shell input tap $BUTTON.TIKTOK.COMMENT
}

export def "tiktok bookmark" [] {
  adb shell input tap $BUTTON.TIKTOK.BOOKMARK
}

export def "tiktok shared" [] {
  adb shell input tap $BUTTON.TIKTOK.SHARED
}

export def "tiktok audio" [] {
  adb shell input tap $BUTTON.TIKTOK.AUDIO
}

export def "tiktok unlike" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.TIKTOK.UNLIKE
}

export def "tiktok download" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.TIKTOK.DOWNLOAD
}

export def "tiktok fast" [] {
  adb shell input swipe $CENTER.RIGHT $CENTER.RIGHT 3000
}

export def "tiktok tap" [] {
  adb shell input tap $CENTER.CENTER
}

export def "tiktok dtap" [] {
  adb shell input tap $CENTER.CENTER
  sleep 100ms
  adb shell input tap $CENTER.CENTER
}

export def "instagram back" [] {
  adb shell input tap $BUTTON.INSTAGRAM.BACK
}

export def "instagram toggle" [] {
  adb shell input tap 540 1220
}

export def "instagram fast" [] {
  adb shell input swipe 1000 1000 1000 1000 3000
}

export def "swipe left" [screen: record] {
  adb shell input swipe $screen.CENTER.LEFT $screen.CENTER.RIGHT 100
}

export def "swipe down" [screen: record] {
  adb shell input swipe $screen.BOTTOM.CENTER $screen.TOP.CENTER 100
}

export def "swipe up" [screen: record] {
  adb shell input swipe $screen.TOP.CENTER $screen.BOTTOM.CENTER 100
}

export def "swipe right" [screen: record] {
  adb shell input swipe $screen.CENTER.RIGHT $screen.CENTER.LEFT 100
}

export def "instagram swipe left" [] {
  swipe left $SCREEN.INSTAGRAM
}

export def "instagram swipe down" [] {
  swipe down $SCREEN.INSTAGRAM
}

export def "instagram swipe up" [] {
  swipe up $SCREEN.INSTAGRAM
}

export def "instagram swipe right" [] {
  swipe right $SCREEN.INSTAGRAM
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
  job spawn {scrcpy --no-window | null}
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

export def hooks [] {
  {
    "on_run": { hyprctl dispatch focuscurrentorlast }
    "on_exit": { hyprctl dispatch focuscurrentorlast }
  }
}

export def keybindings [] {
  {
    "q": { tiktok back }

    "j": { instagram swipe down }
    "k": { instagram swipe up }
    "h": { instagram swipe left }
    "l": { instagram swipe right }

    "y": { media play }
    "n": { media next }
    "p": { media previous }

    "C-k": { volumen up }
    "C-j": { volumen down }
    "C-m": { volumen mute }

    "1": { hyprctl dispatch moveactive exact 2145 900 }
    "2": { hyprctl dispatch moveactive exact 2145 1290 }
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

    "i": {
      "t": { instagram toggle }
      "b": { instagram back }
      "f": { instagram fast }
    }

    "t": {
      "q": { tiktok back }
      "t": { tiktok tap }
      "h": { tiktok dtap }
      "p": { tiktok profile }
      "c": { tiktok comment }
      "m": { tiktok bookmark }
      "s": { tiktok shared }
      "a": { tiktok audio }
      "d": { tiktok download }
    }
  }
}

export def whichkey [--hooks] {
  let default = keybindings
  mut keybindings = $default
  mut inner = false

  loop {
    clear

    let list = ($keybindings | transpose key value | each {|e|
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

    let fill = (term size | get rows) - ($list | length) - 3

    print ($list | to text)
    print ("" | fill -w $fill -c "\n" )

    let input = input listen --types ["key" "resize"]
    if $input.type == "resize" {
      continue
    }

    let key = match ($input | get -o modifiers | default []) {
      $mod if "keymodifiers(control)" in $mod => $"C-($input.code)",
      $mod if "keymodifiers(shift)" in $mod => $"S-($input.code)",
      _ => $input.code
    }

    if $key == "C-c" or $key == "C-q" {
      do (hooks | get on_exit)
      exit
    }

    if $key == "esc" {
      if $inner {
        $inner = false
        $keybindings = $default
      } else {
        do (hooks | get on_exit)
        exit
      }
    }

    if ($key not-in $keybindings) {
      continue
    }

    let value = ($keybindings | get $key)
    let type = ($value | describe --detailed | get type)

    if $type == "record" {
      $keybindings = $value
      $inner = true
      continue
    }

    if $type == "string" {
      $keybindings = $default
      $inner = false
      nu -c $value
      if $hooks { do (hooks | get on_run) }
    }

    if $type == "closure" {
      $keybindings = $default
      $inner = false
      do $value
      if $hooks { do (hooks | get on_run) }
    }

    sleep 100ms
  }
}

def "main whichkey" [] {
  whichkey
}

def main [] {}
