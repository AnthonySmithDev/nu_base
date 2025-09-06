
export def Aurora [ --force(-f) ] {
  let repository = "aurora"
  let version = "70"
  let download_url = $"https://f-droid.org/repo/com.aurora.store_($version).apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def RootlessJamesDSP [ --force(-f) ] {
  let repository = "RootlessJamesDSP"
  let version = "50"
  let download_url = $"https://f-droid.org/repo/me.timschneeberger.rootlessjamesdsp_($version).apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path

  adb shell pm grant me.timschneeberger.rootlessjamesdsp android.permission.DUMP
  adb shell appops set me.timschneeberger.rootlessjamesdsp PROJECT_MEDIA allow
  adb shell appops set me.timschneeberger.rootlessjamesdsp SYSTEM_ALERT_WINDOW allow
}
