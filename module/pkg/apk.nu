
export def install [apk: path] {
  adb wait-for-device
  adb install -r -g $apk
}

def filepath [name: string, version: string] {
  $env.USR_LOCAL_APK | path join $'($name)_($version).apk'
}

def path-not-exists [path: string] {
  not ($path | path exists)
}

export def NewPipe [] {
  let version = '0.27.2'
  let path = filepath NewPipe $version

  if (path-not-exists $path) {
    https download $'https://github.com/TeamNewPipe/NewPipe/releases/download/v($version)/NewPipe_v($version).apk' -o $path
  }

  install $path
}

export def LibreTube [] {
  let version = '0.25.2'
  let path = filepath LibreTube $version

  if (path-not-exists $path) {
    https download $'https://github.com/libre-tube/LibreTube/releases/download/v($version)/app-universal-release.apk' -o $path
  }

  install $path
}

export def InnerTune [] {
  let version = ghub version 'z-huang/InnerTune'
  let path = filepath InnerTune $version

  if (path-not-exists $path) {
    https download $'https://github.com/z-huang/InnerTune/releases/download/v($version)/InnerTune_v($version)_foss.apk' -o $path
  }

  install $path
}

export def OpenTune [] {
  let version = ghub version 'Arturo254/OpenTune'
  let path = filepath OpenTune $version

  if (path-not-exists $path) {
    https download https://github.com/Arturo254/OpenTune/releases/download/($version)/app-foss-release.apk -o $path
  }

  install $path
}

export def OuterTune [] {
  let version = ghub version 'DD3Boh/OuterTune'
  let path = filepath OuterTune $version

  if (path-not-exists $path) {
    https download $'https://github.com/DD3Boh/OuterTune/releases/download/v($version)/OuterTune-($version)-arm64-release.apk' -o $path
  }

  install $path
}

export def Metrolist [] {
  let version = ghub version 'mostafaalagamy/Metrolist'
  let path = filepath Metrolist $version

  if (path-not-exists $path) {
    https download https://github.com/mostafaalagamy/Metrolist/releases/download/v($version)/Metrolist.apk -o $path
  }

  install $path
}

export def SimpMusic [] {
  let version = ghub version 'maxrave-dev/SimpMusic'
  let path = filepath SimpMusic $version

  if (path-not-exists $path) {
    https download $'https://github.com/maxrave-dev/SimpMusic/releases/download/v($version)/SimpMusic_v($version)-fdroid.apk' -o $path
  }

  install $path
}

export def RiMusic [] {
  let version = ghub version 'fast4x/RiMusic'
  let path = filepath RiMusic $version

  if (path-not-exists $path) {
    https download $'https://github.com/fast4x/RiMusic/releases/download/v($version)/app-foss-release.apk' -o $path
  }

  install $path
}

export def AudioSource [] {
  let version = '1.2'
  let path = filepath AudioSource $version

  if (path-not-exists $path) {
    https download $'https://github.com/gdzx/audiosource/releases/download/v($version)/audiosource.apk' -o $path
  }

  install $path
}

export def ScreenStream [] {
  let version = '4.1.12'
  let path = filepath ScreenStream $version

  if (path-not-exists $path) {
    https download $'https://github.com/dkrivoruchko/ScreenStream/releases/download/($version)/ScreenStream-PlayStore-41012.apk' -o $path
  }

  install $path
}

export def ToDark [] {
  let version = ghub version 'darkmoonight/ToDark'
  let path = filepath ToDark $version

  if (path-not-exists $path) {
    https download $'https://github.com/darkmoonight/ToDark/releases/download/v($version)/todark-arm64-v8a-release.apk' -o $path
  }

  install $path
}

export def IvyWallet [] {
  let version = ghub version 'Ivy-Apps/ivy-wallet'
  let path = filepath IvyWallet $version

  if (path-not-exists $path) {
    https download $'https://github.com/Ivy-Apps/ivy-wallet/releases/download/v($version)/Ivy-Wallet-v($version).apk' -o $path
  }

  install $path
}

export def NatriumWallet [] {
  let version = ghub version 'appditto/natrium_wallet_flutter'
  let path = filepath NatriumWallet $version

  if (path-not-exists $path) {
    https download $'https://github.com/appditto/natrium_wallet_flutter/releases/download/v($version)/natrium_v($version | str replace . '').apk' -o $path
  }

  install $path
}

