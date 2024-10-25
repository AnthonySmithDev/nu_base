
export def kanata [] {
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
