
def choose [] {
  gum choose [ "opera" "brave-browser" "google-chrome" ] | str trim
}

export def main [url: string] {
  let browser = choose
  if (ps | where name =~ $browser | is-empty) {
    bg $browser
  }
  ^$browser $url
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
