
export def core [] {
  update
  dependency
}

export def browsers [] {
  vieb
  brave
  opera
  chrome
  microsoft-edge
}

def add-universe [] {
  let deb = 'deb http://archive.ubuntu.com/ubuntu/ mantic universe'
  if (open /etc/apt/sources.list | lines | find $deb | is-empty) {
    sudo add-apt-repository -y universe
  }
}

def add-multiverse [] {
  let deb = 'deb http://archive.ubuntu.com/ubuntu/ mantic multiverse'
  if (open /etc/apt/sources.list | lines | find $deb | is-empty) {
    sudo add-apt-repository -y multiverse
  }
}

export def sources [] {
  # sudo hx /etc/apt/sources.list

  # libwebkit2gtk-4.0-dev/jammy-security
  deb http://security.ubuntu.com/ubuntu jammy-security main

  # libicu70/jammy
  deb http://archive.ubuntu.com/ubuntu jammy main
}

export def nala [] {
  sudo apt install -y nala
}

export def install [...packages: string] {
  if (exists-external nala) {
    sudo nala install -y ...$packages
  } else {
    sudo apt install -y ...$packages
  }
}

export def xinstall [...packages: string] {
  if (exists-external xnala) {
    sudo xnala install -y ...$packages
  } else {
    sudo xapt install -y ...$packages
  }
}

export def update [] {
  if (exists-external nala) {
    sudo nala update
  } else {
    sudo apt update
  }
}

export def upgrade [...packages: string] {
  if (exists-external nala) {
    sudo nala upgrade -y ...$packages
  } else {
    sudo apt upgrade -y ...$packages
  }
}

export def basic [] {
  let packages = [
    nala

    build-essential
    python3-full
    moreutils

    ssh
    sshfs
    sshpass
    openssh-server
    libssl-dev

    exfatprogs
    exfat-fuse

    scdoc
    qrencode

    # xsel
    # xclip
    wl-clipboard

    p7zip-full
    7zip-standalone

    chafa
    imagemagick
    poppler-utils
    exiftool

    timg
    mpv
    pqiv

    adb
    axel
    aria2

    tree
    htop

    libxss1
    libqt5concurrent5

    qemu-kvm
    qemu-utils
    qemu-system

    libvirt-daemon-system
    libvirt-clients
    bridge-utils
    virt-manager
  ]

  install ...$packages
}

export def dependency [] {
  # add-universe
  # add-multiverse

  let packages = ([
    # essential
    wl-clipboard
    build-essential
    pkg-config
    libssl-dev
    cmake


    # vieb
    libxss1

    # helix
    libc6-dev

    # AppImage
    libfuse2t64

    # jless
    libxcb1-dev
    libxcb-render0-dev
    libxcb-shape0-dev
    libxcb-xfixes0-dev

    # alacritty
    libfreetype-dev
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
    libstdc++-12-dev

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

    # nano-work-server
    ocl-icd-opencl-dev

    # bettercap
    libpcap-dev
    libusb-1.0-0-dev
    libnetfilter-queue-dev

    # lapce
    clang
    libxkbcommon-x11-dev
    pkg-config
    libvulkan-dev
    libwayland-dev
    xorg-dev
    libxcb-shape0-dev
    libxcb-xfixes0-dev

    # riv
    libsdl2-dev
    libsdl2-image-dev
    libsdl2-ttf-dev

    # vimiv
    libgirepository1.0-dev
    gcc
    libcairo2-dev
    pkg-config
    python3-dev
    gir1.2-gtk-4.0

    # AppFlowy
    libkeybinder-3.0-0

    # Pake
    libsoup2.4-dev

    # lan-mouse
    libadwaita-1-dev
    libgtk-4-dev
    libx11-dev
    libxtst-dev

    # ktrl
    libalsa-ocaml-dev
    autoconf
    libtool
    libtool-bin

    # wails
    nsis
    libwebkitgtk-6.0-dev
    libwebkit2gtk-4.1-dev

    # tools
    ssh
    sshpass
    qiv
    pqiv
    p7zip-full

    htop
    xclip
    neofetch
    lolcat
    mpv
    wmctrl

    gnome-screenshot
  ] | uniq)

  install ...$packages

  # sudo systemctl enable ssh
  # sudo systemctl start ssh
}

export def helix [] {
  sudo add-apt-repository -y ppa:maveonair/helix-editor
  update
  install helix
}

export def alacritty [] {
  sudo add-apt-repository -y ppa:aslatter/ppa
  update
  install alacritty
}

export def chafa [] {
  install chafa
}

export def keepassxc [] {
  sudo add-apt-repository -y ppa:phoerious/keepassxc
  update
  install keepassxc
}

export def snap [] {
  update
  install snapd
}

export def speedtest [] {
  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
  install speedtest
}

export def flathub [] {
  if (exists-external flatpak) {
    return
  }

  install flatpak
  install gnome-software-plugin-flatpak
  flatpak remote-add --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'
}

export def cpp [] {
  install g++ gdb clangd clang-format clang-tidy cppcheck

  # sudo add-apt-repository PPA:codeblocks-devs/release
  # update
  # install codeblocks codeblocks-contrib
}

export def python [] {
  install python3-full python3 python3-pip python3-venv pipx
}

export def java [] {
  # install openjdk-8-jdk
  # install openjdk-11-jdk
  # install openjdk-17-jdk
  # install openjdk-21-jdk
  install default-jdk
}

export def dart [] {
  sudo rm '/usr/share/keyrings/dart.gpg'

  wget -qO- "https://dl-ssl.google.com/linux/linux_signing_key.pub"
  | sudo gpg --yes --dearmor -o '/usr/share/keyrings/dart.gpg' | ignore

  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'
  | sudo tee '/etc/apt/sources.list.d/dart_stable.list' | ignore

  update
  install dart
}

