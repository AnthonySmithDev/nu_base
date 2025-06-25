
def icons [name: string] {
  $env.ICONS_PATH | path join $name
}

def applications [name: string] {
  $env.APPLICATIONS_PATH | path join $"($name).desktop"
}

def share [...name: string] {
  $env.LOCAL_SHARE_APPLICATIONS | path join ...$name
}

export  def helix [] {
  ln -sf (icons helix.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications helix) (share)
}

export  def yazi [] {
  ln -sf (icons yazi.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications yazi) (share)
}

export  def zellij [] {
  ln -sf (icons zellij.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications zellij) (share)
}

export  def kitty [] {
  ln -sf (icons kitty.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications kitty) (share)
  ln -sf (applications kitty-open) (share)
}

export  def lan-mouse [] {
  ln -sf (icons lan-mouse.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications lan-mouse) (share)
}

export  def rain-add [] {
  ln -sf (icons rain.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications rain-add) (share rain.desktop)
}

export  def rain-download [] {
  ln -sf (icons rain.png) $env.LOCAL_SHARE_ICONS
  ln -sf (applications rain-download) (share rain.desktop)
}

export  def android-studio [] {
  ln -sf (applications android-studio) (share)
}

export  def session [] {
  ln -sf (icons session.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications session) (share session.desktop)
}

export  def imv [] {
  ln -sf (icons qView.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications imv) (share imv.desktop)
  ln -sf (applications imv-dir) (share imv-dir.desktop)
}

export  def discord-web [] {
  ln -sf (applications discord-web) (share discord-web.desktop)
}

export  def whatsapp-web [] {
  ln -sf (applications whatsapp-web) (share whatsapp-web.desktop)
}

export  def telegram-web [] {
  ln -sf (applications telegram-web) (share telegram-web.desktop)
}

export  def scrcpy [] {
  ln -sf (icons scrcpy.svg) $env.LOCAL_SHARE_ICONS
  ln -sf (applications scrcpy) (share scrcpy.desktop)
}
