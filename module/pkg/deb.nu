
export def install [path: string] {
  sudo dpkg -i $path
}

def filepath [name: string, version: string] {
  $env.USR_LOCAL_DEB | path join $'($name)_($version).deb'
}

def path-not-exists [path: string, force: bool] {
  not ($path | path exists) or $force
}

export def vieb [ --force(-f) ] {
  let version = ghub version 'Jelmerro/Vieb'
  let path = filepath vieb $version

  if (path-not-exists $path $force) {
    http download https://github.com/Jelmerro/Vieb/releases/download/($version)/vieb_($version)_amd64.deb -o $path
    install $path
  }
}

export def brave [ --force(-f) ] {
  let version = ghub version 'brave/brave-browser'
  let path = filepath brave $version

  if (path-not-exists $path $force) {
    http download https://github.com/brave/brave-browser/releases/download/v($version)/brave-browser_($version)_amd64.deb -o $path
    install $path
  }
}

export def chrome [ --force(-f) ] {
  let version = 'latest'
  let path = filepath chrome $version

  if (path-not-exists $path $force) {
    http download https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o $path
    install $path
  }
}

export def opera [ --force(-f) ] {
  let version = '111.0.5168.43'
  let path = filepath opera $version

  if (path-not-exists $path $force) {
    http download https://download5.operacdn.com/ftp/pub/opera/desktop/($version)/linux/opera-stable_($version)_amd64.deb -o $path
    install $path
  }
}

export def vscode [ --force(-f) ] {
  let version = ghub version 'microsoft/vscode'
  let path = filepath vscode $version

  if (path-not-exists $path $force) {
    http download https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -o $path
    install $path
  }
}

export def vscodium [ --force(-f) ] {
  let version = ghub version 'VSCodium/vscodium'
  let path = filepath vscodium $version

  if (path-not-exists $path $force) {
    http download https://github.com/VSCodium/vscodium/releases/download/($version)/codium_($version)_amd64.deb -o $path
    install $path
  }
}

export def mysql-workbench [ --force(-f) ] {
  let version = '8.0.38-1ubuntu24.04'
  let path = filepath mysql $version

  if (path-not-exists $path $force) {
    http download https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_($version)_amd64.deb -o $path
    install $path
  }
}

export def microsoft-edge [ --force(-f) ] {
  let version = '126.0.2592.68-1'
  let path = filepath microsoft $version

  if (path-not-exists $path $force) {
    http download https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_($version)_amd64.deb?brand=M102 -o $path
    install $path
  }
}

export def steam [ --force(-f) ] {
  deps steam

  let version = 'latest'
  let path = filepath steam $version

  if (path-not-exists $path $force) {
    http download https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -o $path
    install $path
  }
}

export def via [ --force(-f) ] {
  let version = '3.0.0'
  let path = filepath via $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/the-via/releases/releases/download/v($version)/via-($version)-linux.deb' -o $path
    install $path
  }
}

export def discord [ --force(-f) ] {
  let version = 'latest'
  let path = filepath discord $version

  if (path-not-exists $path $force) {
    http download https://discord.com/api/download?platform=linux&format=deb -o $path
    install $path
  }
}

export def input-remapper-file [ --force(-f) ] {
  let version = ghub version 'sezanzeb/input-remapper'
  let path = filepath input $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/sezanzeb/input-remapper/releases/download/($version)/input-remapper-($version).deb' -o $path
    install $path
    input-remapper-control --command autoload
  }
}

export def balena-etcher [ --force(-f) ] {
  let version = ghub version 'balena-io/etcher'
  let path = filepath balena $version

  if (path-not-exists $path $force) {
    http download https://github.com/balena-io/etcher/releases/download/v($version)/balena-etcher_($version)_amd64.deb -o $path
    install $path
  }
}

export def obsidian [ --force(-f) ] {
  let version = ghub version 'obsidianmd/obsidian-releases'
  let path = filepath obsidian $version

  if (path-not-exists $path $force) {
    http download https://github.com/obsidianmd/obsidian-releases/releases/download/v($version)/obsidian_($version)_amd64.deb -o $path
    install $path
  }
}

export def localsend [ --force(-f) ] {
  deps localsend

  let version = ghub version 'localsend/localsend'
  let path = filepath localsend $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/localsend/localsend/releases/download/v($version)/LocalSend-($version)-linux-x86-64.deb' -o $path
    install $path
  }
}

