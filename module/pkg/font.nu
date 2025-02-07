
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
  let path = dirpath FiraCode $version
  
  if (path-not-exists $path $force) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/FiraCode.zip'
    if ($env.PWD | path join 'FiraCode' | path exists) {
      rm -rf 'FiraCode'
    }

    extract zip FiraCode.zip -d FiraCode
    mv 'FiraCode' $path
  }

  symlink $path 'FiraCode'
}

export def CascadiaCode [ --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let path = dirpath CascadiaCode $version
  
  if (path-not-exists $path $force) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/CascadiaCode.zip'
    if ($env.PWD | path join 'CascadiaCode' | path exists) {
      rm -rf 'CascadiaCode'
    }

    extract zip CascadiaCode.zip -d CascadiaCode
    mv 'CascadiaCode' $path
  }

  symlink $path 'CascadiaCode'
}

export def JetBrainsMono [ --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let path = dirpath JetBrainsMono $version
  
  if (path-not-exists $path $force) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/JetBrainsMono.zip'
    if ($env.PWD | path join 'JetBrainsMono' | path exists) {
      rm -rf 'JetBrainsMono'
    }

    extract zip JetBrainsMono.zip -d JetBrainsMono
    mv 'JetBrainsMono' $path
  }

  symlink $path 'JetBrainsMono'
}
