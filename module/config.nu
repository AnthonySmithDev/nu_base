
def symlink_file [
  src_dirname: string
  dst_dirname: string
  src_basename: string
  dst_basename: string
] {
  let src_dir = ($env.CONFIG_DIR_REPO | path join $src_dirname)
  let src_file = ($src_dir | path join $src_basename)

  let dst_dir = ($env.CONFIG_DIR_USER | path join $dst_dirname)
  let dst_file = ($dst_dir | path join $dst_basename)

  if not ($dst_dir | path exists) {
    mkdir $dst_dir
  }

  ln -sf $src_file $dst_file
}

def symlink_dir [src_dirname: string, dst_dirname: string] {
  let src_dir = ($env.CONFIG_DIR_REPO | path join $src_dirname)
  let dst_dir = ($env.CONFIG_DIR_USER | path join $dst_dirname)

  ln -sf $src_dir $dst_dir
}

def shortcut [dirname: string, basename: string] {
  print $'User Config: ($dirname) ($basename)'
  symlink_file $dirname $dirname $basename $basename
}

export def "iTerm2-Color-Schemes" [] {
  let dir = mktemp --directory --tmpdir-path $env.TMP_PATH_DIR
  mkdir $dir

  let path = ($env.TMP_PATH_FILE | path join "iTerm2-Color-Schemes.tar")
  if not ($path | path exists) {
    http download https://github.com/mbadolato/iTerm2-Color-Schemes/tarball/master -o $path
  }
  let source = ($env.USR_LOCAL_SOURCE | path join iTerm2-Color-Schemes)
  if not ($source | path exists) {
    tar -xvf $path -C $dir
    mv (ls $dir | get name | first) $source
  }
  return $source
}

export def rio [ --theme ] {
  shortcut rio config.toml
  if $theme {
    rio theme
  }
}

def 'rio theme' [] {
  let source = ($env.USR_LOCAL_SOURCE | path join rio-theme)
  git-down https://github.com/raphamorim/rio-terminal-themes.git $source
  let src = ($source | path join themes)
  let dst = ($env.HOME | path join .config/rio/themes)
  rm -rf $dst
  ln -sf $src $dst
}

export def alacritty [ --theme ] {
  shortcut alacritty alacritty.toml
  if $theme {
    alacritty theme
  }
}

def 'alacritty theme' [] {
  let source = ($env.USR_LOCAL_SOURCE | path join alacritty-theme)
  git-down https://github.com/alacritty/alacritty-theme.git $source
  let src = ($source | path join themes)
  let dst = ($env.HOME | path join .config/alacritty/themes)
  rm -rf $dst
  ln -sf $src $dst
}

export def ghostty [ --theme ] {
  shortcut ghostty config
  if $theme {
    ghostty theme
  }
}

def 'ghostty theme' [] {
  let src = (iTerm2-Color-Schemes | path join ghostty)
  let dst = ($env.HOME | path join .config ghostty themes)
  ln -sf $src $dst
}

export def zellij [ --theme ] {
  shortcut zellij 'config.kdl'
  if $theme {
    zellij theme
  }
}

def 'zellij theme' [] {
  let source = ($env.USR_LOCAL_SOURCE | path join zellij)
  git-down https://github.com/zellij-org/zellij.git $source
  let src = ($source | path join zellij-utils/assets/themes)
  let dst = ($env.HOME | path join .config/zellij/themes)
  rm -rf $dst
  ln -sf $src $dst
}

export def helix [ --theme ] {
  shortcut helix 'config.toml'
  shortcut helix 'languages.toml'
  if $theme {
    helix theme
  }
}

export def 'helix theme' [] {
  let theme = ($env.HELIX_RUNTIME | path join themes/ayu_dark.toml)
  if ($theme | path exists) {
    sed -i '38s/"background"/""/' $theme
    sed -i '44s/"black"/""/' $theme
    sed -i '49s/"black"/""/' $theme
    sed -i '51s/"black"/""/' $theme
    sed -i '58s/"black"/""/' $theme
  }
}

export def nushell [] {
  shortcut nushell 'config.nu'
  shortcut nushell 'env.nu'

  touch -c ~/.source.nu
  touch -c ~/.env.nu
}

