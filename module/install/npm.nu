
export def install [pkg: string] {
  pnpm install --global $pkg
}

export def core [] {
  install serve
  install wscat
  install prettier
  install opencommit
  install gitmoji-cli
  install localtunnel
}

export def extra [] {
  install pake-cli
  install tldr
  install surge
  install httpyac
  install taskbook
  install carbon-now-cli
}

export def nativescript [] {
  install nativescript
}
