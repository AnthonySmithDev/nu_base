
$env.REPO_PATH = ($env.HOME | path join 'nushell' 'nu_base')
if not ($env.REPO_PATH | path exists) {
  $env.REPO_PATH = ($env.HOME | path join '.local' 'nu_base')
}

$env.USR_LOCAL_LIB = ($env.HOME | path join '.local' 'usr' 'lib')
$env.USR_LOCAL_BIN = ($env.HOME | path join '.local' 'usr' 'bin')
$env.SHARE_FONTS_PATH = ($env.HOME | path join '.local' 'share' 'fonts')

env-path $env.USR_LOCAL_BIN

$env.HELIX_PATH = ($env.USR_LOCAL_LIB | path join 'helix')
$env.HELIX_RUNTIME = ($env.HELIX_PATH | path join 'runtime')
env-path $env.HELIX_PATH

$env.NODE_PATH = ($env.USR_LOCAL_LIB | path join 'node')
$env.NODE_BIN = ($env.NODE_PATH | path join 'bin')
env-path $env.NODE_BIN

$env.GOROOT = ($env.USR_LOCAL_LIB | path join 'go')
$env.GOROOTBIN = ($env.GOROOT | path join 'bin')
env-path $env.GOROOTBIN

$env.VLANG_PATH = ($env.USR_LOCAL_LIB | path join 'v')
env-path $env.VLANG_PATH

$env.JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
$env.JAVA_PATH = ($env.USR_LOCAL_LIB | path join 'jdk')
$env.JAVA_BIN = ($env.JAVA_PATH | path join 'bin')
env-path $env.JAVA_BIN

$env.JDTLS_PATH = ($env.USR_LOCAL_LIB | path join 'jdtls')
$env.JDTLS_BIN = ($env.JDTLS_PATH | path join 'bin')
env-path $env.JDTLS_BIN

$env.KOTLIN_PATH = ($env.USR_LOCAL_LIB | path join 'kotlin')
$env.KOTLIN_BIN = ($env.KOTLIN_PATH | path join 'bin')
env-path $env.KOTLIN_BIN

$env.FLUTTER_PATH = ($env.USR_LOCAL_LIB | path join 'flutter')
$env.FLUTTER_BIN = ($env.FLUTTER_PATH | path join 'bin')
env-path $env.FLUTTER_BIN

$env.DART_PATH = ($env.USR_LOCAL_LIB | path join 'dart-sdk')
$env.DART_BIN = ($env.DART_PATH | path join 'bin')
env-path $env.DART_BIN

$env.STUDIO_PATH = ($env.USR_LOCAL_LIB | path join 'studio')
$env.STUDIO_BIN = ($env.STUDIO_PATH | path join 'bin')
env-path $env.STUDIO_BIN

$env.BITCOIN_PATH = ($env.USR_LOCAL_LIB | path join 'bitcoin')
$env.BITCOIN_BIN = ($env.BITCOIN_PATH | path join 'bin')
env-path $env.BITCOIN_BIN

$env.LIGHTNING_PATH = ($env.USR_LOCAL_LIB | path join 'lightning')
$env.LIGHTNING_BIN = ($env.LIGHTNING_PATH | path join 'bin')
env-path $env.LIGHTNING_BIN

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

$env.LOCAL_PATH = ($env.HOME | path join '.local')
$env.LOCAL_BIN = ($env.LOCAL_PATH | path join 'bin')
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
$env.PLATFORM_TOOLS = ($env.ANDROID_HOME | path join 'platform-tools')
env-path $env.PLATFORM_TOOLS

$env.CMDLINE_TOOLS = ($env.ANDROID_HOME | path join 'cmdline-tools' 'latest')
$env.CMDLINE_TOOLS_BIN = ($env.CMDLINE_TOOLS | path join 'bin')
env-path $env.CMDLINE_TOOLS_BIN

$env.SHELL = ($env.USR_LOCAL_BIN | path join 'nu')
$env.EDITOR = ($env.HELIX_PATH | path join 'hx')
$env.VISUAL = ($env.HELIX_PATH | path join 'hx')
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"

def --env env-path [path: string] {
  if ($path | path exists) {
    if ($path not-in $env.PATH) {
      $env.PATH = ($env.PATH | split row (char esep) | append $path)
    }
  }
}
