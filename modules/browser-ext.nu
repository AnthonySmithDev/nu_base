
const extensions = [
  [name, url];
  [vimium, https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb]
  [dark-reader, https://chromewebstore.google.com/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh]
  [picture-in-picture-extens, https://chromewebstore.google.com/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg]
  [close-duplicate-tab, https://chromewebstore.google.com/detail/close-duplicate-tab/lccfnphpgnpeghoffocbacbkohbapinm]
  [copy-all-urls, https://chromewebstore.google.com/detail/copy-all-urls/djdmadneanknadilpjiknlnanaolmbfk?hl]
  # [authenticator, https://chromewebstore.google.com/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai]
  # [simple-translate, https://chromewebstore.google.com/detail/simple-translate/ibplnjkanclpjokhdolnendpplpjiace]
  # [user-javascript-and-css, https://chromewebstore.google.com/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld]
  # [sound-booster-increase-vo, https://chromewebstore.google.com/detail/sound-booster-increase-vo/nmigaijibiabddkkmjhlehchpmgbokfj]
]

def commands [] {
  which brave vivaldi | rename value description
}

export def main [...commands: string@commands] {
  for $command in $commands {
    ^$command ...($extensions | get url)
  }
}
