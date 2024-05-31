
$env.NU_BASE_PATH = ($env.HOME | path join 'nushell' 'nu_base')
if not ($env.NU_BASE_PATH | path exists) {
  $env.NU_BASE_PATH = ($env.HOME | path join '.local' 'nu_base')
}

$env.USR_LOCAL = ($env.HOME | path join '.usr' 'local')
$env.USR_LOCAL_BIN = ($env.USR_LOCAL | path join 'bin')
$env.USR_LOCAL_LIB = ($env.USR_LOCAL | path join 'lib')
$env.USR_LOCAL_SOURCE = ($env.USR_LOCAL | path join 'source')
$env.USR_LOCAL_SHARE = ($env.USR_LOCAL | path join 'share')
$env.USR_LOCAL_SHARE_FONTS = ($env.USR_LOCAL_SHARE | path join 'fonts')
$env.USR_LOCAL_SHARE_DOWNLOAD = ($env.USR_LOCAL_SHARE | path join 'download')
env-path -p $env.USR_LOCAL_BIN

$env.NU_BASE_FILES = ($env.NU_BASE_PATH | path join files)

$env.HELIX_PATH = ($env.USR_LOCAL_LIB | path join 'helix')
$env.HELIX_RUNTIME = ($env.HELIX_PATH | path join 'runtime')
env-path $env.HELIX_PATH

$env.NVIM_PATH = ($env.USR_LOCAL_LIB | path join 'nvim')
$env.NVIM_BIN = ($env.NVIM_PATH | path join 'bin')
env-path $env.NVIM_BIN

$env.VSCODIUM_PATH = ($env.USR_LOCAL_LIB | path join 'vscodium')
$env.VSCODIUM_BIN = ($env.VSCODIUM_PATH | path join 'bin')
env-path $env.VSCODIUM_BIN

$env.CODE_SERVER_PATH = ($env.USR_LOCAL_LIB | path join 'code-server')
$env.CODE_SERVER_BIN = ($env.CODE_SERVER_PATH | path join 'bin')
env-path $env.CODE_SERVER_BIN

$env.MITMPROXY_BIN = ($env.USR_LOCAL_BIN | path join 'mitmproxy')
env-path $env.MITMPROXY_BIN

$env.AMBER_BIN = ($env.USR_LOCAL_BIN | path join 'amber')
env-path $env.AMBER_BIN

$env.DOCKER_BIN = ($env.USR_LOCAL_BIN | path join docker)
env-path $env.DOCKER_BIN

$env.VENTOY_PATH = ($env.USR_LOCAL_LIB | path join 'ventoy')

$env.NODE_PATH = ($env.USR_LOCAL_LIB | path join 'node')
$env.NODE_BIN = ($env.NODE_PATH | path join 'bin')
env-path $env.NODE_BIN

$env.GOROOT = ($env.USR_LOCAL_LIB | path join 'go')
$env.GOROOTBIN = ($env.GOROOT | path join 'bin')
env-path $env.GOROOTBIN

$env.VLANG_PATH = ($env.USR_LOCAL_LIB | path join 'v')
env-path $env.VLANG_PATH

$env.JAVA_PATH = ($env.USR_LOCAL_LIB | path join 'jdk')
$env.JAVA_BIN = ($env.JAVA_PATH | path join 'bin')
$env.JAVA_HOME = $env.JAVA_PATH
env-path $env.JAVA_BIN

$env.JDTLS_PATH = ($env.USR_LOCAL_LIB | path join 'jdtls')
$env.JDTLS_BIN = ($env.JDTLS_PATH | path join 'bin')
env-path $env.JDTLS_BIN

$env.KOTLIN_PATH = ($env.USR_LOCAL_LIB | path join 'kotlin')
$env.KOTLIN_BIN = ($env.KOTLIN_PATH | path join 'bin')
env-path $env.KOTLIN_BIN

$env.FVM_PATH = ($env.USR_LOCAL_LIB | path join 'fvm')
env-path $env.FVM_PATH

$env.FLUTTER_PATH = ($env.USR_LOCAL_LIB | path join 'flutter')
$env.FLUTTER_BIN = ($env.FLUTTER_PATH | path join 'bin')
env-path $env.FLUTTER_BIN

$env.DART_PATH = ($env.USR_LOCAL_LIB | path join 'dart-sdk')
$env.DART_BIN = ($env.DART_PATH | path join 'bin')
env-path $env.DART_BIN

