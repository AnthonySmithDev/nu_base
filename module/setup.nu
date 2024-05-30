
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
    "emulator"
    "platform-tools"
    "build-tools;34.0.0"
    "platforms;android-34"
  ]
  ^sdkmanager --install ...$packages
}

export def create_avd [] {
  ^avdmanager create avd -n anthony-device -k "platforms;android-34"
}