export def DroidIfy [] {
  let version = ghub version 'Droid-ify/client'
  let path = filepath DroidIfy $version

  if (path-not-exists $path) {
    https download $'https://github.com/Droid-ify/client/releases/download/v($version)/app-release.apk' -o $path
  }

  install $path
}

export def OllamaApp [] {
  let version = '1.2.0'
  let path = filepath OllamaApp $version

  if (path-not-exists $path) {
    https download $'https://github.com/JHubi1/ollama-app/releases/download/($version)/ollama-android-v($version).apk' -o $path
  }

  install $path
}

export def qrserv [] {
  let version = '2.6.0'
  let path = filepath qrserv $version

  if (path-not-exists $path) {
    https download https://github.com/uintdev/qrserv/releases/download/v($version)/qrserv-v2_6_0-arm64-v8a.apk -o $path
  }

  install $path
}

export def sharik [] {
  let version = '3.1'
  let path = filepath sharik $version

  if (path-not-exists $path) {
    https download $'https://github.com/marchellodev/sharik/releases/download/v($version)/sharik_v($version)_android.apk' -o $path
  }

  install $path
}

export def localsend [] {
  let version = ghub version 'localsend/localsend'
  let path = filepath localsend $version

  if (path-not-exists $path) {
    https download $'https://github.com/localsend/localsend/releases/download/v($version)/LocalSend-($version)-android-arm64v8.apk' -o $path
  }

  install $path
}

export def NewPass [] {
  let version = '1.2.0'
  let path = filepath NewPass $version

  if (path-not-exists $path) {
    https download $'https://github.com/6eero/NewPass/releases/download/v($version)/NewPass-v($version).apk' -o $path
  }

  install $path
}

export def PlainApp [] {
  let version = '1.3.6'
  let path = filepath PlainApp $version

  if (path-not-exists $path) {
    https download $'https://github.com/ismartcoding/plain-app/releases/download/v($version)/PlainApp-($version).apk' -o $path
  }

  install $path
}

export def ServerBox [] {
  let version = '1.0.1104'
  let path = filepath ServerBox $version

  if (path-not-exists $path) {
    https download $'https://github.com/lollipopkit/flutter_server_box/releases/download/v($version)/ServerBox_v($version)_arm64.apk' -o $path
  }

  install $path
}

export def DataBackup [] {
  let version = '2.0.3'
  let path = filepath DataBackup $version

  if (path-not-exists $path) {
    https download $'https://github.com/XayahSuSuSu/Android-DataBackup/releases/download/($version)/DataBackup-($version)-arm64-v8a-foss-release.apk' -o $path
  }

  install $path
}

export def stratumauth [] {
  let version = ghub version 'stratumauth/app'
  let path = filepath stratumauth $version

  if (path-not-exists $path) {
    https download $'https://github.com/stratumauth/app/releases/download/v($version)/com.stratumauth.app.fdroid.apk' -o $path
  }

  install $path
}

export def HTTPShortcuts [] {
  let version = '3.18.0'
  let path = filepath HTTPShortcuts $version

  if (path-not-exists $path) {
    https download $'https://github.com/Waboodoo/HTTP-Shortcuts/releases/download/v($version)/app-arm64-v8a-release.apk' -o $path
  }

  install $path
}

export def Acode [] {
  let version = '1.10.5'
  let path = filepath Acode $version

  if (path-not-exists $path) {
    https download $'https://github.com/deadlyjack/Acode/releases/download/v($version)/app-release.apk' -o $path
  }

  install $path
}

export def AppFlowy [] {
  let version = ghub version 'AppFlowy-IO/AppFlowy'
  let path = filepath AppFlowy $version

  if (path-not-exists $path) {
    https download $'https://github.com/AppFlowy-IO/AppFlowy/releases/download/($version)/AppFlowy-($version)-android-arm64-v8a.apk' -o $path
  }

  install $path
}

export def siyuan [ --force(-f) ] {
  let version = ghub version 'siyuan-note/siyuan'
  let path = filepath siyuan $version

  if (path-not-exists $path) {
    https download $'https://github.com/siyuan-note/siyuan/releases/download/v($version)/siyuan-($version).apk' -o $path
  }

  install $path
}

export def LinkSheet [ --force(-f) ] {
  let version = ghub version 'LinkSheet/LinkSheet'
  let path = filepath LinkSheet $version

  if (path-not-exists $path) {
    https download $'https://github.com/LinkSheet/LinkSheet/releases/download/($version)/LinkSheet-($version).apk' -o $path
  }

  install $path
}

