
def download [repository: string, version: string, url: string, force: bool] {
  let name = ($repository | path basename)
  let dirname = ($env.TMP_PATH_FILE | path join appimage $name)
  mkdir $dirname

  let path = ($dirname | path join $'($name)_($version).apk')
  if $force or not ($path | path exists) {
    print $'Download: ($name) - ($version)'
    http download $url --output $path
  }
  return $path
}

def filepath [name: string, version: string] {
  $env.USR_LOCAL_SHARE_APP_IMAGE | path join $"($name)_($version)"
}

def install [cmd: string, src: string] {
  let dst = ($env.USR_LOCAL_BIN | path join $cmd)
  rm -rf $dst
  ln -sf $src $dst
}

export def cursor [ --force(-f) ] {
  let name = "cursor"
  let version = "47.9"
  let download_url = "https://downloads.cursor.com/production/b6fb41b5f36bda05cab7109606e7404a65d1ff32/linux/x64/Cursor-0.47.9-x86_64.AppImage"
  let filepath = filepath $name $version

  let download_path = download $name $version $download_url $force
  chmod +x $download_path
  mv $download_path $filepath

  install $name $filepath
}

export def AndroidMic [ --force(-f) ] {
  let name = 'AndroidMic'
  let version = '2.1.4'
  let download_url = $'https://github.com/teamclouday/AndroidMic/releases/download/($version)/android-mic_($version)_x86_64.AppImage'
  let filepath = filepath $name $version

  let download_path = download $name $version $download_url $force
  chmod +x $download_path
  mv $download_path $filepath

  install $name $filepath
}
