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
  VOLUME_NEXT: 'KEYCODE_VOLUME_NEXT'
  VOLUME_PREVIOUS: 'KEYCODE_VOLUME_PREVIOUS'
  VOLUME_PLAY_PAUSE: 'KEYCODE_VOLUME_PLAY_PAUSE'
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

export def whichkey [] {
  let default = {
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

    "i": {
      "t": { instagram toggle }
      "b": { instagram back }
      "f": { instagram fast }
    }

    "t": {
      "q": { tiktok back }
      "p": { tiktok profile }
      "c": { tiktok comment }
      "m": { tiktok bookmark }
      "s": { tiktok shared }
      "a": { tiktok audio }
      "d": { tiktok download }
    }
 }
  mut keybindings = $default

  loop {
    let input = input listen --types ["key"]
    let modifiers = ($input | get -i modifiers | default [])

    let key = if "keymodifiers(control)" in $modifiers {
      $"C-($input.code)"
    } else {
      $input.code
    }

    if $key == "C-q" {
      exit
    }

    if $key == "C-c" {
      break
    }

    if ($key not-in $keybindings) {
      continue
    }

    let value = ($keybindings | get $key)
    let type = ($value | describe --detailed | get type)

    if $type == "record" {
      $keybindings = $value
      continue
    }

    if $type == "closure" {
      $keybindings = $default
      do $value
    }
  }
}
