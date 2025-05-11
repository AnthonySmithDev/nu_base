
def all-devices [] {
  [
    {
      name: B1
      device: '/dev/sda'
      fs_type: 'exfat'
    }
    {
      name: B2
      device: '/dev/sdb'
      fs_type: 'exfat'
    }
    {
      name: B3
      device: '/dev/sdd'
      fs_type: 'exfat'
    }
  ]
}

def names [] {
  all-devices | get name
}

def get-device [ name: string@names ] {
  all-devices | where name == $name | first
}

export def mount [ name: string@names ] {
  let disk = get-device $name
  let disk_path = ("/media" | path join $env.USER $name)
  if ($disk_path | path exists) {
    if (ls $disk_path | is-empty) {
      sudo rm -rf $disk_path
    } else {
      return
    }
  }
  sudo systemctl daemon-reload
  sudo mkdir -p $disk_path
  if $disk.fs_type == "exfat" {
    sudo mount -t $disk.fs_type -o uid=1000,gid=1000,dmask=022,fmask=133 $disk.device $disk_path
  } else {
    sudo mount $disk.device $disk_path
  }
}

export def umount [ name: string@names ] {
  let disk = get-device $name
  let disk_path = ("/media" | path join $env.USER $name)
  if ($disk_path | path exists) {
    if (ls $disk_path | is-empty) {
      sudo rm -rf $disk_path
      return
    }
  } else {
    return
  }
  sudo umount $disk_path
  sudo rm -rf $disk_path

  # sudo lsof +f -- $disk.path
  # sudo fuser -v $disk.path

  # sudo fuser -km $disk.path
}

# export def format [ name: string@names, --yes(-y) ] {
#   let disk = get-device $name
#   if $yes {
#     sudo mkfs.exfat -n $name $disk.device
#   }
# }
