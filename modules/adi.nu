
export def power [] {
  adb shell input keyevent KEYCODE_POWER
}

export def back [] {
  adb shell input keyevent KEYCODE_BACK
}

export def home [] {
  adb shell input keyevent KEYCODE_HOME
}

export def menu [] {
  adb shell input keyevent KEYCODE_MENU
}

export def app [] {
  adb shell input keyevent KEYCODE_APP_SWITCH
}

export def "volumen up" [] {
  adb shell input keyevent KEYCODE_VOLUME_UP
}

export def "volumen down" [] {
  adb shell input keyevent KEYCODE_VOLUME_DOWN
}

export def "volumen mute" [] {
  adb shell input keyevent KEYCODE_VOLUME_MUTE
}

export def "media play" [] {
  adb shell input keyevent KEYCODE_MEDIA_PLAY_PAUSE
}

export def "media next" [] {
  adb shell input keyevent KEYCODE_MEDIA_NEXT
}

export def "media previous" [] {
  adb shell input keyevent KEYCODE_MEDIA_PREVIOUS
}

const TOP = {
  LEFT: "100 500"
  CENTER: "500 500"
  RIGHT: "1000 500"
}

const CENTER = {
  LEFT: "100 1000"
  CENTER: "500 1000"
  RIGHT: "1000 1000"
}

const BOTTOM = {
  LEFT: "100 1500"
  CENTER: "500 1500"
  RIGHT: "1000 1500"
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

export def "swipe center" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 500
}
