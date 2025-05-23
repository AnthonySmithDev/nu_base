
export def --wrapped install [...rest] {
  yay --noconfirm -S ...$rest
}

export def vieb [] {
  install vieb-bin
}

export def timg [] {
  install timg
}

# hx /usr/share/applications/brave-browser.desktop
# Exec=brave --enable-features=UseOzonePlatform --ozone-platform=wayland %U
