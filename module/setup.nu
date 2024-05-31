
export def android [] {
  download java --latest
  download android-studio
  download android-cmdline-tools

  let packages = [
    "emulator"
    "build-tools;34.0.0"
    "platforms;android-34"
    "platform-tools"
    "sources;android-34"
    "system-images;android-34;google_apis;x86_64"
  ]
  ^sdkmanager --licenses
  ^sdkmanager --install ...$packages
}

export def flutter [] {
  android
  download flutter --latest

  ^flutter --disable-analytics
  ^flutter doctor --android-licenses
}
