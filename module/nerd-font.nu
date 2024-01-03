
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
  let version = '3.0.2'

  let path = share FiraCode $version
  if not ($path | path exists) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/FiraCode.zip'
    extract zip 'FiraCode.zip' -d 'FiraCode'
    mv 'FiraCode' $path
  }

  symlink $path 'FiraCode'
}

export def CascadiaCode [] {
  let version = '3.0.2'

  let path = share CascadiaCode $version
  if not ($path | path exists) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/CascadiaCode.zip'
    extract zip 'CascadiaCode.zip' -d 'CascadiaCode'
    mv 'CascadiaCode' $path
  }

  symlink $path 'CascadiaCode'
}

export def JetBrainsMono [] {
  let version = '3.0.2'

  let path = share JetBrainsMono $version
  if not ($path | path exists) {
    http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/JetBrainsMono.zip'
    extract zip 'JetBrainsMono.zip' -d 'JetBrainsMono'
    mv 'JetBrainsMono' $path
  }

  symlink $path 'JetBrainsMono'
}
