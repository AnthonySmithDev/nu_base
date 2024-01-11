
export def brave [] {
  sudo snap install brave
}

export def android-studio [] {
  sudo snap install android-studio --classic
}

export def langs [] {
  sudo snap install flutter --classic
  sudo snap install kotlin --classic
  sudo snap install node --classic
  sudo snap install go --classic
}

export def docker [] {
  sudo snap install docker
  sudo addgroup --system docker
  sudo adduser $env.USER docker
  newgrp docker
  sudo snap disable docker
  sudo snap enable docker
}

export def vlc [] {
  sudo snap install vlc
}
