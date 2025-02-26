
export def install [apk: path] {
  try {
    adb wait-for-device
    adb install -r -g $apk
  }
}

export use github.nu *
export use apkpure.nu *
