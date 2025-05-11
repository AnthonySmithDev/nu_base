
export def setup [] {
  qmk setup --yes

  let src = ($env.HOME | path join qmk_firmware/util/udev/50-qmk.rules)
  let dst = '/etc/udev/rules.d/50-qmk.rules'
  if not ($dst | path exists) {
    sudo cp $src $dst
  }

  let userspace = ($env.HOME | path join qmk_userspace)
  if ($userspace | path exists) {
    git -C $userspace pull
  } else {
    git clone git@github.com:AnthonySmithDev/qmk_userspace.git $userspace
  }

  qmk config user.overlay_dir=($userspace)
}

export def keyboards [] {
  # qmk list-keyboards | lines | where {|x| str starts-with "lily58"}
  [
    lily58/rev1
    lily58/r2g
    lily58/light
    lily58/glow_enc
  ]
}

export def keymaps [context: string] {
  let kb = ($context | split row " " | get 2)
  qmk list-keymaps -kb $kb | lines
}

export def bootloaders [] {
  [
    avrdude
    avrdude-split-left
    avrdude-split-right
  ]
}

export def new [kb: string@keyboards, km: string@keymaps] {
  qmk new-keymap -kb $kb -km $km
}

export def flash [kb: string@keyboards, km: string@keymaps, bl: string@bootloaders = 'avrdude'] {
  qmk flash -kb $kb -km $km -bl $bl
}

export def compile [kb: string@keyboards, km: string@keymaps] {
  qmk compile -kb $kb -km $km
}

export def docker [kb: string@keyboards, km: string@keymaps, --flash(-f)] {
  let args = if $flash { [$kb $km 'flash'] } else { [$kb $km] }
  with-wd ($env.HOME | path join qmk_firmware) {
    ^($env.PWD | path join util/docker_build.sh) ($args | str join ':')
  }
}

export def split [kb: string@keyboards, km: string@keymaps] {
  flash $kb $km avrdude-split-left
  flash $kb $km avrdude-split-right
}

export def anthony [] {
  split lily58/rev1 anthony
}

export def smith [] {
  split lily58/r2g smith
}
