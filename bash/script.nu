source ../env.nu
source ../module/source.nu

def main [
  --download
  --config
  --link
  --font
  --clean
] {
  mkdir ($env.HOME | path join ".local/usr/bin")
  mkdir ($env.HOME | path join ".local/usr/lib")
  mkdir ($env.HOME | path join ".local/usr/share")
  mkdir ($env.HOME | path join ".local/share/fonts")

  if $download {
    if $link {
      download xh
      download gum
      download helix --global
      download zellij --global
      download nushell --global
      download zoxide --global
      download starship --global
    } else {
      download xh
      download gum
      download helix
      download zellij
      download nushell
      download zoxide
      download starship
    }
  }

  if $config {
    # config core
    config helix
    config zellij
    config nushell
    config alacritty
  }

  if $font {
    nerd-font FiraCode
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
