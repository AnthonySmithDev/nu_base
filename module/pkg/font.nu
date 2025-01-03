
def share [name: string, version: string] {
  let dir = ([$name $version] | str join '_')
  $env.USR_LOCAL_SHARE_FONTS | path join $dir
}

def symlink [src: string, name: string] {
  let dest = ($env.LOCAL_SHARE_FONTS | path join $name)

  rm -rf $dest
  ln -sf $src $dest
}

export def FiraCode [] {
  let version = ghub version 'ryanoasis/nerd-fonts'

  let path = share FiraCode $version
  if not ($path | path exists) {
    https download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/FiraCode.zip'
    if ($env.PWD | path join 'FiraCode' | path exists) {
      rm -rf 'FiraCode'
    }

    extract zip FiraCode.zip -d FiraCode
    mv 'FiraCode' $path
  }

  symlink $path 'FiraCode'
}

export def CascadiaCode [] {
  let version = ghub version 'ryanoasis/nerd-fonts'

  let path = share CascadiaCode $version
  if not ($path | path exists) {
    https download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/CascadiaCode.zip'
    if ($env.PWD | path join 'CascadiaCode' | path exists) {
      rm -rf 'CascadiaCode'
    }

    extract zip CascadiaCode.zip -d CascadiaCode
    mv 'CascadiaCode' $path
  }

  symlink $path 'CascadiaCode'
}

export def JetBrainsMono [] {
  let version = ghub version 'ryanoasis/nerd-fonts'

  let path = share JetBrainsMono $version
  if not ($path | path exists) {
    https download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/JetBrainsMono.zip'
    if ($env.PWD | path join 'JetBrainsMono' | path exists) {
      rm -rf 'JetBrainsMono'
    }

    extract zip JetBrainsMono.zip -d JetBrainsMono
    mv 'JetBrainsMono' $path
  }

  symlink $path 'JetBrainsMono'
}
