
export def alacritty [] {
  deps alacritty

  let source = ($env.USR_LOCAL_SOURCE | path join alacritty)
  git-down https://github.com/alacritty/alacritty.git $source v0.14

  let manifest = ($source | path join Cargo.toml)
  cargo build --manifest-path $manifest --release --no-default-features --features=wayland

  let name = "alacritty"
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_SHARE | path join alacritty_source)

  rm -f $dst
  cp -f $src $dst

  ln -sf $dst ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)

  sudo cp -f ($source | path join extra/logo/alacritty-term.svg) /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install ($source | path join extra/linux/Alacritty.desktop)
  sudo update-desktop-database

  sudo mkdir -p /usr/local/share/man/man1
  sudo mkdir -p /usr/local/share/man/man5
  open ($source | path join extra/man/alacritty.1.scd) | scdoc | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz | null
  open ($source | path join extra/man/alacritty-msg.1.scd) | scdoc | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz | null
  open ($source | path join extra/man/alacritty.5.scd) | scdoc | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz | null
  open ($source | path join extra/man/alacritty-bindings.5.scd) | scdoc | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz | null

  # sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $dst 100
  # sudo update-alternatives --config x-terminal-emulator
}

export def nushell [ --plugin ] {
  let source = ($env.USR_LOCAL_SOURCE | path join nushell)
  git-down https://github.com/nushell/nushell.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --workspace --manifest-path $manifest

  let name = 'nu'
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_SHARE | path join nu_source)

  rm -f $dst
  cp -f $src $dst

  ln -sf $dst ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)

  if $plugin {
    let nu_plugin_query = ($source | path join target release nu_plugin_query)
    nu -c $'plugin add ($nu_plugin_query)'
  }
}

export def rio [] {
  deps rio

  let source = ($env.USR_LOCAL_SOURCE | path join rio)
  git-down https://github.com/raphamorim/rio.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build -p rioterm --release --no-default-features --features=wayland --manifest-path $manifest

  let name = 'rio'
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_SHARE | path join rio_source)

  rm -f $dst
  cp -f $src $dst

  ln -sf $dst ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)
}

export def zellij [] {
  let source = ($env.USR_LOCAL_SOURCE | path join zellij)
  git-down https://github.com/zellij-org/zellij.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'zellij'
  let src = ($source | path join target release $name)
  let dst = ($env.USR_LOCAL_SHARE | path join zellij_source)

  rm -f $dst
  cp -f $src $dst

  ln -sf $dst ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $dst ($env.SYS_LOCAL_BIN | path join $name)
}

export def audiosource [] {
  let source = ($env.USR_LOCAL_SOURCE | path join audiosource)
  git-down https://github.com/gdzx/audiosource $source

  let name = 'audiosource'
  let src = ($source | path join $name)
  let dst = ($env.USR_LOCAL_SHARE | path join audiosource_source)

  rm -f $dst
  cp -f $src $dst

  ln -sf $dst ($env.USR_LOCAL_BIN | path join $name)
}

