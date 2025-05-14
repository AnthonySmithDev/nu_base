
export-env {
  $env.DATA_PATH = ($env.HOME | path join nu/nu_base/data/)
  $env.MODULES_PATH = ($env.HOME | path join nu/nu_base/modules/)

  $env.ICONS_PATH = ($env.DATA_PATH | path join icons)
  $env.APPLICATIONS_PATH = ($env.DATA_PATH | path join applications)

  $env.CONFIG_PATH = ($env.DATA_PATH | path join config)

  $env.GHUB_REPOSITORY_PATH = ($env.CONFIG_PATH | path join ghub/ghub.json)
  $env.GHUB_TEMP_PATH = ($env.HOME | path join temp/ghub)

  $env.PKG_BIN_SYS = "linux_x64"
  $env.PKG_TEMP_PATH = ($env.HOME | path join temp/pkg)
  $env.DOWNLOAD_FORCE = false
}

export use ../ghub

export use apt.nu
export use deps.nu
export use bin/
export module sh.nu
export module deb.nu
export module arch.nu
export module go.nu
export module cargo.nu
export module js.nu
export module py.nu
export module snap.nu
export module flathub.nu
export module compile.nu
export module appimage.nu
export module script.nu
export module lsp.nu

export module desktop.nu
export module font.nu
export module apk
