
export def dev [] {
  npm install --global serve
  npm install --global wscat
  npm install --global prettier
  npm install --global opencommit
  npm install --global gitmoji-cli
}

export def core [] {
  dev
}

export def extra [] {
  npm install --global pake-cli
  npm install --global tldr
  npm install --global surge
  npm install --global httpyac
  npm install --global taskbook
  npm install --global carbon-now-cli
}

export def nativescript [] {
  npm install -g nativescript
}
