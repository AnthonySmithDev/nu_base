
export def install [apk: path] {
  if (exists-external waydroid) {
    try {
      waydroid app install $apk
    }
  }
  if (exists-external adb) {
    try {
      # adb wait-for-device
      adb install -r -g $apk
    }
  }
}

export use github.nu *
export use apkpure.nu *

export def "group streaming" [] {
  disneyplus
  netflix
  prime
  max
}

export def "group social" [] {
  facebook
  messenger
  instagram
  whatsapp
  telegram
}

export def "group media" [] {
  tiktok 
  spotify  
}

export def "group base" [] {
  devcheck 
  blokada5 
  DroidIfy
  InnerTune 
  OuterTune
  Metrolist
}
