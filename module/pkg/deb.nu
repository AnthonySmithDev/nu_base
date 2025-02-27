
export def install [path: string] {
  sudo dpkg -i $path
}

def download_deb [repository: string, version: string, url: string, force: bool] {
  let name = ($repository | path basename)
  let dirname = ($env.TMP_PATH_FILE | path join apk $name)
  mkdir $dirname

  let path = ($dirname | path join $'($name)_($version).apk')
  if $force or not ($path | path exists) {
    print $'Download: ($name) - ($version)'
    http download $url --output $path
  }
  return $path
}

export def vieb [ --force(-f) ] {
  let repository = 'Jelmerro/Vieb'
  let version = ghub version $repository
  let download_url = $'https://github.com/Jelmerro/Vieb/releases/download/($version)/vieb_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def brave [ --force(-f) ] {
  let repository = 'brave/brave-browser'
  let version = ghub version $repository
  let download_url = $'https://github.com/brave/brave-browser/releases/download/v($version)/brave-browser_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def vscode [ --force(-f) ] {
  let repository = 'microsoft/vscode'
  let version = ghub version $repository
  let download_url = $'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def vscodium [ --force(-f) ] {
  let repository = 'VSCodium/vscodium'
  let version = ghub version $repository
  let download_url = $'https://github.com/VSCodium/vscodium/releases/download/($version)/codium_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def chrome [ --force(-f) ] {
  let repository = 'chrome'
  let version = 'latest'
  let download_url = $'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def opera [ --force(-f) ] {
  let repository = 'opera'
  let version = '111.0.5168.43'
  let download_url = $'https://download5.operacdn.com/ftp/pub/opera/desktop/($version)/linux/opera-stable_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def mysql-workbench [ --force(-f) ] {
  let repository = 'mysql'
  let version = '8.0.38-1ubuntu24.04'
  let download_url = $'https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def microsoft-edge [ --force(-f) ] {
  let repository = 'microsoft-edge'
  let version = '126.0.2592.68-1'
  let download_url = $'https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_($version)_amd64.deb?brand=M102'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def steam [ --force(-f) ] {
  deps steam

  let repository = 'steam'
  let version = 'latest'
  let download_url = $'https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def via [ --force(-f) ] {
  let repository = 'via'
  let version = '3.0.0'
  let download_url = $'https://github.com/the-via/releases/releases/download/v($version)/via-($version)-linux.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def discord [ --force(-f) ] {
  let repository = 'discord'
  let version = 'latest'
  let download_url = $'https://discord.com/api/download?platform=linux&format=deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def input-remapper-file [ --force(-f) ] {
  let repository = 'sezanzeb/input-remapper'
  let version = ghub version $repository
  let download_url = $'https://github.com/sezanzeb/input-remapper/releases/download/($version)/input-remapper-($version).deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def balena-etcher [ --force(-f) ] {
  let repository = 'balena-io/etcher'
  let version = ghub version $repository
  let download_url = $'https://github.com/balena-io/etcher/releases/download/v($version)/balena-etcher_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def obsidian [ --force(-f) ] {
  let repository = 'obsidianmd/obsidian-releases'
  let version = ghub version $repository
  let download_url = $'https://github.com/obsidianmd/obsidian-releases/releases/download/v($version)/obsidian_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def localsend [ --force(-f) ] {
  deps localsend

  let repository = 'localsend/localsend'
  let version = ghub version $repository
  let download_url = $'https://github.com/localsend/localsend/releases/download/v($version)/LocalSend-($version)-linux-x86-64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def appflowy [ --force(-f) ] {
  let repository = 'AppFlowy-IO/AppFlowy'
  let version = ghub version $repository
  let download_url = $'https://github.com/AppFlowy-IO/AppFlowy/releases/download/($version)/AppFlowy-($version)-linux-x86_64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def siyuan [ --force(-f) ] {
  let repository = 'siyuan-note/siyuan'
  let version = ghub version $repository
  let download_url = $'https://github.com/siyuan-note/siyuan/releases/download/v($version)/siyuan-($version)-linux.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def sftpgo [ --force(-f) ] {
  let repository = 'drakkan/sftpgo'
  let version = ghub version $repository
  let download_url = $'https://github.com/drakkan/sftpgo/releases/download/v($version)/sftpgo_($version)-1_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def rio [ --force(-f) ] {
  deps rio

  let repository = 'raphamorim/rio'
  let version = ghub version $repository
  let download_url = $'https://github.com/raphamorim/rio/releases/download/v($version)/rioterm_($version)_amd64_wayland.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def qopy [ --force(-f) ] {
  let repository = '0PandaDEV/Qopy'
  let version = ghub version $repository
  let download_url = $'https://github.com/0PandaDEV/Qopy/releases/download/v($version)/Qopy-($version).deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def runjs [ --force(-f) ] {
  let repository = 'lukehaas/RunJS'
  let version = ghub version $repository
  let download_url = $'https://github.com/lukehaas/RunJS/releases/download/v($version)/runjs_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def warp [ --force(-f) ] {
  let repository = 'warp'
  let version = 'latest'
  let download_url = 'https://app.warp.dev/download?package=deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def hoppscotch [ --force(-f) ] {
  let repository = 'hoppscotch/releases'
  let version = ghub version $repository
  let download_url = $'https://github.com/hoppscotch/releases/releases/latest/download/Hoppscotch_linux_x64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def lapce [ --force(-f) ] {
  let repository = 'lapce/lapce'
  let version = ghub version $repository
  let download_url = $'https://github.com/lapce/lapce/releases/download/v($version)/lapce.ubuntu.mantic.amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def pacstall [ --force(-f) ] {
  let repository = 'pacstall/pacstall'
  let version = ghub version $repository
  let download_url = $'https://github.com/pacstall/pacstall/releases/download/($version)/pacstall_($version)-pacstall1_all.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def contour [ --force(-f) ] {
  let repository = 'contour-terminal/contour'
  let version = ghub version $repository
  let download_url = $'https://github.com/contour-terminal/contour/releases/download/v($version)/contour-($version)-ubuntu24.04-amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def weektodo [ --force(-f) ] {
  let repository = 'manuelernestog/weektodo'
  let version = ghub version $repository
  let download_url = $'https://github.com/manuelernestog/weektodo/releases/download/v($version)/WeekToDo_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def youtube-music [ --force(-f) ] {
  let repository = 'th-ch/youtube-music'
  let version = ghub version $repository
  let download_url = $'https://github.com/th-ch/youtube-music/releases/download/v($version)/youtube-music_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def ytmdesktop [ --force(-f) ] {
  let repository = 'ytmdesktop/ytmdesktop'
  let version = ghub version $repository
  let download_url = $'https://github.com/ytmdesktop/ytmdesktop/releases/download/v($version)/youtube-music-desktop-app_($version)_amd64.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}

export def ghostty-ubuntu [ --force(-f) ] {
  let repository = 'mkasberg/ghostty-ubuntu'
  let version = (ghub tag_name $repository | parse '{version}-ppa1' | first | get version)
  let download_url = $'https://github.com/mkasberg/ghostty-ubuntu/releases/download/($version)-ppa1/ghostty_($version).ppa1_amd64_24.10.deb'
  let download_path = download_deb $repository $version $download_url $force
  install $download_path
}