export def Linkora [ --force(-f) ] {
  let version = ghub version 'sakethpathike/Linkora'
  let path = filepath Linkora $version

  if (path-not-exists $path) {
    https download $'https://github.com/sakethpathike/Linkora/releases/download/release-v($version)/app-fdroid-release.apk' -o $path
  }

  install $path
}

export def immich [ --force(-f) ] {
  let version = ghub version 'immich-app/immich'
  let path = filepath immich $version

  if (path-not-exists $path) {
    https download https://github.com/immich-app/immich/releases/download/v($version)/app-armeabi-v7a-release.apk -o $path
  }

  install $path
}

export def uhabits [ --force(-f) ] {
  let version = ghub version 'iSoron/uhabits'
  let path = filepath uhabits $version

  if (path-not-exists $path) {
    https download $'https://github.com/iSoron/uhabits/releases/download/v($version)/loop-($version)-release.apk' -o $path
  }

  install $path
}

export def Habo [ --force(-f) ] {
  let version = ghub version 'xpavle00/Habo'
  let path = filepath Habo $version

  if (path-not-exists $path) {
    https download https://github.com/xpavle00/Habo/releases/download/v($version)/app-arm64-v8a-release.apk -o $path
  }

  install $path
}

export def mhabit [ --force(-f) ] {
  let version = ghub version 'FriesI23/mhabit'
  let path = filepath mhabit $version

  if (path-not-exists $path) {
    https download https://github.com/FriesI23/mhabit/releases/download/v($version)/app-arm64-v8a-release.apk -o $path
  }

  install $path
}

export def HabitBuilder [ --force(-f) ] {
  let version = ghub version 'ofalvai/HabitBuilder'
  let path = filepath HabitBuilder $version

  if (path-not-exists $path) {
    https download https://github.com/ofalvai/HabitBuilder/releases/download/($version)/app-release.apk -o $path
  }

  install $path
}

export def RoutineTracker [ --force(-f) ] {
  let version = ghub version 'DanielRendox/RoutineTracker'
  let path = filepath RoutineTracker $version

  if (path-not-exists $path) {
    https download $'https://github.com/DanielRendox/RoutineTracker/releases/download/v($version)/routinetracker-v($version).apk' -o $path
  }

  install $path
}

export def habits [ --force(-f) ] {
  let version = ghub version 'willbsp/habits'
  let path = filepath habits $version

  if (path-not-exists $path) {
    https download $'https://github.com/willbsp/habits/releases/download/v($version)/habits-github-($version).apk' -o $path
  }

  install $path
}

export def saber [ --force(-f) ] {
  let version = ghub version 'saber-notes/saber'
  let path = filepath saber $version

  if (path-not-exists $path) {
    https download $'https://github.com/saber-notes/saber/releases/download/v($version)/Saber_v($version).apk' -o $path
  }

  install $path
}

export def PdfReaderPro [ --force(-f) ] {
  let version = ghub version 'ahmmedrejowan/PdfReaderPro'
  let path = filepath PdfReaderPro $version

  if (path-not-exists $path) {
    https download $'https://github.com/ahmmedrejowan/PdfReaderPro/releases/download/($version)/PdfReaderPro.apk' -o $path
  }

  install $path
}

export def MaterialFiles [ --force(-f) ] {
  let version = ghub version 'zhanghai/MaterialFiles'
  let path = filepath MaterialFiles $version

  if (path-not-exists $path) {
    https download $'https://github.com/zhanghai/MaterialFiles/releases/download/v($version)/app-release-universal.apk' -o $path
  }

  install $path
}

export def KeePassDX [ --force(-f) ] {
  let version = ghub version 'Kunzisoft/KeePassDX'
  let path = filepath KeePassDX $version

  if (path-not-exists $path) {
    https download $'https://github.com/Kunzisoft/KeePassDX/releases/download/($version)/KeePassDX-($version)-libre.apk' -o $path
  }

  install $path
}

export def VirtualHosts [ --force(-f) ] {
  let version = ghub version 'x-falcon/Virtual-Hosts'
  let path = filepath VirtualHosts $version

  if (path-not-exists $path) {
    https download $'https://github.com/x-falcon/Virtual-Hosts/releases/download/($version)/app-Github-release.apk' -o $path
  }

  install $path
}

export def RootlessJamesDSP [ --force(-f) ] {
  let version = '50'
  let path = filepath RootlessJamesDSP $version

  if (path-not-exists $path) {
    https download $'https://f-droid.org/repo/me.timschneeberger.rootlessjamesdsp_($version).apk' -o $path
  }

  install $path

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
