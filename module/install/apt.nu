
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

export def update [] {
  sudo apt update -y
  sudo apt upgrade -y
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

export def basic [] {
  let packages = [
    ssh
    openssh-server
    wl-clipboard
    libxss1
    scdoc
  ]

  sudo apt install -y ...$packages
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

  sudo apt install -y ...$packages

  # sudo systemctl enable ssh
  # sudo systemctl start ssh
}

export def helix [] {
  sudo add-apt-repository -y ppa:maveonair/helix-editor
  sudo apt update
  sudo apt install -y helix
}

export def alacritty [] {
  sudo add-apt-repository -y ppa:aslatter/ppa
  sudo apt update
  sudo apt install -y alacritty
}

export def chafa [] {
  sudo apt install -y chafa
}

export def keepassxc [] {
  sudo add-apt-repository -y ppa:phoerious/keepassxc
  sudo apt update
  sudo apt install -y keepassxc
}

export def snap [] {
  sudo apt update
  sudo apt install -y snapd
}

export def speedtest [] {
  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
  sudo apt install -y speedtest
}

export def flathub [] {
  if (exists-external flatpak) {
    return
  }

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
  # sudo apt install -y openjdk-8-jdk
  # sudo apt install -y openjdk-11-jdk
  # sudo apt install -y openjdk-17-jdk
  # sudo apt install -y openjdk-21-jdk
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

export def brave [] {
  if (which brave-browser | is-not-empty) {
    return
  }

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" |
  sudo tee /etc/apt/sources.list.d/brave-browser-release.list | null

  sudo apt update
  sudo apt install -y brave-browser
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
    curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg | null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
  }

  let arch = (dpkg --print-architecture)
  let codename = (bash -c '. /etc/os-release && echo "$VERSION_CODENAME"')
  echo $'deb [arch=($arch) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ($codename) stable' |
  sudo tee /etc/apt/sources.list.d/docker.list | null

  sudo apt update

  let packages = [
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  ]

  sudo apt install -y ...$packages

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

  wget -qO - "https://regolith-desktop.org/regolith.key"
  | gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg
  | null

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

  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y ...$packages
}

export def remmina [] {
  sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
  sudo apt update
  sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
}

export def vagrant [] {
  wget -O- https://apt.releases.hashicorp.com/gpg |
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg | null
  $"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
  sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update
  sudo apt install vagrant
}

export def qemu [] {
  sudo apt update
  sudo apt install qemu-system-x86
}

export def waydroid [] {
  let modules = ($env.LOCAL_SHARE | path join modules)
  git-down https://github.com/choff/anbox-modules.git $modules
  with-wd $modules {
    bash INSTALL.sh
  }

  sudo apt install -y curl ca-certificates
  curl https://repo.waydro.id | sudo bash
  sudo apt install -y waydroid

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
  sudo apt install -y ffmpeg
  sudo add-apt-repository -y ppa:obsproject/obs-studio
  sudo apt update -y
  sudo apt install -y obs-studio
}

export def podman [] {
  sudo apt update
  sudo apt install -y podman
}

export def sftpgo [] {
  sudo add-apt-repository -y ppa:sftpgo/sftpgo
  sudo apt update
  sudo apt install -y sftpgo
  systemctl status sftpgo
}

export def timg [] {
  sudo apt install -y timg
}

export def sixel [] {
  sudo apt install -y libsixel-dev libsixel1 libsixel-bin
}
