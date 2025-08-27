
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

def fonts [] {
  [FiraCode CascadiaCode JetBrainsMono Monaspace]
}

export def main [ font: string@fonts, --force(-f) ] {
  let version = ghub version 'ryanoasis/nerd-fonts'
  let dirpath = dirpath $font $version
  
  if (path-not-exists $dirpath $force) {
    let download_path = ghub asset download ryanoasis/nerd-fonts -s $"($font).zip" -x
    mv $download_path $dirpath
  }

  symlink $dirpath $font
}
