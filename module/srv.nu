
def services [] {
  ls -s $env.CONFIG_SYSTEMD_USER_SRC | get name | split column . name | get name
}

def commands [] {
  [status start stop restart enable disable]
}

def filename [name: string] {
  [$name service] | str join .
}

export def init [service: string@services] {
  let unit = filename $service
  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join $unit)
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join $unit)

  if not ($dst | path exists) {
    cp -f $src $dst
    systemctl --user daemon-reload
    systemctl --user enable $unit
    systemctl --user start $unit
  }
}

export def remove [service: string@services] {
  let unit = filename $service
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join $unit)

  if ($dst | path exists) {
    systemctl --user stop $unit
    systemctl --user disable $unit
    rm -rf $dst
  }
}

export def user [service: string@services, command: string@commands] {
  systemctl --user $command (filename $service)
}

export def sys [service: string@services, command: string@commands] {
  sudo systemctl --user $command (filename $service)
}
