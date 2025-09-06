
def download_url [package: string, version: string] {
  return $"https://d.apkpure.net/b/APK/($package)?version=($version)"
}

export def devcheck [ --force(-f) ] {
  let download_url = download_url flar2.devcheck latest
  let download_path = download_apk devcheck latest $download_url $force
  install $download_path
}

export def facebook [ --force(-f) ] {
  let download_url = download_url com.facebook.katana latest
  let download_path = download_apk facebook latest $download_url $force
  install $download_path
}

export def messenger [ --force(-f) ] {
  let download_url = download_url com.facebook.orca latest
  let download_path = download_apk messenger latest $download_url $force
  install $download_path
}

export def instagram [ --force(-f) ] {
  let download_url = download_url com.instagram.android latest
  let download_path = download_apk instagram latest $download_url $force
  install $download_path
}

export def whatsapp [ --force(-f) ] {
  let download_url = download_url com.whatsapp latest
  let download_path = download_apk whatsapp latest $download_url $force
  install $download_path
}

export def whatsapp-business [ --force(-f) ] {
  let download_url = download_url com.whatsapp.w4b latest
  let download_path = download_apk whatsapp latest $download_url $force
  install $download_path
}

export def telegram [ --force(-f) ] {
  let download_url = download_url org.telegram.messenger latest
  let download_path = download_apk telegram latest $download_url $force
  install $download_path
}

export def brave [ --force(-f) ] {
  let download_url = download_url com.brave.browser latest
  let download_path = download_apk brave latest $download_url $force
  install $download_path
}

export def spotify [ --force(-f) ] {
  let download_url = download_url com.spotify.music latest
  let download_path = download_apk spotify latest $download_url $force
  install $download_path
}

export def tiktok [ --force(-f) ] {
  let download_url = download_url com.zhiliaoapp.musically latest
  let download_path = download_apk tiktok latest $download_url $force
  install $download_path
}

export def disneyplus [ --force(-f) ] {
  let download_url = download_url com.disney.disneyplus latest
  let download_path = download_apk disneyplus latest $download_url $force
  install $download_path
}

export def netflix [ --force(-f) ] {
  let download_url = download_url com.netflix.mediaclient latest
  let download_path = download_apk netflix latest $download_url $force
  install $download_path
}

export def prime [ --force(-f) ] {
  let download_url = download_url com.amazon.amazonvideo.livingroom latest
  let download_path = download_apk prime latest $download_url $force
  install $download_path
}

export def max [ --force(-f) ] {
  let download_url = download_url com.wbd.stream latest
  let download_path = download_apk max latest $download_url $force
  install $download_path
}
