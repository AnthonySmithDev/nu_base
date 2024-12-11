
export def brave [] {
  sudo snap install brave
}

export def android-studio [] {
  sudo snap install android-studio --classic
}

export def flutter [] {
  sudo snap install flutter --classic
}

export def kotlin [] {
  sudo snap install kotlin --classic
}

export def node [] {
  sudo snap install node --classic
}

export def go [] {
  sudo snap install go --classic
}

export def rust [] {
  sudo snap install rustup --classic
}

export def dotnet [] {
  sudo snap install dotnet-sdk --classic
}

export def openjdk [] {
  sudo snap install openjdk
}

export def keepassxc [] {
  sudo snap install keepassxc
}

export def alacritty [] {
  sudo snap install alacritty --classic
}

export def helix [] {
  sudo snap install helix --classic
}

export def vscode [] {
  sudo snap install code --classic
}

export def kubectl [] {
  sudo snap install kubectl --classic
}

export def vlc [] {
  sudo snap install vlc
}

export def flameshot [] {
  sudo snap install flameshot
}

export def netbeans [] {
  sudo snap install netbeans --classic
}

export def eclipse [] {
  sudo snap install eclipse --classic
}

export def intellij-idea [] {
  sudo snap install intellij-idea-community --classic
}

export def docker [] {
  sudo snap install docker
  sudo addgroup --system docker
  sudo adduser $env.USER docker
  newgrp docker
  sudo snap disable docker
  sudo snap enable docker
}

export def langs [] {
  kotlin
  node
  go
}
