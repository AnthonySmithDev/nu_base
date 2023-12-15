source ../env.nu
source ../module/source.nu

def main [
  --download
  --config
  --link
  --clean
] {
  mkdir ($env.HOME | path join ".local/usr/bin")
  mkdir ($env.HOME | path join ".local/usr/lib")
  mkdir ($env.HOME | path join ".local/share/fonts")

  if $download {
    # download core
    download helix
    download zellij
    download nushell
    download zoxide
    download starship
  }

  if $config {
    # config core
    config helix
    config zellij
    config nushell
    config alacritty
  }

  if $link {
    sudo ln -sf ($env.HELIX_PATH | path join hx) /usr/bin/hx
    sudo ln -sf ($env.HELIX_PATH | path join hx) /usr/bin/editor
    sudo ln -sf ($env.USR_LOCAL_BIN | path join nu) /usr/bin/nu
    sudo ln -sf ($env.USR_LOCAL_BIN | path join zellij) /usr/bin/zellij
    sudo ln -sf ($env.USR_LOCAL_BIN | path join zoxide) /usr/bin/zoxide
    sudo ln -sf ($env.USR_LOCAL_BIN | path join starship) /usr/bin/starship
  }

  if $clean {
    sudo rm /usr/bin/hx
    sudo rm /usr/bin/editor
    sudo rm /usr/bin/nu
    sudo rm /usr/bin/zellij
    sudo rm /usr/bin/zoxide
    sudo rm /usr/bin/starship
  }
}