export def helix [ --desktop ] {
  let source = ($env.USR_LOCAL_SOURCE | path join helix)
  git-down https://github.com/helix-editor/helix $source

  let manifest = ($source | path join helix-term Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let src_bin = ($source | path join target release hx)
  let src_runtime = ($source | path join runtime)

  ln -sf $src_bin ($env.USR_LOCAL_BIN | path join hx)
  sudo ln -sf $src_bin ($env.SYS_LOCAL_BIN | path join hx)

  ln -sf $src_runtime ($env.USR_LOCAL_BIN | path join runtime)
  sudo ln -sf $src_runtime ($env.SYS_LOCAL_BIN | path join runtime)

  if $desktop {
    cp ($source | path join contrib/Helix.desktop) ($env.HOME | path join .local/share/applications)
    cp ($source | path join contrib/helix.png) ($env.HOME | path join .local/share/icons)
  }
}

export def evremap [ --uinput(-u) ] {
  let source = ($env.USR_LOCAL_SOURCE | path join evremap)
  git-down https://github.com/wez/evremap $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'evremap'
  let src = ($source | path join target release $name)
  ln -sf $src ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $src ($env.SYS_LOCAL_BIN | path join $name)

  if $uinput {
    if not (exists-group input) {
      sudo groupadd uinput
    }
    sudo gpasswd -a $env.USER input
    'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules | null
  }
}

export def ktrl [ --input, --setup, --service ] {
  let source = ($env.USR_LOCAL_SOURCE | path join ktrl)
  git-down https://github.com/ItayGarin/ktrl $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let name = 'ktrl'
  let src = ($source | path join target release $name)
  ln -sf $src ($env.USR_LOCAL_BIN | path join $name)
  sudo ln -sf $src ($env.SYS_LOCAL_BIN | path join $name)

  if $input {
    if not (exists-user ktrl) {
      sudo useradd -r -s /bin/false ktrl
    }
    if not (exists-group uinput) {
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

export def kanata-uinput [] {
  if not (exists-group uinput) {
    sudo groupadd uinput
  }
  sudo usermod -aG input $env.USER
  sudo usermod -aG uinput $env.USER

  let text = 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'
  $text | sudo tee /etc/udev/rules.d/99-input.rules

  sudo udevadm control --reload-rules
  sudo udevadm trigger

  ls -l /dev/uinput
  sudo modprobe uinput
}

export def zed [] {
  let source = ($env.USR_LOCAL_SOURCE | path join zed)
  git-down https://github.com/zed-industries/zed $source

  git submodule update --init --recursive
  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest
}

export def riv [] {
  let path = ($env.USR_LOCAL_SOURCE | path join riv)
  git-down https://github.com/Davejkane/riv $path

  with-wd $path {||
    cargo install --path .
  }
}

export def vimiv [] {
  let path = ($env.USR_LOCAL_SOURCE | path join vimiv-qt)
  git-down https://github.com/karlch/vimiv-qt $path

  with-wd $path {||
    sudo make --file "misc/Makefile" install
  }
}

export def hargo [] {
  let path = ($env.USR_LOCAL_SOURCE | path join hargo)
  git-down https://github.com/mrichman/hargo $path

  with-wd $path {||
    make install
  }
}

export def nchat [] {
  let path = ($env.USR_LOCAL_SOURCE | path join nchat)
  git-down https://github.com/d99kris/nchat $path

  with-wd $path {||
    bash make.sh deps
    bash make.sh build
    bash make.sh install
  }
}

export def http-to-ws [] {
  let path = ($env.USR_LOCAL_SOURCE | path join http-to-ws)
  git-down https://github.com/AnthonySmithDev/http-to-ws $path

  with-wd $path {||
    go install .
  }
}

export def tasklite [] {
  let path = ($env.USR_LOCAL_SOURCE | path join TaskLite)
  git-down https://github.com/ad-si/TaskLite $path

  with-wd $path {||
    stack install tasklite-core
  }
}

export def amp [] {
  let source = ($env.USR_LOCAL_SOURCE | path join amp)
  git-down https://github.com/jmacdonald/amp $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release amp)
  let dst = ($env.USR_LOCAL_BIN | path join amp)

  ln -sf $src $dst
}

export def lapce [] {
  let source = ($env.USR_LOCAL_SOURCE | path join lapce)
  git-down https://github.com/lapce/lapce $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release lapce)
  let dst = ($env.USR_LOCAL_BIN | path join lapce)

  ln -sf $src $dst
}

export def scrcpy [] {
  deps scrcpy

  let path = ($env.USR_LOCAL_SOURCE | path join scrcpy)
  git-down https://github.com/Genymobile/scrcpy $path

  with-wd $path {||
    bash ./install_release.sh
  }
}

export def mouseless-status [] {
  let source = ($env.USR_LOCAL_SOURCE | path join mouseless-status)
  git-down git@github.com:AnthonySmithDev/mouseless-status.git $source
  let app = ($env.USR_LOCAL_BIN | path join ms)

  with-wd $source {
    go build -o ./app ms/main.go
    mv ./app $app
    sudo ln -sf $app /usr/local/bin/
  }
}

export def --env foot [] {
  let path = ($env.USR_LOCAL_SOURCE | path join foot)
  git-down https://codeberg.org/dnkl/foot $path

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

export def contour [] {
  let path = ($env.USR_LOCAL_SOURCE | path join contour)
  git-down https://github.com/contour-terminal/contour.git $path

  with-wd $path {||
    bash scripts/install-deps.sh
    # cmake --preset linux-release
    # cmake --build --preset linux-release
    cmake --build --preset linux-release --target install
  }
}

export def chafa [] {
  sudo apt install -y libavif-dev librsvg2-dev libjxl-dev

  let path = ($env.USR_LOCAL_SOURCE | path join chafa)
  git-down https://github.com/hpjansson/chafa.git $path

  with-wd $path {||
    bash autogen.sh
    make
    sudo make install
  }
}

export def cosmic-clipboard-manager [] {
  let path = ($env.USR_LOCAL_SOURCE | path join cosmic-clipboard-manager)
  git-down https://github.com/cosmic-utils/clipboard-manager.git $path

  with-wd $path {||
    # git checkout '0.1.0'
    sudo apt install libsqlite3-dev sqlite3 just cargo libxkbcommon-dev
    just build-release
    sudo just install
  }
}

export def websocket-inspector [] {
  let path = ($env.USR_LOCAL_SOURCE | path join websocket-inspector)
  git-down https://github.com/ecthiender/websocket-inspector.git $path

  with-wd $path {||
    stack install
  }
}

export def ente [] {
  let path = ($env.USR_LOCAL_SOURCE | path join ente)
  git-down https://github.com/ente-io/ente.git $path

  with-wd ($path | path join server) {||
    docker compose up -d --build
    curl http://localhost:8080/ping
  }

  with-wd ($path | path join web) {||
    git submodule update --init --recursive
    yarn install
    NEXT_PUBLIC_ENTE_ENDPOINT=http://localhost:8080 yarn dev
  }
}

export def apx [] {
  let path = ($env.USR_LOCAL_SOURCE | path join apx)
  git clone --recursive https://github.com/Vanilla-OS/apx.git $path

  with-wd $path {||
    make build
    sudo make install
    sudo make install-manpages
  }
}