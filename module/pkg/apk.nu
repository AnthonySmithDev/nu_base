
def install [apk: path] {
  adb wait-for-device
  adb install -r -g $apk
}

export def NewPipe [] {
  let version = '0.27.2'
  let name = $'NewPipe_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/TeamNewPipe/NewPipe/releases/download/v($version)/NewPipe_v($version).apk' -o $output
  }

  install $output
}

export def LibreTube [] {
  let version = '0.25.2'
  let name = $'LibreTube_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/libre-tube/LibreTube/releases/download/v($version)/app-universal-release.apk' -o $output
  }

  install $output
}

export def InnerTune [] {
  let version = ghub version 'z-huang/InnerTune'
  let name = $'InnerTune_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/z-huang/InnerTune/releases/download/v($version)/InnerTune_v($version)_foss.apk' -o $output
  }

  install $output
}

export def OpenTune [] {
  let version = ghub version 'Arturo254/OpenTune'
  let name = $'OpenTune_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download https://github.com/Arturo254/OpenTune/releases/download/($version)/app-foss-release.apk -o $output
  }

  install $output
}

export def OuterTune [] {
  let version = ghub version 'DD3Boh/OuterTune'
  let name = $'OuterTune_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/DD3Boh/OuterTune/releases/download/v($version)/OuterTune-($version)-arm64-release.apk' -o $output
  }

  install $output
}

export def Metrolist [] {
  let version = ghub version 'mostafaalagamy/Metrolist'
  let name = $'Metrolist_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download https://github.com/mostafaalagamy/Metrolist/releases/download/v10.8.0/Metrolist.apk -o $output
  }

  install $output
}

export def RiMusic [] {
  let version = ghub version 'fast4x/RiMusic'
  let name = $'RiMusic_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)
  https://github.com/fast4x/RiMusic/releases/download/v0.6.65.1/app-foss-release.apk

  if not ($output | path exists) {
    https download $'https://github.com/fast4x/RiMusic/releases/download/v($version)/app-foss-release.apk' -o $output
  }

  install $output
}

export def AudioSource [] {
  let version = '1.2'
  let name = $'audiosource_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/gdzx/audiosource/releases/download/v($version)/audiosource.apk' -o $output
  }

  install $output
}

export def ScreenStream [] {
  let version = '4.1.12'
  let name = $'ScreenStream_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/dkrivoruchko/ScreenStream/releases/download/($version)/ScreenStream-PlayStore-41012.apk' -o $output
  }

  install $output
}

export def ToDark [] {
  let version = ghub version 'darkmoonight/ToDark'
  let name = $'ToDark_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/darkmoonight/ToDark/releases/download/v($version)/todark-arm64-v8a-release.apk' -o $output
  }

  install $output
}

export def IvyWallet [] {
  let version = ghub version 'Ivy-Apps/ivy-wallet'
  let name = $'IvyWallet_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/Ivy-Apps/ivy-wallet/releases/download/v($version)/Ivy-Wallet-v($version).apk' -o $output
  }

  install $output
}

export def NatriumWallet [] {
  let version = ghub version 'appditto/natrium_wallet_flutter'
  let name = $'NatriumWallet_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/appditto/natrium_wallet_flutter/releases/download/v($version)/natrium_v($version | str replace . '').apk' -o $output
  }

  install $output
}

export def DroidIfy [] {
  let version = ghub version 'Droid-ify/client'
  let name = $'DroidIfy_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/Droid-ify/client/releases/download/v($version)/app-release.apk' -o $output
  }

  install $output
}

export def OllamaApp [] {
  let version = '1.2.0'
  let name = $'OllamaApp_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/JHubi1/ollama-app/releases/download/($version)/ollama-android-v($version).apk' -o $output
  }

  install $output
}

export def qrserv [] {
  let version = '2.6.0'
  let name = $'qrserv_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download https://github.com/uintdev/qrserv/releases/download/v($version)/qrserv-v2_6_0-arm64-v8a.apk -o $output
  }

  install $output
}

