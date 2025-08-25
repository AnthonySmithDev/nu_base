
export def mirror [] {
  sudo pacman-mirrors --geoip
}

export def update [] {
  sudo pacman --noconfirm --needed -Syu
}

export def --wrapped install [...rest] {
  sudo pacman --noconfirm --needed -Syu ...$rest
}

export def deps [] {
  # zlib-ng
  install base-devel pkg-config
}

export def python [] {
  install python python-pip python-pipx python-uvloop
}

export def lang [] {
  install go rust jdk-openjdk
}

export def core [] {
  install helix zellij starship alacritty nushell zoxide bottom
}

export def docker [] {
  install docker docker-compose docker-buildx
  sudo systemctl enable --now docker
  sudo usermod -aG docker $env.USER
}

export def ssh [] {
  install openssh
  sudo systemctl enable --now sshd
}

export def gnome [] {
  install nautilus nautilus-open-any-terminal gnome-disk-utility
}

export def qemu [] {
  install qemu-full libvirt virt-manager virt-viewer
  sudo systemctl enable --now libvirtd
  sudo usermod -aG libvirt $env.USER
}

export def brave [] {
  install brave-browser
}

export def kitty [] {
  install kitty
}

export def minidlna [] {
  install minidlna
}

export def tools [] {
  install just 7zip zip unzip unrar mediainfo unarchiver chafa qrencode man-db less imv lsof mpv
}

export def mdns-scan [] {
  install avahi mdns-scan
  sudo systemctl enable --now avahi-daemon
}

export def remmina [] {
  install remmina tigervnc
}

export def discord [] {
  install discord
}

export def flatpak [] {
  install flatpak
}

export def wifite [] {
  install wifite wireshark-cli reaver hcxtools hcxdumptool
}

export def neovide [] {
  install neovide
}

export def yazi [] {
  install yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick exiftool mediainfo
}

export def base [] {
  let pkgs = [
    zip
    7zip
    unzip
    unrar
    unarchiver

    imv
    mpv
    chafa
    mediainfo

    openssh
    sshpass
    sshfs
    rsync

    qrencode
    man-db
    less
    lsof
    just
    calc

    docker
    docker-compose
    docker-buildx,

    libvirt
    qemu-full
    virt-viewer
    virt-manager

    nautilus
    nautilus-open-any-terminal
    gnome-disk-utility
  ]
  install ...$pkgs
}

export def desktop [] {
  let pkgs = [
    ghostty
  ]
  install ...$pkgs
}
