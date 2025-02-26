
export def dir [] {
  let dir = ($env.VIRTUAL | path join nixos)
  if not ($dir | path exists) {
    mkdir $dir
  }
  return $dir
}

export def download [--minimal] {
  if $minimal {
    let filename = (dir | path join nixos-minimal-x86_64-linux.iso)
    if not ($filename | path exists) {
      http download https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso -o $filename
    }
  } else {
    let filename = (dir | path join nixos-gnome-x86_64-linux.iso)
    if not ($filename | path exists) {
      http download https://channels.nixos.org/nixos-23.11/latest-nixos-gnome-x86_64-linux.iso -o $filename
    }
  }
}

export def image [--minimal] {
  if $minimal {
    let filename = (dir | path join nixos-minimal.qcow2)
    if not ($filename | path exists) {
      qemu-img create -f qcow2 $filename 10G
    }
  } else {
    let filename = (dir | path join nixos-gnome.qcow2)
    if not ($filename | path exists) {
      qemu-img create -f qcow2 $filename 20G
    }
  }
}

export def system [--minimal] {
  if $minimal {
    let iso = (dir | path join nixos-minimal-x86_64-linux.iso)
    let img = (dir | path join nixos-minimal.qcow2)
    qemu-system-x86_64 -smp 4 -m 2048 -cdrom $iso -hda $img
  } else {
    let iso = (dir | path join nixos-gnome-x86_64-linux.iso)
    let img = (dir | path join nixos-gnome.qcow2)
    qemu-system-x86_64 -smp 6 -m 4096 -cdrom $iso -hda $img
  }
}

export def up [--minimal] {
  if $minimal {
    download --minimal
    image --minimal
    system --minimal
  } else {
    download
    image
    system 
  }
}
