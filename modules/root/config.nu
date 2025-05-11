
export-env {
  $env.CONFIG_DIR_SRC = ($env.HOME | path join nu/nu_base/data/config/)
  $env.CONFIG_DIR_ROOT = ('/root' | path join .config)
}

def path-exists [] {
  let path = $in
  let complete = (do { sudo test -d $path } | complete)
  return ($complete.exit_code == 0)
}

def symlink [
  src_dirname: string
  dst_dirname: string
  basename: string
] {
  let src_dir = ($env.CONFIG_DIR_SRC | path join $src_dirname)
  let src_file = ($src_dir | path join $basename)

  let dst_dir = ($env.CONFIG_DIR_ROOT | path join $dst_dirname)
  let dst_file = ($dst_dir | path join $basename)

  if not ($dst_dir | path-exists) {
    sudo mkdir -p $dst_dir
  }

  sudo ln -sf $src_file $dst_file
}

def shortcut [dirname: string, basename: string] {
  print $'Root Config: ($dirname) ($basename)'
  symlink $dirname $dirname $basename
}

export def helix [] {
  shortcut helix 'config.toml'
  shortcut helix 'languages.toml'
}

export def nushell [] {
  shortcut nushell 'config.nu'
  shortcut nushell 'env.nu'

  sudo touch '/root/.source.nu'
  sudo touch '/root/.env.nu'
}

export def zellij [] {
  shortcut zellij 'config.kdl'
}
