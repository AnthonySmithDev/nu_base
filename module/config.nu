
export-env {
  $env.CONFIG_DIR_REPO = ($env.REPO_PATH | path join 'config')
  $env.CONFIG_DIR_USER = ($env.HOME | path join '.config')
  $env.CONFIG_DIR_ROOT = ('/root' | path join '.config')
}

def root_symlink [src_dir: string, dest_dir: string, file: string] {
  let file_src = ($env.CONFIG_DIR_REPO | path join $src_dir $file)

  let dir_dest = ($env.CONFIG_DIR_ROOT | path join $dest_dir)
  let exists = sudo nu -c $'"($dir_dest)" | path exists'
  if not ($exists | into bool) {
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

def symlink [src_dir: string, dest_dir: string, file: string] {
  let file_src = ($env.CONFIG_DIR_REPO | path join $src_dir $file)

  let dir_dest = ($env.CONFIG_DIR_USER | path join $dest_dir)
  if not ($dir_dest | path exists) {
    mkdir $dir_dest
  }

  let file_dest = ($dir_dest | path join $file)
	rm -f $file_dest

  ln -s $file_src $file_dest
}

def shortcut [dir: string, file: string] {
  print $'User Config: ($dir) ($file)'
  symlink $dir $dir $file
}

export def dooit [] {
  shortcut dooit 'config.py'
}

export def foot [] {
  shortcut foot 'foot.ini'
}

export def helix [] {
  shortcut helix 'config.toml'
  shortcut helix 'languages.toml'
}

export def zellij [] {
  shortcut zellij 'config.kdl'
}

export def nushell [] {
  shortcut nushell 'config.nu'
  touch '~/.source.nu'

  shortcut nushell 'env.nu'
  touch '~/.env.nu'
}

export def mods [] {
  shortcut mods 'mods.yml'
}

export def alacritty [] {
  shortcut alacritty 'alacritty.yml'
}

export def vieb [] {
  shortcut Vieb 'viebrc'
}

export def regolith [] {
  shortcut regolith3 'Xresources'
  shortcut regolith3/i3 'config'
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

export def github [] {
  git config --global user.name 'Anthony Smith'
  git config --global user.email 'anthonyasdeveloper@gmail.com'
  git config --global core.editor 'hx'
  git config --global init.defaultBranch 'main'
}

export def ssh [] {
  ssh-keygen -t ed25519 -C 'anthonyasdeveloper@gmail.com'
}

export def core [] {
  helix
  nushell
  zellij
  dooit
  mods

  foot
  alacritty

  regolith
  input-remapper

  vieb
  github
}
