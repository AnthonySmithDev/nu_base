
export def flutter [--arch] {
  if $arch {
    sudo pacman -S clang cmake ninja pkg-config
  }

  download flutter

  download java
  download android-cmdline-tools
  download android-platform-tools
}

export def disable-analytics [] {
  ^flutter --disable-analytics
  ^flutter doctor --android-licenses
}

export def android-sdk [] {
  let packages = [
    "platform-tools"
    "platforms;android-31"
    "build-tools;31.0.0"
    "emulator"
    "platforms;android-31"
    "build-tools;31.0.0"
  ]
  ^sdkmanager --install ...$packages
}

export def create_avd [] {
  ^avdmanager create avd -n anthony-device -k "platforms;android-31"
}
