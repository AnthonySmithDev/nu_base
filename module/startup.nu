
export def mouseless [] {
  let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join mouseless.service)
  let dst = ($env.CONFIG_SYSTEMD_USER_DST | path join mouseless.service)

  cp -f $src $dst

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

  systemctl --user enable mouseless.service
  systemctl --user start mouseless.service
  systemctl --user status mouseless.service
}
