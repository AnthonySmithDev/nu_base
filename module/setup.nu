
export def androidsdk [] {
  let packages = [
    "platform-tools"
    "platforms;android-35"
    "build-tools;35.0.0"
    "sources;android-35"
    "emulator"
  ]
  ^sdkmanager --install ...($packages | reverse)
}

export def android [] {
  download java
  download android-studio
  download android-cmdline-tools

  androidsdk
}

export def flutter [] {
  android
  download flutter --latest

  ^flutter --disable-analytics
  ^flutter doctor --android-licenses
}

export def quasar [] {
  android
  pkg js install quasar
}

export def kotlin [] {
  android
  download kotlin
  download kotlin-native
}

export def qmk [] {
  pkg py install qmk
  ^qmk setup
  sudo cp ~/qmk_firmware/util/udev/50-qmk.rules /etc/udev/rules.d/
}

export def podman [] {
  pkg apt podman
  pkg flathub podman
}

export def evremap [file: string@'config files-evremap'] {
  pkg compile evremap --uinput
  config evremap $file
  srv init evremap
}

export def mouseless [file: string@'config files-mouseless'] {
  download mouseless
  config mouseless $file
  srv init mouseless
}
