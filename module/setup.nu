
export def android [] {
  download java --latest
  download android-studio
  download android-cmdline-tools

  let packages = [
    "emulator"
    "platform-tools"

    "build-tools;34.0.0"
    "platforms;android-34"
    "sources;android-34"
    "system-images;android-34;google_apis;x86_64"

    "build-tools;24.0.0"
    "platforms;android-24"
    "sources;android-24"
    "system-images;android-24;google_apis;x86_64"
  ]
  ^sdkmanager --install ...$packages
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
