#!/usr/bin/env nu

const BUTTON = {
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

const TOP = {
  LEFT: "100 500"
  CENTER: "500 500"
  RIGHT: "1000 500"
}

const CENTER = {
  LEFT: "200 1000"
  CENTER: "500 1000"
  RIGHT: "800 1000"
}

const BOTTOM = {
  LEFT: "100 1500"
  CENTER: "500 1500"
  RIGHT: "1000 1500"
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

export def "back" [] {
  adb shell input tap $BUTTON.BACK
}

export def "profile" [] {
  adb shell input tap $BUTTON.PROFILE
}

export def "like" [] {
  adb shell input tap $BUTTON.LIKE
}

export def "comment" [] {
  adb shell input tap $BUTTON.COMMENT
}

export def "bookmark" [] {
  adb shell input tap $BUTTON.BOOKMARK
}

export def "shared" [] {
  adb shell input tap $BUTTON.SHARED
}

export def "audio" [] {
  adb shell input tap $BUTTON.AUDIO
}

export def "swipe left" [] {
  adb shell input swipe $CENTER.LEFT $CENTER.RIGHT 100
}

export def "swipe down" [] {
  adb shell input swipe $BOTTOM.CENTER $TOP.CENTER 100
}

export def "swipe up" [] {
  adb shell input swipe $TOP.CENTER $BOTTOM.CENTER 100
}

export def "swipe right" [] {
  adb shell input swipe $CENTER.RIGHT $CENTER.LEFT 100
}

export def "fast" [] {
  adb shell input swipe $CENTER.RIGHT $CENTER.RIGHT 10000
}

export def "tap" [] {
  adb shell input tap $CENTER.CENTER
}

export def "dtap" [] {
  adb shell input tap $CENTER.CENTER
  sleep 100ms
  adb shell input tap $CENTER.CENTER
}

export def "unlike" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.UNLIKE
}

export def "download" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.DOWNLOAD
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

export def "terminal" [] {
  wezterm
  # ghostty
  # alacritty
  # flatpak run com.raggesilver.BlackBox
}

export def "files" [] {
  nautilus
}

export def "scrcpy audio" [] {
  scrcpy --no-window
}

const global_args = [
  --max-size=1600
  --window-title='Tiktok'
  --window-borderless
  --turn-screen-off
  --keyboard=uhid
]

export def "scrcpy tiktok" [] {
  let local_args = [
    # --new-display
    --start-app=?tiktok
    # --no-vd-destroy-content
  ]
  scrcpy ...$local_args ...$global_args
}

export def "scrcpy borderless" [] {
  scrcpy ...$global_args
}

def "main" [...args] {
  let cmd = ($args | str join " ")
  match $cmd {
    "back" => { back }
    "profile" => { profile }
    "like" => { like }
    "comment" => { comment }
    "bookmark" => { bookmark }
    "shared" => { shared }
    "audio" => { audio }
    "swipe left" => { swipe left }
    "swipe down" => { swipe down }
    "swipe up" => { swipe up }
    "swipe right" => { swipe right }
    "fast" => { fast }
    "tap" => { tap }
    "dtap" => { dtap }
    "unlike" => { unlike }
    "download" => { download }
    "power" => { power }
    "input sleep" => { input sleep }
    "volumen up" => { volumen up }
    "volumen down" => { volumen down }
    "volumen mute" => { volumen mute }
    "media next" => { media next }
    "media previous" => { media previous }
    "media play" => { media play }
    "terminal" => { terminal }
    "files" => { files }
    "scrcpy audio" => { scrcpy audio }
    "scrcpy tiktok" => { scrcpy tiktok }
    "scrcpy borderless" => { scrcpy borderless }
  }
}
