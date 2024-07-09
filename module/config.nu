
def exists [path: string] {
  let complete = (do { sudo test -d $path } | complete)
  if $complete.exit_code == 0 {
    return true
  }
  return false
}

def root_symlink [src_dir: string, dest_dir: string, file: string] {
  let file_src = ($env.CONFIG_DIR_REPO | path join $src_dir $file)

  let dir_dest = ($env.CONFIG_DIR_ROOT | path join $dest_dir)
  if not (exists $dir_dest) {
    sudo mkdir $dir_dest
  }

  let file_dest = ($dir_dest | path join $file)
	sudo rm -f $file_dest

  sudo ln -s $file_src $file_dest
}

def root_shortcut [dir: string, file: string] {
  print $'Root Config: ($dir) ($file)'
  root_symlink $dir $dir $file
}

export def 'root helix' [] {
  root_shortcut helix 'config.toml'
  root_shortcut helix 'languages.toml'
}

export def 'root nushell' [] {
  root_shortcut nushell 'config.nu'
  sudo touch '/root/.source.nu'

  root_shortcut nushell 'env.nu'
  sudo touch '/root/.env.nu'
}

def symlink_file [dir_src: string, dir_dst: string, file_src: string, file_dst: string] {
  let path_src = ($env.CONFIG_DIR_REPO | path join $dir_src $file_src)

  let dir = ($env.CONFIG_DIR_USER | path join $dir_dst)
  if not ($dir | path exists) {
    mkdir $dir
  }

  let path_dst = ($dir | path join $file_dst)
  if ($path_dst | path exists) {
    rm -f $path_dst
  }

  ln -sf $path_src $path_dst
}

def symlink_dir [dir_src: string, dir_dst: string] {
  let path_src = ($env.CONFIG_DIR_REPO | path join $dir_src)
  let path_dst = ($env.CONFIG_DIR_USER | path join $dir_dst)

	rm -rf $path_dst
  ln -sf $path_src $path_dst
}

def shortcut [dir: string, file: string] {
  print $'User Config: ($dir) ($file)'
  symlink_file $dir $dir $file $file
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

export def helix [] {
  shortcut helix 'config.toml'
  shortcut helix 'languages.toml'
}

export def zellij [ --theme(-t) ] {
  shortcut zellij 'config.kdl'
  if $theme {
    let source = ($env.USR_LOCAL_SOURCE | path join zellij)
    git_clone https://github.com/zellij-org/zellij.git $source
    let src = ($source | path join zellij-utils/assets/themes)
    let dst = ($env.HOME | path join .config/zellij/themes)
    if not ($dst | path exists) {
      cp -r -p $src $dst
    }
  }
}

export def nushell [] {
  shortcut nushell 'config.nu'
  touch -c ~/.source.nu

  shortcut nushell 'env.nu'
  touch -c ~/.env.nu
}

export def mods [] {
  shortcut mods 'mods.yml'
}

export def alacritty [ --theme(-t) ] {
  shortcut alacritty alacritty.toml
  if $theme {
    let source = ($env.USR_LOCAL_SOURCE | path join alacritty-theme)
    git_clone https://github.com/alacritty/alacritty-theme.git $source
    let src = ($source | path join themes)
    let dst = ($env.HOME | path join .config/alacritty/themes)
    if not ($dst | path exists) {
      cp -r -p $src $dst
    }
  }
}

def mouseless-files [] {
  [normal custom]
}

export def mouseless [file: string@mouseless-files] {
  print 'User Config: mouseless'
  symlink_file mouseless mouseless $"($file).yaml" config.yaml
}

export def kanata [] {
  print 'User Config: kanata'
  symlink_file kanata kanata "config.kbd" config.kbd
}

def evremap-files [] {
  [logitech redragon]
}

export def evremap [file: string@evremap-files] {
  print 'User Config: evremap'
  symlink_file evremap evremap $"($file).toml" config.toml
}

export def vieb [] {
  shortcut Vieb 'viebrc'
}

def lanmouse-files [] {
  [desktop micro]
}

export def lanmouse [file: string@lanmouse-files] {
  print $'User Config: lan-mouse'
  symlink_file lan-mouse lan-mouse $"($file).toml" config.toml
}

export def regolith [] {
  shortcut regolith3 Xresources
  shortcut regolith3/i3 config
  shortcut regolith3/sway config
  shortcut regolith3/picom config
  shortcut regolith3/i3status-rust config.toml
}

export def regolith-compositor [] {
  sudo sed -i 's/\/usr\/bin\/picom/\/usr\/bin\/picom --experimental-backends/g' /usr/share/regolith-compositor/init
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

export def git [] {
  ^git config --global user.name 'Anthony Smith'
  ^git config --global user.email 'anthonyasdeveloper@gmail.com'
  ^git config --global core.editor 'hx'
  ^git config --global init.defaultBranch 'main'
}

export def gitlab [] {
  ^glab config set -g -h $env.GITLAB_HOST token $env.GITLAB_TOKEN
  ^glab config set -g -h $env.GITLAB_HOST api_protocol http
  ^glab config set -g -h $env.GITLAB_HOST git_protocol ssh
}

export def ubuntu-software [] {
  sudo sed -i 's/http:\/\/pe\.archive\.ubuntu\.com\/ubuntu/http:\/\/archive\.ubuntu\.com\/ubuntu/g' /etc/apt/sources.list
}

export def core [] {
  helix
  zellij
  nushell
  dooit
  mods

  foot
  alacritty

  regolith
  input-remapper

  vieb
  git
}