export def sharik [] {
  let version = '3.1'
  let name = $'sharik_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/marchellodev/sharik/releases/download/v($version)/sharik_v($version)_android.apk' -o $output
  }

  install $output
}

export def localsend [] {
  let version = ghub version 'localsend/localsend'
  let name = $'localsend_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/localsend/localsend/releases/download/v($version)/LocalSend-($version)-android-arm64v8.apk' -o $output
  }

  install $output
}

export def NewPass [] {
  let version = '1.2.0'
  let name = $'NewPass_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/6eero/NewPass/releases/download/v($version)/NewPass-v($version).apk' -o $output
  }

  install $output
}

export def PlainApp [] {
  let version = '1.3.6'
  let name = $'PlainApp_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/ismartcoding/plain-app/releases/download/v($version)/PlainApp-($version).apk' -o $output
  }

  install $output
}

export def ServerBox [] {
  let version = '1.0.1104'
  let name = $'ServerBox_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/lollipopkit/flutter_server_box/releases/download/v($version)/ServerBox_v($version)_arm64.apk' -o $output
  }

  install $output
}

export def DataBackup [] {
  let version = '2.0.3'
  let name = $'DataBackup_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/XayahSuSuSu/Android-DataBackup/releases/download/($version)/DataBackup-($version)-arm64-v8a-foss-release.apk' -o $output
  }

  install $output
}

export def stratumauth [] {
  let version = ghub version 'stratumauth/app'
  let name = $'stratumauth_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/stratumauth/app/releases/download/v($version)/com.stratumauth.app.fdroid.apk' -o $output
  }

  install $output
}

export def HTTPShortcuts [] {
  let version = '3.18.0'
  let name = $'HTTPShortcuts_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/Waboodoo/HTTP-Shortcuts/releases/download/v($version)/app-arm64-v8a-release.apk' -o $output
  }

  install $output
}

export def Acode [] {
  let version = '1.10.5'
  let name = $'Acode_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/deadlyjack/Acode/releases/download/v($version)/app-release.apk' -o $output
  }

  install $output
}

export def AppFlowy [] {
  let version = ghub version 'AppFlowy-IO/AppFlowy'
  let filename = $'AppFlowy_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/AppFlowy-IO/AppFlowy/releases/download/($version)/AppFlowy-($version)-android-arm64-v8a.apk' -o $filepath
  }

  install $filepath
}

export def siyuan [ --force(-f) ] {
  let version = ghub version 'siyuan-note/siyuan'
  let filename = $'siyuan_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/siyuan-note/siyuan/releases/download/v($version)/siyuan-($version).apk' -o $filepath
  }

  install $filepath
}

export def LinkSheet [ --force(-f) ] {
  let version = ghub version 'LinkSheet/LinkSheet'
  let filename = $'LinkSheet_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/LinkSheet/LinkSheet/releases/download/($version)/LinkSheet-($version).apk' -o $filepath
  }

  install $filepath
}

export def Linkora [ --force(-f) ] {
  let version = ghub version 'sakethpathike/Linkora'
  let filename = $'Linkora_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/sakethpathike/Linkora/releases/download/release-v($version)/app-fdroid-release.apk' -o $filepath
  }

  install $filepath
}

export def immich [ --force(-f) ] {
  let version = ghub version 'immich-app/immich'
  let filename = $'immich_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download https://github.com/immich-app/immich/releases/download/v($version)/app-armeabi-v7a-release.apk -o $filepath
  }

  install $filepath
}

export def uhabits [ --force(-f) ] {
  let version = ghub version 'iSoron/uhabits'
  let filename = $'uhabits_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $"https://github.com/iSoron/uhabits/releases/download/v($version)/loop-($version)-release.apk" -o $filepath
  }

  install $filepath
}

