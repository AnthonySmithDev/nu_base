
def uinput [] {
  let rules = $'/etc/udev/rules.d/99-($env.USER).rules'
  if not ($rules | path exists) {
    let lines = [
      $'KERNEL=="uinput", GROUP="($env.USER)", MODE:="0660"'
      $'KERNEL=="event*", GROUP="($env.USER)", NAME="input/%k", MODE="660"'
    ]
    $lines | to text | sudo tee $rules
  }

  let conf = "/etc/modules-load.d/uinput.conf"
  if not ($conf | path exists) {
    "uinput" | sudo tee $conf
  }
}

export def mouseless-user [
  --init
  --remove
  --stop
  --disable
  --restart
  --status
] {
  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join mouseless-user.service)
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join mouseless.service)

  if $init {
    uinput

    cp -f $src $dst
    systemctl --user enable mouseless.service
    systemctl --user start mouseless.service
    systemctl --user status mouseless.service
    return
  }

  if $remove {
    systemctl --user stop mouseless.service
    systemctl --user disable mouseless.service
    rm -rf $dst
    return
  }

  if $stop {
    systemctl --user stop mouseless.service
    return
  }

  if $disable {
    systemctl --user disable mouseless.service
    return
  }

  if $restart {
    systemctl --user restart mouseless.service
    return
  }

  if $status {
    systemctl --user status mouseless.service
    return
  }
}

export def mouseless [
  --init
  --remove
  --stop
  --disable
  --restart
  --status
] {

  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join mouseless.service)
  let dst = ("/etc/systemd/system/" | path join mouseless.service)

  if $init {
    sudo cp -f $src $dst
    sudo systemctl enable mouseless.service
    sudo systemctl start mouseless.service
    sudo systemctl status mouseless.service
    return
  }

  if $remove {
    sudo systemctl stop mouseless.service
    sudo systemctl disable mouseless.service
    sudo rm -rf $dst
    return
  }

  if $stop {
    sudo systemctl stop mouseless.service
    return
  }

  if $disable {
    sudo systemctl disable mouseless.service
    return
  }

  if $restart {
    sudo systemctl restart mouseless.service
    return
  }

  if $status {
    sudo systemctl status mouseless.service
    return
  }
}

export def evremap [] {
  sudo gpasswd -a $env.USER input
  echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules

  echo 'KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
}
