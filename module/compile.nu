
export def alacritty [ --default, --desktop, --manual ] {
  if (external exists apt) {
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  }

  let source = ($env.USR_LOCAL_SOURCE | path join alacritty)
  git_clone https://github.com/alacritty/alacritty.git $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --manifest-path $manifest

  let src = ($source | path join target release alacritty)
  let dst = ($env.USR_LOCAL_BIN | path join alacritty)

  ln -sf $src $dst

  let bin = "/usr/local/bin/alacritty"

  sudo ln -sf $dst $bin

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
    sudo mkdir -p /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/man/man5
    with-path $source {||
      bash -c "scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null"
      bash -c "scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null"
    }
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

export def evremap [ --service(-s), input ] {
  let source = ($env.USR_LOCAL_SOURCE | path join evremap)
  git_clone https://github.com/wez/evremap $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let src = ($source | path join target release evremap)
  let dst = ($env.USR_LOCAL_BIN | path join evremap)

  ln -sf $src $dst

  if $input {
    if not (group-exists input) {
      sudo groupadd uinput
    }
    sudo gpasswd -a $env.USER input
    'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
  }

  if $service {
    let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join evremap.service)
    sudo cp -f $src /usr/lib/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable evremap.service
    sudo systemctl start evremap.service
  }
}

export def ktrl [ --input, --setup, --service ] {
  let source = ($env.USR_LOCAL_SOURCE | path join ktrl)
  git_clone https://github.com/ItayGarin/ktrl $source

  let manifest = ($source | path join Cargo.toml)
  cargo build --release --locked --manifest-path $manifest

  let src = ($source | path join target release ktrl)
  let dst = ($env.USR_LOCAL_BIN | path join ktrl)

  ln -sf $src $dst
  sudo ln -sf $src "/usr/local/bin/"

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

export def audiosource [ --apk ] {
  let source = ($env.USR_LOCAL_SOURCE | path join audiosource)
  git_clone https://github.com/gdzx/audiosource $source

  let src = ($source | path join audiosource)
  let dst = ($env.USR_LOCAL_BIN | path join audiosource)
  ln -sf $src $dst

  if $apk {
    let version = "1.1"
    let filename = $"audiosource_($version).apk"
    let output = ($source | path join $filename)

    if not ($output | path exists) {
      https download $"https://github.com/gdzx/audiosource/releases/download/v($version)/audiosource.apk" -o $output
    }

    $env.AUDIOSOURCE_APK = $output
    ^audiosource install
  }
}
