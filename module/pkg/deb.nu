
def filepath [name: string] {
  $env.USR_LOCAL_SHARE_DOWNLOAD | path join $name
}

export def download [url: string, filename: string] {
  wget --quiet --show-progress $url --output-document $filename
}

export def vieb [ --force(-f) ] {
  let version = ghub version 'Jelmerro/Vieb'
  let filename = $"vieb_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/Jelmerro/Vieb/releases/download/($version)/vieb_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def brave [ --force(-f) ] {
  let version = ghub version 'brave/brave-browser'
  let filename = $"brave_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/brave/brave-browser/releases/download/v($version)/brave-browser_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def chrome [ --force(-f) ] {
  let version = "latest"
  let filename = $"google-chrome_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def opera [ --force(-f) ] {
  let version = "111.0.5168.43"
  let filename = $"opera_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://download5.operacdn.com/ftp/pub/opera/desktop/($version)/linux/opera-stable_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def vscodium [ --force(-f) ] {
  let version = ghub version 'VSCodium/vscodium'
  let filename = $"codium_($version)_amd64.deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/VSCodium/vscodium/releases/download/($version)/codium_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def mysql-workbench [ --force(-f) ] {
  let version = "8.0.38-1ubuntu24.04"
  let filename = $"mysql-workbench-community_($version)_amd64.deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def microsoft-edge [ --force(-f) ] {
  let version = "126.0.2592.68-1"
  let filename = $"microsoft-edge_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_($version)_amd64.deb?brand=M102 $filepath
    sudo dpkg -i $filepath
  }
}

export def steam [ --force(-f) ] {
  deps steam

  let version = "latest"
  let filename = $"steam_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def via [ --force(-f) ] {
  let version = "3.0.0"
  let filename = $"via_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $"https://github.com/the-via/releases/releases/download/v($version)/via-($version)-linux.deb" $filepath
    sudo dpkg -i $filepath
  }
}

export def discord [ --force(-f) ] {
  let version = "latest"
  let filename = $"discord_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://discord.com/api/download?platform=linux&format=deb $filepath
    sudo dpkg -i $filepath
  }
}

export def input-remapper-file [ --force(-f) ] {
  let version = ghub version 'sezanzeb/input-remapper'
  let filename = $"input-remapper_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/sezanzeb/input-remapper/releases/download/($version)/input-remapper-($version).deb $filepath
    sudo dpkg -i $filepath
    input-remapper-control --command autoload
  }
}

export def balena-etcher [ --force(-f) ] {
  let version = ghub version 'balena-io/etcher'
  let filename = $"balena-etcher_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/balena-io/etcher/releases/download/v($version)/balena-etcher_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def obsidian [ --force(-f) ] {
  let version = ghub version 'obsidianmd/obsidian-releases'
  let filename = $"obsidian_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/obsidianmd/obsidian-releases/releases/download/v($version)/obsidian_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def localsend [ --force(-f) ] {
  deps localsend

  let version = ghub version 'localsend/localsend'
  let filename = $"localsend_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/localsend/localsend/releases/download/v($version)/LocalSend-($version)-linux-x86-64.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def appflowy [ --force(-f) ] {
  let version = ghub version 'AppFlowy-IO/AppFlowy'
  let filename = $"appflowy_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/AppFlowy-IO/AppFlowy/releases/download/($version)/AppFlowy-($version)-linux-x86_64.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def siyuan [ --force(-f) ] {
  let version = ghub version 'siyuan-note/siyuan'
  let filename = $"siyuan_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/siyuan-note/siyuan/releases/download/v($version)/siyuan-($version)-linux.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def sftpgo [ --force(-f) ] {
  let version = ghub version 'drakkan/sftpgo'
  let filename = $"sftpgo_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/drakkan/sftpgo/releases/download/v($version)/sftpgo_($version)-1_amd64.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def rio [ --force(-f) ] {
  deps rio

  let version = ghub version 'raphamorim/rio'
  let filename = $"rio_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/raphamorim/rio/releases/download/v($version)/rio_($version)-1_amd64_wayland.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def qopy [ --force(-f) ] {
  let version = ghub version '0PandaDEV/Qopy'
  let filename = $"qopy_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $"https://github.com/0PandaDEV/Qopy/releases/download/v($version)/Qopy-($version).deb" $filepath
    sudo dpkg -i $filepath
  }
}

export def runjs [ --force(-f) ] {
  let version = ghub version 'lukehaas/RunJS'
  let filename = $"runjs_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/lukehaas/RunJS/releases/download/v($version)/runjs_($version)_amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def warp [ --force(-f) ] {
  let version = 'latest'
  let filename = $"runjs_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://app.warp.dev/download?package=deb $filepath
    sudo dpkg -i $filepath
  }
}

export def hoppscotch [ --force(-f) ] {
  let version = ghub version 'hoppscotch/releases'
  let filename = $"hoppscotch_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/hoppscotch/releases/releases/latest/download/Hoppscotch_linux_x64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def lapce [ --force(-f) ] {
  let version = ghub version 'lapce/lapce'
  let filename = $"lapce_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download https://github.com/lapce/lapce/releases/download/v($version)/lapce.ubuntu.mantic.amd64.deb $filepath
    sudo dpkg -i $filepath
  }
}

export def pacstall [ --force(-f) ] {
  let version = ghub version 'pacstall/pacstall'
  let filename = $"pacstall_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/pacstall/pacstall/releases/download/($version)/pacstall_($version)-pacstall2_all.deb' $filepath
    sudo dpkg -i $filepath
  }
}

export def contour [ --force(-f) ] {
  let version = ghub version 'contour-terminal/contour'
  let filename = $"contour_($version).deb"

  let filepath = filepath $filename
  let new = ($filepath | path-not-exists)

  if $new or $force {
    download $'https://github.com/contour-terminal/contour/releases/download/v($version)/contour-($version)-ubuntu24.04-amd64.deb' $filepath
    sudo dpkg -i $filepath
  }
}
