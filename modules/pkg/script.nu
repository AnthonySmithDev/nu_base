
export def install [filename: string, --root(-r), --dev ] {
  let mod_path = ($env.MODULES_PATH | path join $filename)

  mkdir $env.USR_LOCAL_SHARE_SCRIPT
  let stem = ($filename | path parse | get stem)
  let share_path = ($env.USR_LOCAL_SHARE_SCRIPT | path join $stem)
  cp $mod_path $share_path

  let src_path = if $dev { $mod_path } else { $share_path }

  let usr_path = ($env.USR_LOCAL_BIN | path join $stem)
  ln -sf $src_path $usr_path
  chmod +x $usr_path

  let sys_path = ($env.SYS_LOCAL_BIN | path join $stem)
  if not ($sys_path | path exists) and $root {
    sudo ln -sf $usr_path $sys_path
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

export def vicat [] {
  install vicat.nu --dev --root
}

export def adctrl [] {
  install adctrl.nu --dev --root
}

export def hyprnu [] {
  install hyprnu.nu --dev --root
}

export def rain-add [] {
  install rain-add.nu --dev --root
}

export def core [] {
  ctx
  hyprnu
  rain-add
  scrollback-pager
  scrollback-editor
}