export def mods [] {
  shortcut mods 'mods.yml'
}

export def aichat [] {
  shortcut aichat 'config.yaml'
}

export def dooit [] {
  shortcut dooit 'config.py'
}

export def foot [] {
  shortcut foot 'foot.ini'
}

export def bat [] {
  shortcut bat 'config'
}

export def files-mouseless [] {
  [normal custom zmk]
}

export def mouseless [file: string@files-mouseless] {
  print 'User Config: mouseless'
  symlink_file mouseless mouseless $"($file).yaml" config.yaml
}

export def kanata [] {
  print 'User Config: kanata'
  symlink_file kanata kanata "config.kbd" config.kbd
}

export def files-evremap [] {
  [logitech redragon laptop]
}

export def evremap [file: string@files-evremap] {
  print 'User Config: evremap'
  symlink_file evremap evremap $"($file).toml" config.toml
}

export def vieb [] {
  shortcut Vieb 'viebrc'

  let src = ($env.SCRIPT_DIR_SRC | path join vieb.nu)
  let dst = ($env.SCRIPT_DIR_DST | path join vieb)
  ln -sf $src $dst
  chmod 777 $dst
}

export def files-lanmouse [] {
  [desktop micro]
}

export def lanmouse [file: string@files-lanmouse] {
  print $'User Config: lan-mouse'
  symlink_file lan-mouse lan-mouse $"($file).toml" config.toml
}

export def regolith [] {
  shortcut regolith3 Xresources
  shortcut regolith3/common-wm/config.d config
  shortcut regolith3/i3status-rust config.toml
  # shortcut regolith3/i3 config
  # shortcut regolith3/sway config
  # shortcut regolith3/picom config
}

export def input-remapper [] {
  shortcut input-remapper-2 'config.json'

  let keyboards = [
    'SINO WEALTH Gaming KB '
    'AT Translated Set 2 keyboard'
    'Logitech Logi TKL Mechanical Keyboard'
  ]

  for keyboard in $keyboards {
    shortcut ('input-remapper-2' | path join 'presets' $keyboard) 'dev.json'
  }
}

export def cosmic [] {
  let src = ($env.CONFIG_DIR_REPO | path join cosmic/)
  let dst = ($env.CONFIG_DIR_USER | path join cosmic/)
  rsync -av $src $dst

  let src = ($env.SCRIPT_DIR_SRC | path join cosmic.nu)
  let dst = ($env.SCRIPT_DIR_DST | path join cosmic)
  ln -sf $src $dst
  chmod 777 $dst
}

export def ctx [] {
  let src = ($env.SCRIPT_DIR_SRC | path join ctx.nu)
  let dst = ($env.LOCAL_BIN | path join ctx)
  ln -sf $src $dst
  chmod +x $dst
}

export def git [] {
  ^git config --global user.name 'Anthony Smith'
  ^git config --global user.email 'anthonyasdeveloper@gmail.com'
  ^git config --global core.editor 'hx'
  ^git config --global init.defaultBranch 'main'
}

export def ubuntu-software [] {
  sudo sed -i 's/http:\/\/pe\.archive\.ubuntu\.com\/ubuntu/http:\/\/archive\.ubuntu\.com\/ubuntu/g' /etc/apt/sources.list
}

export def docker [] {
  sudo usermod -aG docker $env.USER
}

export def ftpserver [] {
  print $'User Config: ftpserver'
  shortcut ftpserver ftpserver.json
}

export def rclone [] {
  print $'User Config: rclone'
  shortcut rclone rclone.conf
}

export def termscp [] {
  print $'User Config: termscp'
  shortcut termscp config.toml
  shortcut termscp bookmarks.toml
}

export def vi-mongo [] {
  print $'User Config: vi-mongo'
  shortcut vi-mongo config.yaml
}

export def yazi [] {
  print $'User Config: yazi'

  shortcut yazi init.lua
  shortcut yazi yazi.toml
  shortcut yazi theme.toml
  shortcut yazi keymap.toml

  try { ya pack -a yazi-rs/plugins:full-border }
  try { ya pack -a grappas/wl-clipboard }
  try { ya pack -a kmlupreti/ayu-dark }
}
