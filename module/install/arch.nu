
 export def update [] {
  sudo pacman -Syu
}

export def mirror [] {
  sudo pacman-mirrors --geoip
}

export def dependency [] {

  let packages = [
    base-devel
    pkg-config
    cmake
    ninja
    meson
    openssl

    git
    yay
    openssh
  ]

  sudo pacman -S ...($packages | uniq)
}

export def core [] {
  yay -S zlib-ng

  yay -S helix
  yay -S zellij
  yay -S starship
  yay -S alacritty
  yay -S nushell
  yay -S zoxide
  yay -S bottom

  yay -S flatpak
  yay -S python-pipx

  input
  docker
}

export def lang [] {
  yay -S go
  yay -S rust
  yay -S python
  yay -S jdk-openjdk
}

export def browser [] {
  yay -S vieb-bin
  yay -S brave-bin
  yay -S google-chrome
}

export def input [] {
  yay -S input-remapper-git
  sudo systemctl start input-remapper
  sudo systemctl enable input-remapper
}

export def docker [] {
  yay -S docker
  yay -S docker-compose
  sudo systemctl start docker.service
  sudo systemctl enable docker.service
  sudo usermod -aG docker $env.USER
}
