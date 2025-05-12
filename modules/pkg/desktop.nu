
def names [] {
  [lan-mouse, android-studio]
}

def icons [name: string] {
  $env.ICONS_PATH | path join $"($name).png"
}

def applications [name: string] {
  $env.APPLICATIONS_PATH | path join $"($name).desktop"
}

export  def helix [] {
  ln -sf (icons helix) $env.LOCAL_SHARE_ICONS
  ln -sf (applications helix) $env.LOCAL_SHARE_APPLICATIONS
}

export  def yazi [] {
  ln -sf (icons yazi) $env.LOCAL_SHARE_ICONS
  ln -sf (applications yazi) $env.LOCAL_SHARE_APPLICATIONS
}

export  def zellij [] {
  ln -sf (icons zellij) $env.LOCAL_SHARE_ICONS
  ln -sf (applications zellij) $env.LOCAL_SHARE_APPLICATIONS
}

export def main [name: string@names] {
  ln -sf (applications $name) $env.LOCAL_SHARE_APPLICATIONS
}
