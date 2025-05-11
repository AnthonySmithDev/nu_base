
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
  apt install ...$pkgs
}

export def scrcpy [] {
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
  apt install ...$pkgs
}

export def localsend [] {
  let pkgs = [
    gir1.2-appindicator3-0.1
    gir1.2-ayatanaappindicator3-0.1
  ]
  apt install ...$pkgs
}

export def mkcert [] {
  apt install libnss3-tools
}

export def qt [] {
  apt install qtwebengine5-dev qtpositioning5-dev
}

export def rio [] {
  let pkgs = [
    cmake
    pkg-config
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev
    python3
    devtodo
  ]
  apt install ...$pkgs
}

export def steam [] {
  apt install zenity xterm
}