export def appflowy [ --force(-f) ] {
  let version = ghub version 'AppFlowy-IO/AppFlowy'
  let path = filepath appflowy $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/AppFlowy-IO/AppFlowy/releases/download/($version)/AppFlowy-($version)-linux-x86_64.deb' -o $path
    install $path
  }
}

export def siyuan [ --force(-f) ] {
  let version = ghub version 'siyuan-note/siyuan'
  let path = filepath siyuan $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/siyuan-note/siyuan/releases/download/v($version)/siyuan-($version)-linux.deb' -o $path
    install $path
  }
}

export def sftpgo [ --force(-f) ] {
  let version = ghub version 'drakkan/sftpgo'
  let path = filepath sftpgo $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/drakkan/sftpgo/releases/download/v($version)/sftpgo_($version)-1_amd64.deb' -o $path
    install $path
  }
}

export def rio [ --force(-f) ] {
  deps rio

  let version = ghub version 'raphamorim/rio'
  let path = filepath rio $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/raphamorim/rio/releases/download/v($version)/rioterm_($version)-1_amd64_wayland.deb' -o $path
    install $path
  }
}

export def qopy [ --force(-f) ] {
  let version = ghub version '0PandaDEV/Qopy'
  let path = filepath qopy $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/0PandaDEV/Qopy/releases/download/v($version)/Qopy-($version).deb' -o $path
    install $path
  }
}

export def runjs [ --force(-f) ] {
  let version = ghub version 'lukehaas/RunJS'
  let path = filepath runjs $version

  if (path-not-exists $path $force) {
    http download https://github.com/lukehaas/RunJS/releases/download/v($version)/runjs_($version)_amd64.deb -o $path
    install $path
  }
}

export def warp [ --force(-f) ] {
  let version = 'latest'
  let path = filepath warp $version

  if (path-not-exists $path $force) {
    http download https://app.warp.dev/download?package=deb -o $path
    install $path
  }
}

export def hoppscotch [ --force(-f) ] {
  let version = ghub version 'hoppscotch/releases'
  let path = filepath hoppscotch $version

  if (path-not-exists $path $force) {
    http download https://github.com/hoppscotch/releases/releases/latest/download/Hoppscotch_linux_x64.deb -o $path
    install $path
  }
}

export def lapce [ --force(-f) ] {
  let version = ghub version 'lapce/lapce'
  let path = filepath lapce $version

  if (path-not-exists $path $force) {
    http download https://github.com/lapce/lapce/releases/download/v($version)/lapce.ubuntu.mantic.amd64.deb -o $path
    install $path
  }
}

export def pacstall [ --force(-f) ] {
  let version = ghub version 'pacstall/pacstall'
  let path = filepath pacstall $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/pacstall/pacstall/releases/download/($version)/pacstall_($version)-pacstall1_all.deb' -o $path
    install $path
  }
}

export def contour [ --force(-f) ] {
  let version = ghub version 'contour-terminal/contour'
  let path = filepath contour $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/contour-terminal/contour/releases/download/v($version)/contour-($version)-ubuntu24.04-amd64.deb' -o $path
    install $path
  }
}

export def weektodo [ --force(-f) ] {
  let version = ghub version 'manuelernestog/weektodo'
  let path = filepath weektodo $version

  if (path-not-exists $path $force) {
    http download https://github.com/manuelernestog/weektodo/releases/download/v($version)/WeekToDo_($version)_amd64.deb -o $path
    install $path
  }
}

export def youtube-music [ --force(-f) ] {
  let version = ghub version 'th-ch/youtube-music'
  let path = filepath youtube-music $version

  if (path-not-exists $path $force) {
    http download https://github.com/th-ch/youtube-music/releases/download/v($version)/youtube-music_($version)_amd64.deb -o $path
    install $path
  }
}

export def ytmdesktop [ --force(-f) ] {
  let version = ghub version 'ytmdesktop/ytmdesktop'
  let path = filepath ytmdesktop $version

  if (path-not-exists $path $force) {
    http download https://github.com/ytmdesktop/ytmdesktop/releases/download/v($version)/youtube-music-desktop-app_($version)_amd64.deb -o $path
    install $path
  }
}

export def ghostty-ubuntu [ --force(-f) ] {
  let tag_name = ghub tag_name 'mkasberg/ghostty-ubuntu'
  let version = ($tag_name | parse "{version}-ppa1" | first | get version)
  let path = filepath ghostty-ubuntu $version

  if (path-not-exists $path $force) {
    http download $'https://github.com/mkasberg/ghostty-ubuntu/releases/download/($version)-ppa1/ghostty_($version).ppa1_amd64_24.10.deb' -o $path
    install $path
  }
}
