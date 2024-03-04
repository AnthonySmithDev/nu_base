
def git_clone [repository: string, path: string] {
  if ($path | path exists) {
    git -C $path pull
  } else {
    git clone $repository $path
  }
}

export def alacritty [ --default --desktop --manual] {
  let source = ($env.USR_LOCAL_SOURCE | path join alacritty)
  git_clone https://github.com/alacritty/alacritty.git $source

  with-env { PWD: $source } {
    cargo build --release
  }

  let src = ($source | path join target release alacritty)
  let dest = ($env.USR_LOCAL_BIN | path join alacritty)

  ln -sf $src $dest
  sudo ln -sf $dest "/usr/local/bin/alacritty"

  if $default {
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (^which alacritty) 100
    # sudo update-alternatives --config x-terminal-emulator
  }

  if $desktop {
    with-env { PWD: $source } {
      sudo cp -f extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
      sudo desktop-file-install extra/linux/Alacritty.desktop
      sudo update-desktop-database
    }
  }

  if $manual {
    sudo mkdir -p /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/man/man5

    with-env { PWD: $source } {
      bash -c "scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null"
    }
  }
}

export def nushell [--plugin] {
  let source = ($env.USR_LOCAL_SOURCE | path join nushell)
  git_clone https://github.com/nushell/nushell.git $source

  with-env { PWD: $source } {
    cargo build --release --workspace
  }

  let src = ($source | path join target release nu)
  let dest = ($env.USR_LOCAL_BIN | path join nu)

  ln -sf $src $dest
  sudo ln -sf $dest "/usr/local/bin/nu"

  if $plugin {
    let nu_plugin_query = ($source | path join target release nu_plugin_query)
    nu -c $'register ($nu_plugin_query)'
  }
}

export def helix [--desktop] {
  let source = ($env.USR_LOCAL_SOURCE | path join helix)
  git_clone https://github.com/helix-editor/helix $source

  let term = ($source | path join helix-term)
  with-env { PWD: $term } {
    cargo build --release --locked
  }

  let src = ($source | path join target release hx)
  let dest = ($env.USR_LOCAL_BIN | path join hx)

  ln -sf $src $dest
  sudo ln -sf $dest "/usr/local/bin/hx"

  cp -r -u -p ($source | path join runtime) $env.HELIX_RUNTIME

  if $desktop {
    with-env { PWD: $source } {
      cp contrib/Helix.desktop ~/.local/share/applications
      cp contrib/helix.png ~/.local/share/icons
    }
  }
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

export def hargo [] {
  let dir = (mktemp -d)
  git clone https://github.com/mrichman/hargo.git $dir
  PWD=$dir make install
}

export def nchat [] {
  let wd = pwd
  let path = ($env.HOME | path join 'tmp' 'nchat')

  git_clone https://github.com/d99kris/nchat $path
  cd $path

  bash -c ./make.sh deps
  bash -c ./make.sh build
  bash -c ./make.sh install

  cd $wd
}

export def http-to-ws [] {
  let wd = $env.PWD

  let path = ($env.HOME | path join 'tmp' 'http-to-ws')
  if not ($path | path exists) {
    mkdir $path
  }

  cd $path

  git_clone https://github.com/AnthonySmithDev/http-to-ws.git $path
  go install "."

  cd $wd
}

export def tasklite [] {
  let path = ($env.USR_LOCAL_SOURCE | path join TaskLite)
  git_clone https://github.com/ad-si/TaskLite $path
  PWD=$path stack install tasklite-core
}

export def amp [] {
  let source = ($env.USR_LOCAL_SOURCE | path join amp)
  git_clone https://github.com/jmacdonald/amp $source

  with-env { PWD: $source } {
    cargo build --release
  }

  let src = ($source | path join target release amp)
  let dest = ($env.USR_LOCAL_BIN | path join amp)

  ln -sf $src $dest
}

export def lapce [] {
  let source = ($env.USR_LOCAL_SOURCE | path join lapce)
  git_clone https://github.com/lapce/lapce $source

  with-env { PWD: $source } {
    cargo build --release
  }

  let src = ($source | path join target release lapce)
  let dest = ($env.USR_LOCAL_BIN | path join lapce)

  ln -sf $src $dest
}
