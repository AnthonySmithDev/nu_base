
def download_apk [name: string, version: string, url: string, force: bool] {
  let dirname = ($env.PKG_CACHE_PATH | path join apk $name)
  mkdir $dirname

  let path = ($dirname | path join $"($name)_($version).apk")
  if $force or not ($path | path exists) {
    print $"Download: ($name) - ($version)"
    http download $url --output $path
  }
  return $path
}

export def install [apk: path] {
  if (exists-external waydroid) {
    if (waydroid status | from yaml  | get Session) == STOPPED {
      return
    }
    try {
      waydroid app install $apk
    }
  }
  if (exists-external adb) {
    let devices = adb devices | str trim | lines | skip | to text | parse '{name}	{status}'
    if ($devices | is-empty) {
      return
    }
    try {
      # adb wait-for-device
      adb install -r -g $apk
    }
  }
}

export use fdroid.nu *
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
