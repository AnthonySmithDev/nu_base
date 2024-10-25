
export def "ubuntu desktop" [] {
  https download https://releases.ubuntu.com/23.10/ubuntu-23.10.1-desktop-amd64.iso
}

export def "ubuntu server" [] {
  https download https://releases.ubuntu.com/23.10/ubuntu-23.10-live-server-amd64.iso
}

export def "ubuntu sway" [] {
  https download https://downloads.ubuntusway.com/stable/23.10/ubuntusway-23.10-desktop-amd64.iso
}

export def "manjaro gnome" [] {
  https download https://download.manjaro.org/gnome/23.1.4/manjaro-gnome-23.1.4-240406-linux66.iso
}

export def "manjaro sway" [] {
  https download https://manjaro-sway.download/download?file=manjaro-sway-23.1.4-240422-linux66.iso -o manjaro-sway-23.1.4-240422-linux66.iso
}

export def "tileOS sway" [] {
  https download https://downloads.tile-os.com/stable/sway/tileos-sway-1.0-desktop-amd64.iso
}

export def "tileOS river" [] {
  https download https://downloads.tile-os.com/stable/river/tileos-river-1.0-desktop-amd64.iso
}

export def "pop-os" [] {
  https download https://iso.pop-os.org/24.04/amd64/intel/10/pop-os_24.04_amd64_intel_10.iso
}