export def libwebkit2gtk [] {
  "deb http://archive.ubuntu.com/ubuntu jammy main"
  update
  install ibwebkit2gtk-4.0-dev
}

def exists [ app: string ] {
  which --all $app | where type == external | is-not-empty
}

export def brave [ --force(-f) ] {

  if not $force and (exists brave-browser) {
    return
  }

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"
  | sudo tee /etc/apt/sources.list.d/brave-browser-release.list | ignore

  update
  install brave-browser
}

export def docker [] {
  if (exists-external docker) {
    return
  }

  let gpg = '/etc/apt/keyrings/docker.gpg'
  if ($gpg | path exists) {
    sudo rm $gpg
  }

  try {
    sudo install -m 0755 -d /etc/apt/keyrings

    curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg'
    | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg | ignore

    sudo chmod a+r /etc/apt/keyrings/docker.gpg
  }

  let arch = (dpkg --print-architecture)
  let codename = (bash -c '. /etc/os-release && echo "$VERSION_CODENAME"')

  echo $'deb [arch=($arch) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ($codename) stable'
  | sudo tee /etc/apt/sources.list.d/docker.list | ignore

  update

  let packages = [
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  ]

  install ...$packages

  # sudo groupadd docker
  sudo usermod -aG docker $env.USER
  # sudo docker run hello-world

  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
}

export def regolith [ --force(-f), --beta(-b) ] {
  if not $force {
    if (exists-external regolith-session) {
      return
    }
  }

  wget -qO - "https://regolith-desktop.org/regolith.key" | gpg --dearmor
  | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg | ignore

  if $beta {
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] https://regolith-desktop.org/testing-ubuntu-noble-amd64 noble main"
    | sudo tee /etc/apt/sources.list.d/regolith.list
  } else {
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] https://regolith-desktop.org/release-3_1-ubuntu-mantic-amd64 mantic main"
    | sudo tee /etc/apt/sources.list.d/regolith.list
  }


  let packages = [
    # base
    regolith-desktop

    # session
    regolith-session-sway
    regolith-session-flashback

    # look
    regolith-look-ayu-dark
    regolith-look-ayu-mirage
    regolith-look-ayu
    regolith-look-blackhole
    regolith-look-default-loader
    regolith-look-default
    regolith-look-dracula
    regolith-look-gruvbox
    regolith-look-i3-default
    regolith-look-lascaille
    regolith-look-nevil
    regolith-look-nord
    regolith-look-solarized-dark

    # status
    i3xrocks-focused-window-name
    i3xrocks-rofication
    i3xrocks-info
    i3xrocks-app-launcher
    i3xrocks-memory
    i3xrocks-battery
  ]

  update
  install ...$packages
  upgrade
}

export def remmina [] {
  sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
  update
  install remmina remmina-plugin-rdp remmina-plugin-secret
}

export def vagrant [] {
  wget -O- https://apt.releases.hashicorp.com/gpg
  | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg | ignore

  echo $"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  | sudo tee /etc/apt/sources.list.d/hashicorp.list

  update
  install vagrant
}

export def qemu [] {
  update
  install qemu-system-x86
}

export def waydroid [] {
  let modules = ($env.LOCAL_SHARE | path join modules)
  git-down https://github.com/choff/anbox-modules.git $modules
  with-wd $modules {
    bash INSTALL.sh
  }

  install curl ca-certificates
  curl https://repo.waydro.id | sudo bash
  install waydroid

  sudo waydroid init -s GAPPS
  sudo systemctl enable --now waydroid-container
  # ^waydroid session start

  ^waydroid prop set persist.waydroid.width 576
  ^waydroid prop set persist.waydroid.height 1024

  sudo waydroid container restart
  # sudo systemctl restart waydroid-container

  # sudo systemctl enable --now waydroid-container
  # sudo waydroid init -f -s GAPPS
  # sudo waydroid init --force
  # sudo waydroid container start
  # sudo waydroid container stop
  # ^waydroid session start
}

export def obs [] {
  install ffmpeg
  sudo add-apt-repository -y ppa:obsproject/obs-studio
  update
  install obs-studio
}

export def podman [] {
  update
  install podman
}

export def sftpgo [] {
  sudo add-apt-repository -y ppa:sftpgo/sftpgo
  update
  install sftpgo
  systemctl status sftpgo
}

export def timg [] {
  install timg
}

export def nautilus [] {
  install nautilus
}

export def gparted [] {
  install gparted
}

export def sixel [] {
  install libsixel-dev libsixel1 libsixel-bin
}

export def unityhub [] {
  wget -qO - https://hub.unity3d.com/linux/keys/public | gpg --dearmor
  | sudo tee /usr/share/keyrings/Unity_Technologies_ApS.gpg | ignore

  echo "deb [signed-by=/usr/share/keyrings/Unity_Technologies_ApS.gpg] https://hub.unity3d.com/linux/repos/deb stable main" 
  | sudo tee '/etc/apt/sources.list.d/unityhub.list' | ignore

  update
  install unityhub
}

export def windsurf [] {
  curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg"
  | sudo gpg --yes --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main"
  | sudo tee /etc/apt/sources.list.d/windsurf.list | ignore

  update
  upgrade windsurf
}

export def mixxx [] {
  sudo add-apt-repository -y ppa:mixxx/mixxx
  update
  install mixxx
}

export def cloudflare-warp [] {
  curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg
  | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

  echo $"deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ (lsb_release -cs) main"
  | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

  update
  install cloudflare-warp
}

export def wezterm [] {
  curl -fsSL https://apt.fury.io/wez/gpg.key
  | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg

  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *'
  | sudo tee /etc/apt/sources.list.d/wezterm.list

  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  update
  install wezterm
}
