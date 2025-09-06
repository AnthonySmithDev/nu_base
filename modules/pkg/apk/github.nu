
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

export def NewPipe [ --force(-f) ] {
  let repository = "TeamNewPipe/NewPipe"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def LibreTube [ --force(-f) ] {
  let repository = "libre-tube/LibreTube"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def InnerTune [ --force(-f) ] {
  let repository = "z-huang/InnerTune"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def OpenTune [ --force(-f) ] {
  let repository = "Arturo254/OpenTune"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def OuterTune [ --force(-f) ] {
  let repository = "OuterTune/OuterTune"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def Metrolist [ --force(-f) ] {
  let repository = "mostafaalagamy/Metrolist"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def SimpMusic [ --force(-f) ] {
  let repository = "maxrave-dev/SimpMusic"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def RiMusic [ --force(-f) ] {
  let repository = "fast4x/RiMusic"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def ToDark [ --force(-f) ] {
  let repository = "darkmoonight/ToDark"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def IvyWallet [ --force(-f) ] {
  let repository = "Ivy-Apps/ivy-wallet"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def NatriumWallet [ --force(-f) ] {
  let repository = "appditto/natrium_wallet_flutter"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def DroidIfy [ --force(-f) ] {
  let repository = "Droid-ify/client"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def localsend [ --force(-f) ] {
  let repository = "localsend/localsend"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def stratumauth [ --force(-f) ] {
  let repository = "stratumauth/app"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def AppFlowy [ --force(-f) ] {
  let repository = "AppFlowy-IO/AppFlowy"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def siyuan [ --force(-f) ] {
  let repository = "siyuan-note/siyuan"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def LinkSheet [ --force(-f) ] {
  let repository = "LinkSheet/LinkSheet"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def Linkora [ --force(-f) ] {
  let repository = "sakethpathike/Linkora"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def immich [ --force(-f) ] {
  let repository = "immich-app/immich"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def uhabits [ --force(-f) ] {
  let repository = "iSoron/uhabits"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def Habo [ --force(-f) ] {
  let repository = "xpavle00/Habo"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def mhabit [ --force(-f) ] {
  let repository = "FriesI23/mhabit"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def HabitBuilder [ --force(-f) ] {
  let repository = "ofalvai/HabitBuilder"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def RoutineTracker [ --force(-f) ] {
  let repository = "DanielRendox/RoutineTracker"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def habits [ --force(-f) ] {
  let repository = "willbsp/habits"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def saber [ --force(-f) ] {
  let repository = "saber-notes/saber"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def EasyNotes [ --force(-f) ] {
  let repository = "Kin69/EasyNotes"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def MaterialNotes [ --force(-f) ] {
  let repository = "maelchiotti/LocalMaterialNotes"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def NotallyX [ --force(-f) ] {
  let repository = "PhilKes/NotallyX"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def AdAway [ --force(-f) ] {
  let repository = "AdAway/AdAway"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def DNSNet [ --force(-f) ] {
  let repository = "t895/DNSNet"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def PdfReaderPro [ --force(-f) ] {
  let repository = "ahmmedrejowan/PdfReaderPro"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def VolumeBoost [ --force(-f) ] {
  let repository = "ElishaAz/AndroidVolumeBoost"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def MaterialFiles [ --force(-f) ] {
  let repository = "zhanghai/MaterialFiles"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def KeePassDX [ --force(-f) ] {
  let repository = "Kunzisoft/KeePassDX"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def voicenotify [ --force(-f) ] {
  let repository = "pilot51/voicenotify"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def VirtualHosts [ --force(-f) ] {
  let repository = "x-falcon/Virtual-Hosts"
  let version = ghub version $repository
  let download_url = ghub asset apk download_url $repository
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def AudioSource [ --force(-f) ] {
  let repository = "AudioSource"
  let version = "1.2"
  let download_url = $"https://github.com/gdzx/audiosource/releases/download/v($version)/audiosource.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def ScreenStream [ --force(-f) ] {
  let repository = "ScreenStream"
  let version = "4.1.12"
  let download_url = $"https://github.com/dkrivoruchko/ScreenStream/releases/download/($version)/ScreenStream-PlayStore-41012.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def OllamaApp [ --force(-f) ] {
  let repository = "OllamaApp"
  let version = "1.2.0"
  let download_url = $"https://github.com/JHubi1/ollama-app/releases/download/($version)/ollama-android-v($version).apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def qrserv [ --force(-f) ] {
  let repository = "qrserv"
  let version = "2.6.0"
  let download_url = $"https://github.com/uintdev/qrserv/releases/download/v($version)/qrserv-v2_6_0-arm64-v8a.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def sharik [ --force(-f) ] {
  let repository = "sharik"
  let version = "3.1"
  let download_url = $"https://github.com/marchellodev/sharik/releases/download/v($version)/sharik_v($version)_android.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def NewPass [ --force(-f) ] {
  let repository = "NewPass"
  let version = "1.2.0"
  let download_url = $"https://github.com/6eero/NewPass/releases/download/v($version)/NewPass-v($version).apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def PlainApp [ --force(-f) ] {
  let repository = "PlainApp"
  let version = "1.3.6"
  let download_url = $"https://github.com/ismartcoding/plain-app/releases/download/v($version)/PlainApp-($version).apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def ServerBox [ --force(-f) ] {
  let repository = "ServerBox"
  let version = "1.0.1104"
  let download_url = $"https://github.com/lollipopkit/flutter_server_box/releases/download/v($version)/ServerBox_v($version)_arm64.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def DataBackup [ --force(-f) ] {
  let repository = "DataBackup"
  let version = "2.0.3"
  let download_url = $"https://github.com/XayahSuSuSu/Android-DataBackup/releases/download/($version)/DataBackup-($version)-arm64-v8a-foss-release.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def HTTPShortcuts [ --force(-f) ] {
  let repository = "HTTPShortcuts"
  let version = "3.18.0"
  let download_url = $"https://github.com/Waboodoo/HTTP-Shortcuts/releases/download/v($version)/app-arm64-v8a-release.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def Acode [ --force(-f) ] {
  let repository = "Acode"
  let version = "1.10.5"
  let download_url = $"https://github.com/deadlyjack/Acode/releases/download/v($version)/app-release.apk"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def blokada5 [ --force(-f) ] {
  let repository = "blokada5"
  let version = "latest"
  let download_url = "https://go.blokada.org/apk5"
  let download_path = download_apk $repository $version $download_url $force
  install $download_path
}

export def AndroidMic [ --force(-f) ] {
  let repository = "AndroidMic"
  let version = "2.1.4"
  let download_url = $"https://github.com/teamclouday/AndroidMic/releases/download/($version)/app-release.apk"
    let download_path = download_apk $repository $version $download_url $force
  install $download_path
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
