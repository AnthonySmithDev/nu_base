
export def install [basename: string, --root(-r) ] {
  let stem = ($basename | path parse | get stem)
  let src = ($env.SCRIPT_DIR_SRC | path join $basename)

  let dst = ($env.LOCAL_BIN | path join $stem)
  ln -sf $src $dst
  chmod +x $dst

  if $root {
    let dst = ($env.SYS_LOCAL_BIN | path join $stem)
    sudo ln -sf $src $dst
    sudo chmod +x $dst
  }
}

export def cosmic [] {
  install cosmic.nu --root
}

export def ctx [] {
  install ctx.nu --root
}

export def clipboard [] {
  install clipboard.nu --root
}

export def term-editor [] {
  install term-editor.nu --root
}
