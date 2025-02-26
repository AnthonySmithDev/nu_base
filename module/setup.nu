
export def android [] {
  pkg bin java
  pkg bin android-cmdline-tools
  pkg bin android-platform-tools
}

export def android-sdk [] {
  let packages = [
    "platform-tools"
    "platforms;android-35"
    "build-tools;35.0.0"
    "sources;android-35"
    "emulator"
  ]
  ^sdkmanager --install ...($packages | reverse) err> /dev/null
}

export def android-system-image [] {
  let system_images = [
    "system-images;android-35;google_apis_playstore;x86_64"
  ]
  ^sdkmanager --install ...($system_images) err> /dev/null
}

export def avd [] {
  android
  android-sdk
  android-system-image
}

export def android-studio [] {
  pkg bin android-studio

  android
  android-sdk
  android-system-image
}

export def flutter [] {
  android-studio
  pkg bin flutter --latest

  ^flutter --disable-analytics
  ^flutter doctor --android-licenses
}

export def quasar [] {
  android-studio
  pkg js install quasar
}

export def kotlin [] {
  android-studio
  pkg bin kotlin
  pkg bin kotlin-native
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
  pkg bin mouseless
  config mouseless $file
  srv init mouseless
}
