
def dirpath [name: string, version: string] {
  $env.USR_LOCAL_FONT | path join $'($name)_($version)'
}

def path-not-exists [path: string, force: bool] {
  not ($path | path exists) or $force
}

def symlink [src: string, name: string] {
  let dest = ($env.LOCAL_SHARE_FONTS | path join $name)

  rm -rf $dest
  ln -sf $src $dest
}

export def FiraCode [ --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let dirpath = dirpath FiraCode $version
  
  if (path-not-exists $dirpath $force) {
    let download_path = ghub asset download ryanoasis/nerd-fonts -s FiraCode.zip -x
    mv $download_path $dirpath
  }

  symlink $dirpath FiraCode
}

export def CascadiaCode [ --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let dirpath = dirpath CascadiaCode $version
  
  if (path-not-exists $dirpath $force) {
    let download_path = ghub asset download ryanoasis/nerd-fonts -s CascadiaCode.zip -x
    mv $download_path $dirpath
  }

  symlink $dirpath CascadiaCode
}

export def JetBrainsMono [ --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let dirpath = dirpath JetBrainsMono $version
  
  if (path-not-exists $dirpath $force) {
    let download_path = ghub asset download ryanoasis/nerd-fonts -s JetBrainsMono.zip -x
    mv $download_path $dirpath
  }

  symlink $dirpath JetBrainsMono
}
