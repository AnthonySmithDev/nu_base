
def download [repository: string, version: string, url: string, force: bool] {
  let name = ($repository | path basename)
  let dirname = ($env.PKG_TEMP_PATH | path join appimage $name)
  mkdir $dirname

  let path = ($dirname | path join $"($name)_($version).apk")
  if $force or not ($path | path exists) {
    print $"Download: ($name) - ($version)"
    http download $url --output $path
  }
  return $path
}

def appimage-path [name: string, version: string] {
  let dir = ($env.USR_LOCAL_SHARE_APP_IMAGE | path join $name)
  mkdir $dir
  return ($dir | path join $"($name)_($version)")
}

def install [cmd: string, src: string] {
  let dst = ($env.USR_LOCAL_BIN | path join $cmd)
  rm -rf $dst
  ln -sf $src $dst
}

def path-not-exists [path: string, force: bool] {
  (not ($path | path exists) or $force)
}


export def cursor [ --force(-f) ] {
  let name = "cursor"
  let version = "1.0.0"
  let hash = "53b99ce608cba35127ae3a050c1738a959750865"
  let download_url = $"https://downloads.cursor.com/production/($hash)/linux/x64/Cursor-($version)-x86_64.AppImage"
  let path = appimage-path $name $version

  if (path-not-exists $path $force) {
    let download_path = download $name $version $download_url $force
    chmod +x $download_path
    mv $download_path $path
  }

  install $name $path
}

export def android-mic [ --force(-f) ] {
  let name = "android-mic"
  let version = "2.1.4"
  let download_url = $"https://github.com/teamclouday/AndroidMic/releases/download/($version)/android-mic_($version)_x86_64.AppImage"
  let path = appimage-path $name $version

  if (path-not-exists $path $force) {
    let download_path = download $name $version $download_url $force
    chmod +x $download_path
    mv $download_path $path
  }

  install $name $path
}

export def session [ --force(-f) ] {
  let name = "session"
  let version = "latest"
  let download_url = $"https://getsession.org/linux"
  let path = appimage-path $name $version

  if (path-not-exists $path $force) {
    let download_path = download $name $version $download_url $force
    chmod +x $download_path
    mv $download_path $path
  }

  install $name $path
}

export def aider-desk [ --force(-f) ] {
  let name = "aider-desk"
  let repository = "hotovo/aider-desk"
  let tag_name = ghub tag_name $repository
  let path = appimage-path $name $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    chmod +x $download_path
    mv $download_path $path
  }

  install $name $path
}
