
export def androidsdk [] {
  let packages = [
    "emulator"
    "platform-tools"

    # "build-tools;24.0.0"
    # "platforms;android-24"
    # "sources;android-24"
    # "system-images;android-24;google_apis;x86_64"

    "build-tools;35.0.0"
    "platforms;android-35"
    "sources;android-35"
    "system-images;android-35;google_apis;x86_64"
    "system-images;android-35;google_apis_playstore;x86_64" # if android >= 28
  ]
  download android-cmdline-tools
  ^sdkmanager --install ...$packages
}

export def android [] {
  download java --latest
  download android-studio

  androidsdk
}

export def flutter [] {
  android
  download flutter --latest

  ^flutter --disable-analytics
  ^flutter doctor --android-licenses
}

export def kotlin [] {
  android
  download kotlin
  download kotlin-native
}

export def mouseless [] {
  download mouseless
  config mouseless custom
  startup mouseless --init
}

export def qmk [] {
  install pipx qmk
  ^qmk setup
  sudo cp ~/qmk_firmware/util/udev/50-qmk.rules /etc/udev/rules.d/
}
