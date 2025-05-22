
export def install [filename: string, --root(-r), --dev ] {
  let mod_path = ($env.MODULES_PATH | path join $filename)

  let stem = ($filename | path parse | get stem)
  let share_path = ($env.USR_LOCAL_SHARE_BIN | path join $stem)
  cp $mod_path $share_path

  let src_path = if $dev { $mod_path } else { $share_path }

  let usr_path = ($env.USR_LOCAL_BIN | path join $stem)
  ln -sf $src_path $usr_path
  chmod +x $usr_path

  if $root {
    let sys_path = ($env.SYS_LOCAL_BIN | path join $stem)
    sudo ln -sf $src_path $sys_path
    sudo chmod +x $sys_path
  }
}

export def cosmic [] {
  install cosmic.nu --root
}

export def ctx [] {
  install ctx.nu --dev --root
}

export def clipboard [] {
  install clipboard.nu --root
}

export def term-editor [] {
  install term-editor.nu --root
}

export def scrollback-pager [] {
  install scrollback-pager.nu --root
}

export def scrollback-editor [] {
  install scrollback-editor.nu --root
}

export def video-thumbnail [] {
  install video-thumbnail.nu --root
}
