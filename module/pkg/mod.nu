
export-env {
  $env.DOWNLOAD_PATH_DIR = ($env.HOME | path join tmp dir)
  $env.DOWNLOAD_PATH_FILE = ($env.HOME | path join tmp file)
  $env.DOWNLOAD_FORCE = false
  $env.PKG_BIN_SYS = "linux_x64"
}

export use deps.nu
export module sh.nu
export module bin.nu
export module apt.nu
export module deb.nu
export module arch.nu
export module go.nu
export module cargo.nu
export module js.nu
export module py.nu
export module snap.nu
export module flathub.nu
export module compile.nu

export module font.nu
export module apk.nu
