
export def --wrapped install [...rest] {
  yay --noconfirm --needed -Syu ...$rest
}

export def core [] {
  install zen-browser-bin brave-bin vieb-bin
}

export def vieb-browser [] {
  install vieb-bin
}

export def zen-browser [] {
  install zen-browser-bin
}

export def brave-browser [] {
  install brave-bin
}

export def chrome-browser [] {
  install google-chrome
}

export def nchat [] {
  install nchat-git
}

export def timg [] {
  install timg
}

export def qview [] {
  install qview
}

export def yazi [] {
  install yazi-git ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
}

# chaotic-aur/code-marketplace
