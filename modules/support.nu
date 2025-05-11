
export def storages [] {
  [
    {
      "name": "Anthony"
      "type": "movil"
      "base": "/run/user/1000/gvfs/mtp:host=SAMSUNG_SAMSUNG_Android_R58T312P0ZM/Internal storage"
    }
    {
      "name": "Vanessa"
      "type": "movil"
      "base": "/run/user/1000/gvfs/mtp:host=SAMSUNG_SAMSUNG_Android_R9AR6035NRJ/Phone"
    }
    {
      "name": "B1"
      "type": "disk"
      "base": "/media/anthony/B1"
    }
    {
      "name": "B2"
      "type": "disk"
      "base": "/media/anthony/B2"
    }
    {
      "name": "B3"
      "type": "disk"
      "base": "/media/anthony/B3"
    }
  ]
}

export def disk-paths [] {
  [
    `Backup/Recent/Camera/`
    `Backup/Recent/WhatsApp/`
  ]
}

export def movil-paths [] {
  [
    `DCIM`
    `Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images/`
    `Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/`
    `Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Documents/`
  ]
}

def types [] {
  [disk movil]
}

export def select_type [type: string] {
  let storages = ($in | where type == $type)
  if ($storages | is-empty) {
    error make -u { msg: "No hay dispositivos" }
  }
  return $storages
}

export def path_exists [] {
  each {|e| if ($e.base | path exists) { $e } }
}

export def select_options [exclude: string = ''] {
  let options = ($in | where name != $exclude | get name | to text)
  if ($options | is-empty) {
    error make -u { msg: "No hay opciones" }
  }
  return $options
}

export def select_name [options: string] {
  let height = ($options | lines | length | $in + 2)
  let name = ($options | gum filter --height $height | str trim)
  if ($name | is-empty) {
    error make -u { msg: "Dispositivo no selecionado" }
  }
  return $name
}

export def select_storage [storages: table, name: string = ''] {
  return ($storages | where name == $name | first)
}

export def select_path [type: string@types] {
  if ($type == disk) {
    gum filter --no-fuzzy ...(disk-paths)
  } else if ($type == movil) {
    gum filter --no-fuzzy ...(movil-paths)
  }
}

export def device [type: string@types, --exclude(-e): record] {
  let storages = (storages | select_type $type | path_exists)
  let options = ($storages | select_options $exclude.name?)
  let name = (select_name $options)
  let storage = (select_storage $storages $name)
  let path = (select_path $type)
  return {
    name: $name
    path: ($storage | get base | path join $path)
  }
}

export def clone [type: string, src: string dst: string] {
  print $"($type): ($src) --> ($dst)\n"
  ^rclone $type $src $dst --progress --check-first --metadata --buffer-size 100M --transfers 5 --fast-list --exclude "**/Sent/**"
}

export def sync [src_type: string@types, dst_type: string@types] {
  let device_src = (device $src_type | get path)
  let basename = (gum file --directory --height=10 $device_src | path basename)
  let new_dir_src = ($device_src | path join $basename)

  let new_dir_dst = (device $dst_type | get path | path join $basename)

  print $"($new_dir_src) --> ($new_dir_dst)\n"

  clone sync $new_dir_src $new_dir_dst
}

export def copy [] {
  let src = device disk
  let dst = device disk --exclude $src

  clone copy $src.path $dst.path
}
