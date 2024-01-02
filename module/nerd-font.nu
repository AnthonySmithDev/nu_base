
export def JetBrainsMono [] {
  let version = '3.0.2'

  http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/JetBrainsMono.zip'
  extract zip 'JetBrainsMono.zip' -d 'JetBrainsMono'

  mkdir $env.SHARE_FONTS_PATH
  rm -rf ($env.SHARE_FONTS_PATH | path join 'JetBrainsMono')
  mv 'JetBrainsMono' ($env.SHARE_FONTS_PATH | path join 'JetBrainsMono')
}

export def CascadiaCode [] {
  let version = '3.0.2'

  http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/CascadiaCode.zip'
  extract zip 'CascadiaCode.zip' -d 'CascadiaCode'

  mkdir $env.SHARE_FONTS_PATH
  rm -rf ($env.SHARE_FONTS_PATH | path join 'CascadiaCode')
  mv 'CascadiaCode' ($env.SHARE_FONTS_PATH | path join 'CascadiaCode')
}

export def FiraCode [] {
  let version = '3.0.2'

  http download $'https://github.com/ryanoasis/nerd-fonts/releases/download/v($version)/FiraCode.zip'
  extract zip 'FiraCode.zip' -d 'FiraCode'

  mkdir $env.SHARE_FONTS_PATH
  rm -rf ($env.SHARE_FONTS_PATH | path join 'FiraCode')
  mv 'FiraCode' ($env.SHARE_FONTS_PATH | path join 'FiraCode')
}
