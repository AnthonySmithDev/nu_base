
export def core [] {
  update
  dependency
}

export def browser [] {
  vieb
  brave
  opera
  chrome
  microsoft-edge
}

export def update [] {
  sudo apt update
  sudo apt upgrade
}

export def dependency [] {
  sudo add-apt-repository universe
  sudo add-apt-repository multiverse

  # helix
  sudo apt install -y libc6-dev

  # AppImage
  sudo apt install -y libfuse2

  # essential
  sudo apt install -y build-essential pkg-config libssl-dev cmake

  # jless
  sudo apt install -y libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev

  # alacritty
  sudo apt install -y libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

  # docker
  sudo apt install -y ca-certificates curl wget git gnupg apt-transport-https

  # flutter
  sudo apt install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev

  # scrcpy
  sudo apt install -y ffmpeg adb wget gcc git pkg-config meson ninja-build libsdl2-dev libavcodec-dev
  sudo apt install -y libsdl2-2.0-0  libavdevice-dev libavformat-dev libavutil-dev libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

  # gnome toolkit
  sudo apt install -y libcanberra-gtk-module

  # gnu c library
  sudo apt install -y glibc-source

  # tools
  sudo apt install -y ssh neofetch htop xclip neovim mpv

  # silicon
  sudo apt install -y expat
  sudo apt install -y libxml2-dev
  sudo apt install -y pkg-config libasound2-dev libssl-dev cmake libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev

  # broot
  sudo apt install -y build-essential libxcb-shape0-dev and libxcb-xfixes0-dev

  # sshx
  sudo apt install -y protobuf-compiler

  # bettercap
  sudo apt install -y libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev
}

export def helix [] {
  sudo add-apt-repository ppa:maveonair/helix-editor
  sudo apt update
  sudo apt install -y helix
}

export def alacritty [] {
  sudo add-apt-repository ppa:aslatter/ppa
  sudo apt update
  sudo apt install -y alacritty
}

export def chafa [] {
  sudo apt install -y chafa
}

export def keepassxc [] {
  sudo add-apt-repository ppa:phoerious/keepassxc
  sudo apt update
  sudo apt install -y keepassxc
}

export def flathub [] {
  sudo apt install -y flatpak
  sudo apt install -y gnome-software-plugin-flatpak
  flatpak remote-add --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'
}

export def cpp [] {
  sudo apt install -y g++ gdb clangd clang-format clang-tidy cppcheck

  # sudo add-apt-repository PPA:codeblocks-devs/release
  # sudo apt update
  # sudo apt install -y codeblocks codeblocks-contrib
}

export def python [] {
  sudo apt install -y python3-full python3 python3-pip python3-venv pipx
}

export def java [] {
  sudo apt install -y default-jdk
}

export def dart [] {
  sudo rm '/usr/share/keyrings/dart.gpg'
  wget -qO- "https://dl-ssl.google.com/linux/linux_signing_key.pub" |
  sudo gpg --dearmor -o '/usr/share/keyrings/dart.gpg' | null

  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |
  sudo tee '/etc/apt/sources.list.d/dart_stable.list' | null

  sudo apt update
  sudo apt install -y dart
}

export def input-remapper [] {
  let version = '2.0.1'

  wget --quiet --show-progress $'https://github.com/sezanzeb/input-remapper/releases/download/($version)/input-remapper-($version).deb'
  sudo apt install -y $'./input-remapper-($version).deb'
  rm -rf $'./input-remapper-($version).deb*'
}

export def vieb [] {
  let version = '11.0.0'
  wget --quiet --show-progress $'https://github.com/Jelmerro/Vieb/releases/download/($version)/vieb_($version)_amd64.deb'
  sudo dpkg -i $'vieb_($version)_amd64.deb'
  rm -rf $'vieb_($version)_amd64.deb'
}

export def brave [] {
  sudo curl -fsSLo '/usr/share/keyrings/brave-browser-archive-keyring.gpg' 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg'

  echo 'deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main' |
  sudo tee '/etc/apt/sources.list.d/brave-browser-release.list' | null

  sudo apt update
  sudo apt install -y brave-browser
}

export def opera [] {
  wget --quiet --show-progress https://download3.operacdn.com/ftp/pub/opera/desktop/105.0.4970.48/linux/opera-stable_105.0.4970.48_amd64.deb
  sudo dpkg -i 'opera-stable_105.0.4970.48_amd64.deb'
  rm -rf 'opera-stable_105.0.4970.48_amd64.deb*'
}

export def chrome [] {
  wget --quiet --show-progress 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
  sudo dpkg -i 'google-chrome-stable_current_amd64.deb'
  rm -rf 'google-chrome-stable_current_amd64.deb*'
}

export def microsoft-edge [] {
  let version = '116.0.1938.76-1'
  wget --quiet --show-progress $'https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_($version)_amd64.deb'
  sudo dpkg -i $'microsoft-edge-stable_($version)_amd64.deb'
  rm -rf $'microsoft-edge-stable_($version)_amd64.deb'
}

export def balena-etcher [] {
  let version = '1.18.11'
  wget --quiet --show-progress  $'https://github.com/balena-io/etcher/releases/download/v($version)/balena-etcher_($version)_amd64.deb'
  sudo dpkg -i $'balena-etcher_($version)_amd64.deb'
  rm $'balena-etcher_($version)_amd64.deb'
}

export def docker [] {
  let gpg = '/etc/apt/keyrings/docker.gpg'
  if ($gpg | path exists) {
    sudo rm $gpg
  }

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' |
  sudo gpg --dearmor -o '/etc/apt/keyrings/docker.gpg' | null
  sudo chmod a+r '/etc/apt/keyrings/docker.gpg'

  let arch = (dpkg --print-architecture)
  let codename = (bash -c '. /etc/os-release && echo "$VERSION_CODENAME"')
  echo $'deb [arch=($arch) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ($codename) stable' |
  sudo tee /etc/apt/sources.list.d/docker.list | null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # sudo groupadd docker
  sudo usermod -aG docker $env.USER
  sudo docker run hello-world

  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
}

export def regolith [] {
  wget -qO - "https://regolith-desktop.org/regolith.key" |
  gpg --dearmor | sudo tee '/usr/share/keyrings/regolith-archive-keyring.gpg' | null

  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] https://regolith-desktop.org/release-3_0-ubuntu-lunar-amd64 lunar main' |
  sudo tee '/etc/apt/sources.list.d/regolith.list' | null

  sudo apt update
  sudo apt install -y regolith-desktop regolith-session-flashback regolith-session-sway
  sudo apt install -y regolith-look-ayu regolith-look-ayu-mirage regolith-look-ayu-dark
  sudo apt install -y i3xrocks-focused-window-name i3xrocks-rofication i3xrocks-info i3xrocks-app-launcher i3xrocks-memory
}

export def remmina [] {
  udo apt-add-repository ppa:remmina-ppa-team/remmina-next
  sudo apt update
  sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret
}

export def scrcpy [] {
  git clone 'https://github.com/Genymobile/scrcpy'
  cd scrcpy/
  bash ./install_release.sh
  cd '..'
  rm -rf scrcpy/
}

export def steam [] {
  http download https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
  sudo dpkg -i steam.deb
  rm steam.deb
}

export def custom [] {
  core
  brave
  opera
  steam
  python
  docker
  flathub
  regolith
  alacritty
  input-remapper
}
