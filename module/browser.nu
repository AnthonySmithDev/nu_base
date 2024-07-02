
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
  bg $browser $url
}

const extensions = [
  'https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb'
  'https://chromewebstore.google.com/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh'
  'https://chromewebstore.google.com/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai'
  'https://chromewebstore.google.com/detail/simple-translate/ibplnjkanclpjokhdolnendpplpjiace'
  'https://chromewebstore.google.com/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld'
  'https://chromewebstore.google.com/detail/sound-booster-increase-vo/nmigaijibiabddkkmjhlehchpmgbokfj'
  'https://chromewebstore.google.com/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg'
]

export def extension [] {
  let browser = choose
  if (ps | where name =~ $browser | is-empty) {
    bg $browser
  }
  for $extension in $extensions {
    do -i {
      ^$browser $extension
    }
  }
}

export def vieb [
  url?: string
  --left(-l)
  --right(-r)
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
  bg vieb ...$args
}

export def brave [
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
    $args = ($args | append '--proxy-server=localhost:8080')
  }
  if $left {
    let data = ($env.HOME | path join .config brave-browser-left)
    $args = ($args | append $'--user-data-dir=($data)')
  }
  if $right {
    let data = ($env.HOME | path join .config brave-browser-right)
    $args = ($args | append $'--user-data-dir=($data)')
  }
  if ($url | is-not-empty) {
    $args = ($args | append $url)
  }
  bg brave-browser ...$args
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
    $args = ($args | append '--proxy-server=localhost:8080')
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
  bg google-chrome ...$args
}

export def mitmproxy-crt [] {
  let src = ($env.HOME | path join .mitmproxy mitmproxy-ca-cert.pem)
  let dest = ($env.HOME | path join Documents mitmproxy.pem)
  if not ($src | path exists) {
    return
  }
  cp $src $dest
  sudo cp $src /usr/local/share/ca-certificates/mitmproxy.crt
  sudo update-ca-certificates
}

export def proxify-crt [] {
  let src = ($env.HOME | path join .config proxify cacert.pem)
  let dest = ($env.HOME | path join Documents proxify.pem)
  if not ($src | path exists) {
    return
  }
  cp $src $dest
  sudo cp $src /usr/local/share/ca-certificates/proxify.crt
  sudo update-ca-certificates
}
