
export def katana [
  --init(-i)
  --remove(-r)
] {
  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join kanata.service)
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join kanata.service)

  if $init {
    cp -f $src $dst
    systemctl --user daemon-reload
    systemctl --user enable kanata.service
    systemctl --user start kanata.service
  }

  if $remove {
    systemctl --user stop kanata.service
    systemctl --user disable kanata.service
    rm -rf $dst
  }

  systemctl --user status kanata.service
}

export def services [] {
  [kanata]
}

export def commands [] {
  [status restart start stop enable disable]
}

export def user [service: string@services, command: string@commands] {
  systemctl --user $command $"($service).service"
}