export def Habo [ --force(-f) ] {
  let version = ghub version 'xpavle00/Habo'
  let filename = $'Habo_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download https://github.com/xpavle00/Habo/releases/download/v($version)/app-arm64-v8a-release.apk -o $filepath
  }

  install $filepath
}

export def mhabit [ --force(-f) ] {
  let version = ghub version 'FriesI23/mhabit'
  let filename = $'mhabit_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download https://github.com/FriesI23/mhabit/releases/download/v($version)/app-arm64-v8a-release.apk -o $filepath
  }

  install $filepath
}

export def HabitBuilder [ --force(-f) ] {
  let version = ghub version 'ofalvai/HabitBuilder'
  let filename = $'HabitBuilder_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download https://github.com/ofalvai/HabitBuilder/releases/download/($version)/app-release.apk -o $filepath
  }

  install $filepath
}

export def RoutineTracker [ --force(-f) ] {
  let version = ghub version 'DanielRendox/RoutineTracker'
  let filename = $'RoutineTracker_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $"https://github.com/DanielRendox/RoutineTracker/releases/download/v($version)/routinetracker-v($version).apk" -o $filepath
  }

  install $filepath
}

export def habits [ --force(-f) ] {
  let version = ghub version 'willbsp/habits'
  let filename = $'habits_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $"https://github.com/willbsp/habits/releases/download/v($version)/habits-github-($version).apk" -o $filepath
  }

  install $filepath
}

export def saber [ --force(-f) ] {
  let version = ghub version 'saber-notes/saber'
  let filename = $'saber_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/saber-notes/saber/releases/download/v($version)/Saber_v($version).apk' -o $filepath
  }

  install $filepath
}

export def PdfReaderPro [ --force(-f) ] {
  let version = ghub version 'ahmmedrejowan/PdfReaderPro'
  let filename = $'PdfReaderPro_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/ahmmedrejowan/PdfReaderPro/releases/download/($version)/PdfReaderPro.apk' -o $filepath
  }

  install $filepath
}

export def MaterialFiles [ --force(-f) ] {
  let version = ghub version 'zhanghai/MaterialFiles'
  let filename = $'MaterialFiles_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/zhanghai/MaterialFiles/releases/download/v($version)/app-release-universal.apk' -o $filepath
  }

  install $filepath
}

export def KeePassDX [ --force(-f) ] {
  let version = ghub version 'Kunzisoft/KeePassDX'
  let filename = $'KeePassDX_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/Kunzisoft/KeePassDX/releases/download/($version)/KeePassDX-($version)-libre.apk' -o $filepath
  }

  install $filepath
}

export def VirtualHosts [ --force(-f) ] {
  let version = ghub version 'x-falcon/Virtual-Hosts'
  let filename = $'VirtualHosts_($version).apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download $'https://github.com/x-falcon/Virtual-Hosts/releases/download/($version)/app-Github-release.apk' -o $filepath
  }

  install $filepath
}

export def RootlessJamesDSP [ --force(-f) ] {
  let filename = $'RootlessJamesDSP_f-droid.apk'
  let filepath = ($env.USR_LOCAL_APK | path join $filename)

  if not ($filepath | path exists) {
    https download https://f-droid.org/repo/me.timschneeberger.rootlessjamesdsp_50.apk -o $filepath
  }

  install $filepath

  adb shell pm grant me.timschneeberger.rootlessjamesdsp android.permission.DUMP
  adb shell appops set me.timschneeberger.rootlessjamesdsp PROJECT_MEDIA allow
  adb shell appops set me.timschneeberger.rootlessjamesdsp SYSTEM_ALERT_WINDOW allow
}

export def basic [] {
  DroidIfy
  NewPipe
  mhabit
  ToDark
  IvyWallet
  AudioSource
  NatriumWallet
  MaterialFiles
  PdfReaderPro
  KeePassDX
  InnerTune
  stratumauth
}
