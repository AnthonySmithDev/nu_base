
export def scrcpy [] {
  if (external exists apt) {
    let pkgs = [
      ffmpeg
      libsdl2-2.0-0
      adb
      wget
      gcc
      git
      pkg-config
      meson
      ninja-build
      libsdl2-dev
      libavcodec-dev
      libavdevice-dev
      libavformat-dev
      libavutil-dev
      libswresample-dev
      libusb-1.0-0
      libusb-1.0-0-dev
    ]
    sudo apt install -y ...$pkgs
  }
}

export def localsend [] {
  if (external exists apt) {
    let pkgs = [
      gir1.2-appindicator3-0.1
      gir1.2-ayatanaappindicator3-0.1
    ]
    sudo apt install -y ...$pkgs
  }
}

export def mkcert [] {
  if (external exists apt) {
    sudo apt install -y libnss3-tools
  }
}

export def qt [] {
  sudo apt install  qtwebengine5-dev qtpositioning5-dev
}
