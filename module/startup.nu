
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

export def mouseless-user [ --status, --remove ] {

  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join mouseless-user.service)
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join mouseless.service)

  if $status {
    systemctl --user status mouseless.service
    return
  }

  if $remove {
    systemctl --user stop mouseless.service
    systemctl --user disable mouseless.service
    rm -rf $dst
    return
  }

  cp -f $src $dst

  uinput

  systemctl --user enable mouseless.service
  systemctl --user start mouseless.service
  systemctl --user status mouseless.service
}

export def mouseless [ --status, --remove ] {

  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join mouseless.service)
  let dst = ("/etc/systemd/system/" | path join mouseless.service)

  if $status {
    sudo systemctl status mouseless.service
    return
  }

  if $remove {
    sudo systemctl stop mouseless.service
    sudo systemctl disable mouseless.service
    sudo rm -rf $dst
    return
  }

  sudo cp -f $src $dst

  sudo systemctl enable mouseless.service
  sudo systemctl start mouseless.service
  sudo systemctl status mouseless.service
}

export def evremap [] {
  sudo gpasswd -a $env.USER input
  echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules

  echo 'KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
}
