
export def alacritty [] {
  let pkgs = [
    cmake
    pkg-config
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev
    python3
  ]
  if (exists-external apt) {
    sudo apt install -y ...$pkgs
  }
}

export def scrcpy [] {
  if (exists-external apt) {
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
  if (exists-external apt) {
    let pkgs = [
      gir1.2-appindicator3-0.1
      gir1.2-ayatanaappindicator3-0.1
    ]
    sudo apt install -y ...$pkgs
  }
}

export def mkcert [] {
  if (exists-external apt) {
    sudo apt install -y libnss3-tools
  }
}

export def qt [] {
  if (exists-external apt) {
    sudo apt install -y qtwebengine5-dev qtpositioning5-dev
  }
}

export def rio [] {
  if (exists-external apt) {
    # sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    sudo apt install -y devtodo
  }
}

export def steam [] {
  if (exists-external apt) {
    sudo apt install zenity
  }
}
