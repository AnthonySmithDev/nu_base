
export def alacritty [ --global, --default, --desktop, --manual ] {
  let source = ($env.USR_LOCAL_SOURCE | path join alacritty)
  git_clone https://github.com/alacritty/alacritty.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release alacritty)
  let dst = ($env.USR_LOCAL_BIN | path join alacritty)

  ln -sf $src $dst

  let bin = "/usr/local/bin/alacritty"

  if $global {
    sudo ln -sf $dst $bin
  }

  if $default {
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $dst 100
    # sudo update-alternatives --config x-terminal-emulator
  }

  if $desktop {
    sudo cp -f ($source | path join extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg)
    sudo desktop-file-install ($source | path join extra/linux/Alacritty.desktop)
    sudo update-desktop-database
  }

  if $manual {
    # with-env { PWD: $source } {
    #   sudo mkdir -p /usr/local/share/man/man1
    #   sudo mkdir -p /usr/local/share/man/man5
    #   bash -c "scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null"
    #   bash -c "scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null"
    #   bash -c "scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null"
    #   bash -c "scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null"
    # }
  }
}

export def nushell [ --global,--plugin ] {
  let source = ($env.USR_LOCAL_SOURCE | path join nushell)
  git_clone https://github.com/nushell/nushell.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --workspace --manifest-path $manifest

  let src = ($source | path join target release nu)
  let dst = ($env.USR_LOCAL_BIN | path join nu)

  ln -sf $src $dst

  let bin = "/usr/local/bin/nu"

  if $global {
    sudo ln -sf $dst $bin
  }

  if $plugin {
    let nu_plugin_query = ($source | path join target release nu_plugin_query)
    nu -c $'plugin add ($nu_plugin_query)'
  }
}

export def helix [--desktop, --global] {
  let source = ($env.USR_LOCAL_SOURCE | path join helix)
  git_clone https://github.com/helix-editor/helix $source

  let manifest = ($source | path join helix-term Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  if not ($env.HELIX_PATH | path exists) {
    mkdir $env.HELIX_PATH
  }

  let src = ($source | path join target release hx)
  let dst = ($env.HELIX_PATH | path join hx)

  ln -sf $src $dst

  if $global {
    sudo ln -sf $dst "/usr/local/bin/hx"
  }

  cp -r -u -p ($source | path join runtime) $env.HELIX_RUNTIME

  if $desktop {
    cp ($source | path join contrib/Helix.desktop) ($env.HOME | path join .local/share/applications)
    cp ($source | path join contrib/helix.png) ($env.HOME | path join .local/share/icons)
  }
}

export def evremap [ --service(-s) ] {
  let source = ($env.USR_LOCAL_SOURCE | path join evremap)
  git_clone https://github.com/wez/evremap $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let src = ($source | path join target release evremap)
  let dst = ($env.USR_LOCAL_BIN | path join evremap)

  ln -sf $src $dst
  sudo ln -sf $src "/usr/local/bin/evremap"

  if $service {
    let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join evremap.service)
    let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join evremap.service)
    ln -sf $src $dst

    systemctl --user daemon-reload
    systemctl --user enable evremap.service
    systemctl --user start evremap.service
    # systemctl --user enable --now evremap.service
  }
}

export def zed [] {
  let source = ($env.USR_LOCAL_SOURCE | path join zed)
  git_clone https://github.com/zed-industries/zed $source

  git submodule update --init --recursive
  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest
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

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release amp)
  let dst = ($env.USR_LOCAL_BIN | path join amp)

  ln -sf $src $dst
}

export def lapce [] {
  let source = ($env.USR_LOCAL_SOURCE | path join lapce)
  git_clone https://github.com/lapce/lapce $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release lapce)
  let dst = ($env.USR_LOCAL_BIN | path join lapce)

  ln -sf $src $dst
}


export def scrcpy [] {
  git clone 'https://github.com/Genymobile/scrcpy'
  cd scrcpy/
  bash ./install_release.sh
  cd '..'
  rm -rf scrcpy/
}
