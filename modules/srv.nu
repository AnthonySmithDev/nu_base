export-env {
  $env.SYSTEMD_USER_SRC = ($env.HOME | path join nu/nu_files/systemd/user/)
  $env.SYSTEMD_USER_DST = ($env.HOME | path join .config/systemd/user/)

  $env.SYSTEMD_ROOT_SRC = ($env.HOME | path join nu/nu_files/systemd/root/)
  $env.SYSTEMD_ROOT_DST = ("/etc" | path join systemd/system/)
}

def commands [] {
  [init remove status start stop restart enable disable]
}

def filename [name: string] {
  [$name service] | str join .
}

def user-services [] {
  ls -s $env.SYSTEMD_USER_SRC | get name | split column . name | get name
}

export def user [service: string@user-services, command: string@commands] {
  let unit = filename $service
  let src = ($env.SYSTEMD_USER_SRC | path join $unit)
  let dst = ($env.SYSTEMD_USER_DST | path join $unit)

  match $command {
    "init" => {
      if not ($dst | path exists) {
        cp $src $dst
        systemctl --user daemon-reload
        systemctl --user enable $unit
        systemctl --user start $unit
      }
    }
    "remove" => {
      if ($dst | path exists) {
        systemctl --user stop $unit
        systemctl --user disable $unit
        rm -rf $dst
      }
    }
    _ => { systemctl --user $command $unit }
  }
}

def root-services [] {
  ls -s $env.SYSTEMD_ROOT_SRC | get name | split column . name | get name
}

export def root [service: string@root-services, command: string@commands] {
  let unit = filename $service
  let src = ($env.SYSTEMD_ROOT_SRC | path join $unit)
  let dst = ($env.SYSTEMD_ROOT_DST | path join $unit)

  match $command {
    "init" => {
      if not ($dst | path exists) {
        sudo cp $src $dst
        sudo systemctl daemon-reload
        sudo systemctl enable $unit
        sudo systemctl start $unit
      }
    }
    "remove" => {
      if ($dst | path exists) {
        sudo systemctl stop $unit
        sudo systemctl disable $unit
        sudo rm -rf $dst
      }
    }
    _ => { sudo systemctl $command $unit }
  }
}