$env.ANDORID_STUDIO_PATH = ($env.USR_LOCAL_LIB | path join 'android-studio')
$env.ANDROID_STUDIO_BIN = ($env.ANDORID_STUDIO_PATH | path join 'bin')
env-path $env.ANDROID_STUDIO_BIN

$env.BITCOIN_PATH = ($env.USR_LOCAL_LIB | path join 'bitcoin')
$env.BITCOIN_BIN = ($env.BITCOIN_PATH | path join 'bin')
env-path $env.BITCOIN_BIN

$env.LIGHTNING_PATH = ($env.USR_LOCAL_LIB | path join 'lightning')
env-path $env.LIGHTNING_PATH

$env.SCILAB_PATH = ($env.USR_LOCAL_LIB | path join 'scilab')
$env.SCILAB_BIN = ($env.SCILAB_PATH | path join 'bin')
env-path $env.SCILAB_BIN

$env.REMOTE_MOUSE_PATH = ($env.USR_LOCAL_LIB | path join 'remote-mouse')
$env.REMOTE_MOUSE_LIB = ($env.REMOTE_MOUSE_PATH | path join 'lib')
env-path $env.REMOTE_MOUSE_PATH

$env.GOPATH = ($env.HOME | path join '.go')
$env.GOBIN = ($env.GOPATH | path join 'bin')
env-path $env.GOBIN

$env.CARGOPATH = ($env.HOME | path join '.cargo')
$env.CARGOBIN = ($env.CARGOPATH | path join 'bin')
env-path $env.CARGOBIN

$env.GHCUPPATH = ($env.HOME | path join '.ghcup')
$env.GHCUPBIN = ($env.GHCUPPATH | path join 'bin')
env-path $env.GHCUPBIN

$env.LOCAL_PATH = ($env.HOME | path join '.local')
$env.LOCAL_BIN = ($env.LOCAL_PATH | path join 'bin')
$env.LOCAL_SHARE = ($env.LOCAL_PATH | path join 'share')
$env.LOCAL_SHARE_FONTS = ($env.LOCAL_SHARE | path join 'fonts')
$env.LOCAL_SHARE_APPLICATIONS = ($env.LOCAL_SHARE | path join 'applications')
env-path $env.LOCAL_BIN

$env.VOLTA_PATH = ($env.HOME | path join '.volta')
$env.VOLTA_BIN = ($env.VOLTA_PATH | path join 'bin')
env-path $env.VOLTA_BIN

$env.NPM_CONFIG_PREFIX = ($env.HOME | path join '.npm')
$env.NPM_CONFIG_BIN = ($env.NPM_CONFIG_PREFIX | path join 'bin')
env-path $env.NPM_CONFIG_BIN

$env.PIPX_HOME = ($env.HOME | path join '.pipx')
$env.PIPX_BIN_DIR = ($env.PIPX_HOME | path join 'bin')
env-path $env.PIPX_BIN_DIR

$env.ANDROID_HOME = ($env.HOME | path join 'Android' 'Sdk')

$env.ANDROID_PLATFORM_TOOLS = ($env.ANDROID_HOME | path join 'platform-tools')
env-path $env.ANDROID_PLATFORM_TOOLS

$env.ANDROID_CMDLINE_TOOLS_PATH = ($env.ANDROID_HOME | path join 'cmdline-tools' 'latest')
$env.ANDROID_CMDLINE_TOOLS_BIN = ($env.ANDROID_CMDLINE_TOOLS_PATH | path join 'bin')
env-path $env.ANDROID_CMDLINE_TOOLS_BIN

$env.EDITOR = 'hx'
$env.VISUAL = 'hx'
# $env.SHELL = ($env.USR_LOCAL_BIN | path join 'nu')
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.SOFT_SERVE_DATA_PATH = ($env.HOME | path join '.soft-server')

let admin_keys = ($env.HOME | path join .ssh/id_ed25519.pub)
if ($admin_keys | path exists) {
  $env.SOFT_SERVE_INITIAL_ADMIN_KEYS = (open $admin_keys)
}

$env.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable"

def --env env-path [path: string --prepend(-p)] {
  if ($path | path exists) {
    if ($path not-in $env.PATH) {
      if $prepend {
        $env.PATH = ($env.PATH | split row (char esep) | prepend $path)
      } else {
        $env.PATH = ($env.PATH | split row (char esep) | append $path)
      }
    }
  }
}
