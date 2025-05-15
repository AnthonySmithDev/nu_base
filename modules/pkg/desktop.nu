
def icons [name: string] {
  $env.ICONS_PATH | path join $name
}

def applications [name: string] {
  $env.APPLICATIONS_PATH | path join $"($name).desktop"
}

export  def helix [] {
  ln -sf (icons helix.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications helix) $env.LOCAL_SHARE_APPLICATIONS
}

export  def yazi [] {
  ln -sf (icons yazi.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications yazi) $env.LOCAL_SHARE_APPLICATIONS
}

export  def zellij [] {
  ln -sf (icons zellij.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications zellij) $env.LOCAL_SHARE_APPLICATIONS
}

export  def kitty [] {
  ln -sf (icons kitty.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications kitty) $env.LOCAL_SHARE_APPLICATIONS
}

export  def lan-mouse [] {
  ln -sf (icons lan-mouse.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications lan-mouse) $env.LOCAL_SHARE_APPLICATIONS
}

export  def android-studio [] {
  ln -sf (applications android-studio) $env.LOCAL_SHARE_APPLICATIONS
}
