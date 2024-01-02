
export def alacritty [] {
  let wd = pwd
  let path = ($env.HOME | path join 'tmp' 'alacritty')

  if ($path | path exists) {
    cd $path
    git pull
  } else {
    git clone https://github.com/alacritty/alacritty.git $path
    cd $path
  }

  cargo build --release

  # Desktop Entry
  sudo cp -f target/release/alacritty /usr/local/bin
  sudo cp -f extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # Manual Page
  sudo mkdir -p /usr/local/share/man/man1
  sudo mkdir -p /usr/local/share/man/man5

  bash -c "scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null"
  bash -c "scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null"
  bash -c "scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null"
  bash -c "scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null"

  # Default Terminal
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (^which alacritty) 100
  # sudo update-alternatives --config x-terminal-emulator

  cd $wd
}

export def riv [] {
  cargo install --git https://github.com/Davejkane/riv
}

export def vimiv [] {
  let dir = (mktemp -d)
  git clone https://github.com/karlch/vimiv-qt $dir
  mv ($dir | path join misc Makefile) $dir
  PWD=$dir sudo make install
}

export def helix [] {
  let path = (mktemp -d)
  git clone https://github.com/helix-editor/helix $path
  cargo install --path ($path | path join helix-term) --locked
  mv ($path | path join runtime) $env.HELIX_RUNTIME
}

export def hargo [] {
  let dir = (mktemp -d)
  git clone https://github.com/mrichman/hargo.git $dir
  PWD=$dir make install
}
