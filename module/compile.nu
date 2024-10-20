
export def alacritty [ --default, --desktop, --manual ] {
  if (external exists apt) {
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  }

  let source = ($env.USR_LOCAL_SOURCE | path join alacritty)
  git_clone https://github.com/alacritty/alacritty.git $source v0.14

  let manifest = ($source | path join Cargo.toml)
  cargo build --manifest-path $manifest --release --no-default-features --features=wayland
  # cargo build --manifest-path $manifest --release

  let name = "alacritty"
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_BIN | path join $name)

  ln -sf $src $dst
  sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)

  if $default {
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $dst 100
    # sudo update-alternatives --config x-terminal-emulator
  }

  if $desktop {
    sudo cp -f ($source | path join extra/logo/alacritty-term.svg) /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install ($source | path join extra/linux/Alacritty.desktop)
    sudo update-desktop-database
  }

  if $manual {
    sudo mkdir -p /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/man/man5
    with-path $source {||
      open extra/man/alacritty.1.scd | scdoc | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz | null
      open extra/man/alacritty-msg.1.scd | scdoc | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz | null
      open extra/man/alacritty.5.scd | scdoc | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz | null
      open extra/man/alacritty-bindings.5.scd | scdoc | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz | null
    }
  }
}

export def --env foot [] {
  let path = ($env.USR_LOCAL_SOURCE | path join foot)
  git_clone https://codeberg.org/dnkl/foot $path

  with-wd $path {||
    mkdir bld/release
    cd bld/release

    $env.CFLAGS = " -O3"
    meson ... -Ddefault-terminfo=foot -Dterminfo-base-name=foot-extra
    meson --buildtype=release --prefix=/usr -Db_lto=true ../..
    ninja
    ninja test
    ninja install
  }
}

export def nushell [ --global,--plugin ] {
  let source = ($env.USR_LOCAL_SOURCE | path join nushell)
  git_clone https://github.com/nushell/nushell.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --workspace --manifest-path $manifest

  let name = 'nu'
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_BIN | path join $name)
  ln -sf $src $dst

  if $global {
    sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)
  }

  if $plugin {
    let nu_plugin_query = ($source | path join target release nu_plugin_query)
    nu -c $'plugin add ($nu_plugin_query)'
  }
}

export def zellij [ --global,--plugin ] {
  let source = ($env.USR_LOCAL_SOURCE | path join zellij)
  git_clone https://github.com/zellij-org/zellij.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'zellij'
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_BIN | path join $name)

  ln -sf $src $dst

  if $global {
    sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)
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

  let name = 'hx'
  let src = ($source | path join target release $name)
  let dst = ($env.HELIX_PATH | path join $name)

  ln -sf $src $dst

  if $global {
    sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)
  }

  cp -r -u -p ($source | path join runtime) $env.HELIX_RUNTIME

  if $desktop {
    cp ($source | path join contrib/Helix.desktop) ($env.HOME | path join .local/share/applications)
    cp ($source | path join contrib/helix.png) ($env.HOME | path join .local/share/icons)
  }
}

export def evremap [ --uinput(-u) ] {
  let source = ($env.USR_LOCAL_SOURCE | path join evremap)
  git_clone https://github.com/wez/evremap $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'evremap'
  let src = ($source | path join target release $name)
  ln -sf $src ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $src ($env.SYS_LOCAL_BIN | path join $name)

  if $uinput {
    if not (group-exists input) {
      sudo groupadd uinput
    }
    sudo gpasswd -a $env.USER input
    'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules | null
  }
}

export def ktrl [ --input, --setup, --service ] {
  let source = ($env.USR_LOCAL_SOURCE | path join ktrl)
  git_clone https://github.com/ItayGarin/ktrl $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'ktrl'
  let src = ($source | path join target release $name)
  ln -sf $src ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $src ($env.SYS_LOCAL_BIN | path join $name)

  if $input {
    if not (user-exists ktrl) {
      sudo useradd -r -s /bin/false ktrl
    }
    if not (group-exists uinput) {
      sudo groupadd uinput
    }
    sudo usermod -aG input ktrl
    sudo usermod -aG uinput ktrl
    sudo usermod -aG audio ktrl

    sudo cp ($source | path join etc/99-uinput.rules) /etc/udev/rules.d/
  }

  if $setup {
    sudo mkdir -p /opt/ktrl
    sudo cp -r ($source | path join assets) /opt/ktrl
    sudo cp ($source | path join examples/cfg.ron) /opt/ktrl

    sudo chown -R $"ktrl:($env.USER)" /opt/ktrl
    sudo chmod -R 0770 /opt/ktrl
  }

  if $service {
    edit ./etc/ktrl.service # change your device path
    sudo cp ./etc/ktrl.service /etc/systemd/system
    sudo systemctl daemon-reload
    sudo systemctl start ktrl.service
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
  let path = ($env.USR_LOCAL_SOURCE | path join riv)
  git_clone https://github.com/Davejkane/riv $path

  with-wd $path {||
    cargo install --path .
  }
}

export def vimiv [] {
  let path = ($env.USR_LOCAL_SOURCE | path join vimiv-qt)
  git_clone https://github.com/karlch/vimiv-qt $path

  with-wd $path {||
    sudo make --file "misc/Makefile" install
  }
}

export def hargo [] {
  let path = ($env.USR_LOCAL_SOURCE | path join hargo)
  git_clone https://github.com/mrichman/hargo $path

  with-wd $path {||
    make install
  }
}

export def nchat [] {
  let path = ($env.USR_LOCAL_SOURCE | path join nchat)
  git_clone https://github.com/d99kris/nchat $path

  with-wd $path {||
    bash make.sh deps
    bash make.sh build
    bash make.sh install
  }
}

export def http-to-ws [] {
  let path = ($env.USR_LOCAL_SOURCE | path join http-to-ws)
  git_clone https://github.com/AnthonySmithDev/http-to-ws $path

  with-wd $path {||
    go install .
  }
}

export def tasklite [] {
  let path = ($env.USR_LOCAL_SOURCE | path join TaskLite)
  git_clone https://github.com/ad-si/TaskLite $path

  with-wd $path {||
    stack install tasklite-core
  }
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
  deps scrcpy

  let path = ($env.USR_LOCAL_SOURCE | path join scrcpy)
  git_clone https://github.com/Genymobile/scrcpy $path

  with-wd $path {||
    bash ./install_release.sh
  }
}

export def mouseless-status [] {
  let source = ($env.USR_LOCAL_SOURCE | path join mouseless-status)
  git_clone git@github.com:AnthonySmithDev/mouseless-status.git $source
  let app = ($env.USR_LOCAL_BIN | path join ms)

  with-wd $source {
    go build -o ./app ms/main.go
    mv ./app $app
    sudo ln -sf $app /usr/local/bin/
  }
}

export def audiosource [] {
  let source = ($env.USR_LOCAL_SOURCE | path join audiosource)
  git_clone https://github.com/gdzx/audiosource $source

  let src = ($source | path join audiosource)
  let dst = ($env.USR_LOCAL_BIN | path join audiosource)
  ln -sf $src $dst
}
