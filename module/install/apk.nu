
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
  let version = '0.5.10'
  let name = $'InnerTune_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/z-huang/InnerTune/releases/download/v($version)/InnerTune_v($version)_foss.apk' -o $output
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
  let version = '1.5.4'
  let name = $'ToDark_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/darkmoonight/ToDark/releases/download/v($version)/todark-arm64-v8a-release.apk' -o $output
  }

  install $output
}

export def IvyWallet [] {
  let version = '2024.10.20-204'
  let name = $'IvyWallet_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/Ivy-Apps/ivy-wallet/releases/download/v($version)/Ivy-Wallet-v($version).apk' -o $output
  }

  install $output
}

export def NatriumWallet [] {
  let version = '2.5.2'
  let name = $'NatriumWallet_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/appditto/natrium_wallet_flutter/releases/download/v($version)/natrium_v252.apk' -o $output
  }

  install $output
}

export def DroidIfy [] {
  let version = '0.6.3'
  let name = $'DroidIfy_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/Droid-ify/client/releases/download/v($version)/app-release.apk' -o $output
  }

  install $output
}

export def RiMusic [] {
  let version = '0.6.57.1'
  let name = $'RiMusic_($version).apk'
  let output = ($env.USR_LOCAL_APK | path join $name)

  if not ($output | path exists) {
    https download $'https://github.com/fast4x/RiMusic/releases/download/v($version)/app-foss-release.apk' -o $output
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
  let version = '1.0.2'
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

export def core [] {
  NewPipe
  LibreTube
  InnerTune
  AudioSource
  ScreenStream
  ToDark
  IvyWallet
  NatriumWallet
  DroidIfy
  RiMusic
  qrserv
  sharik
  localsend
}
