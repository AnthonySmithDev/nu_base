
def template_desktop [name: string] {
  let desktop_entry = [
    "[Desktop Entry]"
    $"Name=($name)"
    $"Exec=/usr/bin/brave-browser --user-data-dir=/home/anthony/.config/($name) --app=https://store.steampowered.com"
    "Terminal=false"
    "Type=Application"
    "Categories=Network;WebBrowser;"
  ]
  $desktop_entry | str join "\n"
}

def create_desktop [name: string] {
  template_desktop $name | save ($env.HOME | path join .local share applications $"($name).desktop")
}

def accounts [] {
  [0 1 2 3]
}

export def run [account: string@accounts] {
  let args = [
    "--app=https://store.steampowered.com"
    $"--user-data-dir=/home/anthony/.config/steam_($account)"
  ]
  brave-browser ...$args
}

export def desktop [account: string@accounts] {
  create_desktop $"steam_($account)"
}
