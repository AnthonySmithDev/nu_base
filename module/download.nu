
export def "ubuntu desktop" [] {
  http download https://releases.ubuntu.com/23.10/ubuntu-23.10.1-desktop-amd64.iso
}

export def "ubuntu server" [] {
  http download https://releases.ubuntu.com/23.10/ubuntu-23.10-live-server-amd64.iso
}

export def "ubuntu sway" [] {
  http download https://downloads.ubuntusway.com/stable/23.10/ubuntusway-23.10-desktop-amd64.iso
}

export def "manjaro gnome" [] {
  http download https://download.manjaro.org/gnome/23.1.4/manjaro-gnome-23.1.4-240406-linux66.iso
}

export def "manjaro sway" [] {
  http download https://manjaro-sway.download/download?file=manjaro-sway-23.1.4-240422-linux66.iso -o manjaro-sway-23.1.4-240422-linux66.iso
}

export def "tileOS sway" [] {
  http download https://downloads.tile-os.com/stable/sway/tileos-sway-1.0-desktop-amd64.iso
}

export def "tileOS river" [] {
  http download https://downloads.tile-os.com/stable/river/tileos-river-1.0-desktop-amd64.iso
}

export def "pop-os" [] {
  http download https://iso.pop-os.org/24.04/amd64/intel/11/pop-os_24.04_amd64_intel_11.iso
}
