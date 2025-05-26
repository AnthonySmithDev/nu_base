
export def update [] {
  sudo pacman --noconfirm -Syu
}

export def --wrapped install [...rest] {
  sudo pacman --noconfirm -Syu ...$rest
}

export def deps [] {
  install base-devel pkg-config
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
  install nautilus gnome-disk-utility
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

export def tools [] {
  install unzip chafa
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
