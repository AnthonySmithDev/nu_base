
export def dir [] {
  let dir = ($env.VIRTUAL | path join archlinux)
  if not ($dir | path exists) {
    mkdir $dir
  }
  return $dir
}

export def download [] {
  let filename = (dir | path join archlinux-x86_64.iso)
  if not ($filename | path exists) {
    http download https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso -o $filename
  }
}

export def image [] {
  let filename = (dir | path join archlinux.qcow2)
  if not ($filename | path exists) {
    qemu-img create -f qcow2 $filename 10G
  }
}

export def system [] {
  let iso = (dir | path join archlinux-x86_64.iso)
  let img = (dir | path join archlinux.qcow2)
  qemu-system-x86_64 -smp 6 -m 4096 -cdrom $iso -hda $img
}

export def up [] {
  download
  image
  system 
}
