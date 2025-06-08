
export-env {
  $env.DATA_PATH = ($env.HOME | path join nu/nu_base/data/)
  $env.SYSTEMD_PATH = ($env.DATA_PATH | path join systemd)
}

def commands [] {
  [init remove status start stop restart enable disable]
}

def filename [name: string] {
  [$name service] | str join .
}

def user-services [] {
  ls -s ($env.SYSTEMD_PATH | path join user) | get name | split column . name | get name
}

export def user [service: string@user-services, command: string@commands] {
  let unit = filename $service
  let src = ($env.SYSTEMD_PATH | path join user $unit)
  let dst = ($env.HOME | path join .config/systemd/user/ $unit)

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
  ls -s ($env.SYSTEMD_PATH | path join root) | get name | split column . name | get name
}

export def root [service: string@root-services, command: string@commands] {
  let unit = filename $service
  let src = ($env.SYSTEMD_PATH | path join root $unit)
  let dst = ("/etc" | path join systemd/system/ $unit)

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
