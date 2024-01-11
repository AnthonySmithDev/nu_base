
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
  sudo apt update -y
  sudo apt upgrade -y
}

def add-universe [] {
  let deb = 'deb http://archive.ubuntu.com/ubuntu lunar universe'
  if (open /etc/apt/sources.list | lines | find $deb | is-empty) {
    sudo add-apt-repository -y universe
  }
}

def add-multiverse [] {
  let deb = 'deb http://archive.ubuntu.com/ubuntu lunar multiverse'
  if (open /etc/apt/sources.list | lines | find $deb | is-empty) {
    sudo add-apt-repository -y multiverse
  }
}

export def dependency [] {
  add-universe
  add-multiverse

  let packages = [
    # helix
    libc6-dev

    # AppImage
    libfuse2

    # essential
    build-essential
    pkg-config
    libssl-dev
    cmake

    # jless
    libxcb1-dev
    libxcb-render0-dev
    libxcb-shape0-dev
    libxcb-xfixes0-dev

    # alacritty
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev
    python3
    scdoc
    gzip

    # docker
    ca-certificates
    curl
    wget
    git
    gnupg
    apt-transport-https

    # flutter
    clang
    cmake
    ninja-build
    pkg-config
    libgtk-3-dev
    liblzma-dev
    'libstdc++-12-dev'

    # scrcpy
    ffmpeg
    adb
    wget
    gcc
    git
    pkg-config
    meson
    ninja-build
    libsdl2-dev
    libavcodec-dev
    'libsdl2-2.0-0'
    libavdevice-dev
    libavformat-dev
    libavutil-dev
    libswresample-dev
    'libusb-1.0-0'
    'libusb-1.0-0-dev'

    # gnome toolkit
    libcanberra-gtk-module

    # gnu c library
    glibc-source

    # silicon
    pkg-config
    libasound2-dev
    libssl-dev
    cmake
    libfreetype6-dev
    libexpat1-dev
    libxcb-composite0-dev
    libharfbuzz-dev
    expat
    libxml2-dev

    # broot
    build-essential
    libxcb-shape0-dev
    and
    libxcb-xfixes0-dev

    # sshx
    protobuf-compiler

    # bettercap
    libpcap-dev
    'libusb-1.0-0-dev'
    libnetfilter-queue-dev

    # tools
    ssh
    sshpass
    htop
    xclip
    neovim
    neofetch
    lolcat
    mpv
  ]

  sudo apt install -y $packages
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

export def snap [] {
  sudo apt update
  sudo apt install -y snapd
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
  let version = github get_version 'sezanzeb/input-remapper'

  wget --quiet --show-progress $'https://github.com/sezanzeb/input-remapper/releases/download/($version)/input-remapper-($version).deb'
  sudo apt install -y $'./input-remapper-($version).deb'
  rm -rf $'./input-remapper-($version).deb*'
}

export def vieb [] {
  let version = github get_version 'Jelmerro/Vieb'

  wget --quiet --show-progress $'https://github.com/Jelmerro/Vieb/releases/download/($version)/vieb_($version)_amd64.deb'
  sudo dpkg -i $'vieb_($version)_amd64.deb'
  rm -rf $'vieb_($version)_amd64.deb*'
}

export def brave [] {
  sudo curl -fsSLo '/usr/share/keyrings/brave-browser-archive-keyring.gpg' 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg'

  echo 'deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main' |
  sudo tee '/etc/apt/sources.list.d/brave-browser-release.list' | null

  sudo apt update
  sudo apt install -y brave-browser
}

export def opera [] {
  let version = '106.0.4998.19'

  wget --quiet --show-progress $'https://download3.operacdn.com/ftp/pub/opera/desktop/($version)/linux/opera-stable_($version)_amd64.deb'
  sudo dpkg -i $'opera-stable_($version)_amd64.deb'
  rm -rf $'opera-stable_($version)_amd64.deb*'
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
  let version = github get_version 'balena-io/etcher'

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
  # sudo docker run hello-world

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
  sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
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
