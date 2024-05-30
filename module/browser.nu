
def choose [] {
  mut options = []
  if not (which brave-browser | is-empty) {
    $options = ($options | append brave-browser)
  }
  if not (which google-chrome | is-empty) {
    $options = ($options | append google-chrome)
  }
  if not (which opera | is-empty) {
    $options = ($options | append opera)
  }
  gum choose ...$options | str trim
}

export def main [url: string] {
  let browser = choose
  bg $browser
}

export def vieb [
  --left(-l)
  --right(-r)
] {
  if $left {
    bg vieb --datafolder=~/.config/ViebLeft --config-file=~/.config/Vieb/viebrc
    return
  }
  if $right {
    bg vieb --datafolder=~/.config/ViebRight --config-file=~/.config/Vieb/viebrc
    return
  }
  bg vieb
}

export def brave [
  url?: string
  --left(-l)
  --right(-r)
  --proxy(-p)
] {
  mut args = []
  if $proxy {
    $args = ($args | append '--proxy-server=localhost:8080')
  }
  if ($url != null) {
    $args = ($args | append $url)
  }
  if $left {
    let data = ($env.HOME | path join .config brave-browser-left)
    bg brave-browser --user-data-dir=($data) ...$args
    return
  }
  if $right {
    let data = ($env.HOME | path join .config brave-browser-right)
    bg brave-browser --user-data-dir=($data) ...$args
    return
  }
  bg brave-browser ...$args
}

export def chrome [
  url?: string
  --left(-l)
  --right(-r)
  --proxy(-p)
] {
  mut args = []
  if $proxy {
    $args = ($args | append '--proxy-server=localhost:8080')
  }
  if ($url != null) {
    $args = ($args | append $url)
  }
  if $left {
    let data = ($env.HOME | path join .config google-chrome-left)
    bg google-chrome --user-data-dir=($data) ...$args
    return
  }
  if $right {
    let data = ($env.HOME | path join .config google-chrome-right)
    bg google-chrome --user-data-dir=($data) ...$args
    return
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

export def extension [] {
  let extensions = [
    'https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb'
    'https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh'
    'https://chrome.google.com/webstore/detail/volume-booster/anmbbeeiaollmpadookgoakpfjkbidaf'
    'https://chrome.google.com/webstore/detail/simple-translate/ibplnjkanclpjokhdolnendpplpjiace'
    'https://chrome.google.com/webstore/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg'
    'https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai'
    'https://chrome.google.com/webstore/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld'
  ]
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
