
export def --wrapped install [...rest] {
  yay --noconfirm -Syu ...$rest
}

export def vieb-browser [] {
  install vieb-bin
}

export def zen-browser [] {
  install zen-browser-bin
}

export def nchat [] {
  install nchat-git
}

export def timg [] {
  install timg
}

# hx /usr/share/applications/brave-browser.desktop
# Exec=brave --enable-features=UseOzonePlatform --ozone-platform=wayland %U
