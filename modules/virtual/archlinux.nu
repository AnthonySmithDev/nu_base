
def dir [] {
  let dir = ($env.VIRTUAL | path join archlinux)
  if not ($dir | path exists) {
    mkdir $dir
  }
  return $dir
}

def download_iso [] {
  let filename = (dir | path join archlinux-x86_64.iso)
  if not ($filename | path exists) {
    http download https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso -o $filename
  }
}

def download_qcow2 [] {
  let filename = (dir | path join archlinux-x86_64-basic.qcow2)
  if not ($filename | path exists) {
    http download https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic.qcow2 -o $filename
  }
}

def create_image [] {
  let filename = (dir | path join archlinux.qcow2)
  if not ($filename | path exists) {
    qemu-img create -f qcow2 $filename 10G
  }
}

def system [] {
  let cdrom = (dir | path join archlinux-x86_64.iso)
  let img = (dir | path join archlinux.qcow2)
  qemu-system-x86_64 -smp 6 -m 4096 -cdrom $cdrom -hda $img
}

export def up [] {
  download_iso
  create_image
  system
}
