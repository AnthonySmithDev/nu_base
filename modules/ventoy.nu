
export def --wrapped install [...rest] {
  sudo ($env.VENTOY_PATH | path join Ventoy2Disk.sh) ...$rest
}

export def --wrapped "persistent create" [...rest] {
  sudo ($env.VENTOY_PATH | path join CreatePersistentImg.sh) ...$rest
}

export def --wrapped "persistent extend" [...rest] {
  sudo ($env.VENTOY_PATH | path join ExtendPersistentImg.sh) ...$rest
}

export def --wrapped plugson [device: string, ...rest] {
  with-wd $env.VENTOY_PATH {||
    sudo ($env.VENTOY_PATH | path join VentoyPlugson.sh) ...$rest
  }
}

export def --wrapped vlnk [...rest] {
  sudo ($env.VENTOY_PATH | path join VentoyVlnk.sh) ...$rest
}

export def --wrapped web [...rest] {
  sudo ($env.VENTOY_PATH | path join VentoyWeb.sh) ...$rest
}

export def --wrapped gui [...rest] {
  ^($env.VENTOY_PATH | path join VentoyGUI.x86_64) ...$rest
}
