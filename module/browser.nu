
def choose [] {
  mut options = []
  if (which brave-browser | is-not-empty) {
    $options = ($options | append brave-browser)
  }
  if (which google-chrome | is-not-empty) {
    $options = ($options | append google-chrome)
  }
  if (which opera | is-not-empty) {
    $options = ($options | append opera)
  }
  gum choose ...$options | str trim
}

export def main [url: string] {
  let browser = choose
  job spawn { run-external $browser $url }
}

const extensions = [
  'https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb'
  'https://chromewebstore.google.com/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh'
  # 'https://chromewebstore.google.com/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai'
  # 'https://chromewebstore.google.com/detail/simple-translate/ibplnjkanclpjokhdolnendpplpjiace'
  # 'https://chromewebstore.google.com/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld'
  # 'https://chromewebstore.google.com/detail/sound-booster-increase-vo/nmigaijibiabddkkmjhlehchpmgbokfj'
  'https://chromewebstore.google.com/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg'
]

export def extension [] {
  let browser = choose
  for $url in $extensions {
    job spawn { run-external $browser $url }
  }
}

export def vieb [
  url?: string
  --left(-l)
  --right(-r)
  --rm
] {
  mut args = [ '--config-file=~/.config/Vieb/viebrc' ]
  if $left {
    $args = ($args | append '--datafolder=~/.config/ViebLeft')
  }
  if $right {
    $args = ($args | append '--datafolder=~/.config/ViebRight')
  }
  if ($url | is-not-empty) {
    $args = ($args | append $url)
  }
  let args = $args
  job spawn {|| ^vieb ...$args }
}

export def brave [
  url?: string
  --ext(-e)
  --proxy(-p)
  --proxy-host: string = "localhost"
  --proxy-port: int = 8080
  --dir(-d): string
  --rm(-r)
] {
  let config = ($env.HOME | path join .config BraveSoftware)

  mut args = [
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  ]
  if $ext {
    $args = ($args | append $extensions)
  }
  if $proxy {
    $env.all_proxy = $"($proxy_host):($proxy_port)"
  }
  if ($dir | is-not-empty) {
    let user_data = ($config | path join Brave-Browser-($dir | str capitalize))
    if $rm {
      return (rm -rf $user_data)
    }
    $args = ($args | append $'--user-data-dir=($user_data)')
  }
  if ($url | is-not-empty) {
    $args = ($args | append $url)
  }
  let args = $args
  job spawn {|| ^brave-browser ...$args }
}

export def chrome [
  url?: string
  --ext(-e)
  --left(-l)
  --right(-r)
  --proxy(-p)
] {
  mut args = []
  if $ext {
    $args = ($args | append $extensions)
  }
  if $proxy {
    $args = ($args | append $'--proxy-server=($env.proxy_host):($env.proxy_port)')
  }
  if $left {
    let data = ($env.HOME | path join .config google-chrome-left)
    $args = ($args | append $'--user-data-dir=($data)')
  }
  if $right {
    let data = ($env.HOME | path join .config google-chrome-right)
    $args = ($args | append $'--user-data-dir=($data)')
  }
  if ($url | is-not-empty) {
    $args = ($args | append $url)
  }
  let args = $args
  job spawn {|| ^google-chrome ...$args }
}
