
$env.NU_BASE_PATH = ($env.HOME | path join nushell nu_base)
if not ($env.NU_BASE_PATH | path exists) {
  $env.NU_BASE_PATH = ($env.HOME | path join .local nu_base)
}

let COLUMNS = (term size | get columns | math floor) - 2
if $COLUMNS > 100 {
  $env.MODS_WORD_WRAP = 100 - 2
} else {
  $env.MODS_WORD_WRAP = $COLUMNS
}

$env.NU_BASE_FILES = ($env.NU_BASE_PATH | path join files)

$env.CONFIG_DIR_REPO = ($env.NU_BASE_FILES | path join config)
$env.CONFIG_DIR_USER = ($env.HOME | path join .config)
$env.CONFIG_DIR_ROOT = ('/root' | path join .config)

$env.SCRIPT_DIR_SRC = ($env.NU_BASE_FILES | path join script)
$env.SCRIPT_DIR_DST = ($env.HOME | path join nu)

$env.CONFIG_SYSTEMD_USER_SRC = ($env.CONFIG_DIR_REPO | path join systemd/user)
$env.CONFIG_SYSTEMD_USER_DST = ($env.CONFIG_DIR_USER | path join systemd/user)

$env.SYS_LOCAL = "/usr/local"
$env.SYS_LOCAL_BIN = ($env.SYS_LOCAL | path join bin)

$env.USR_LOCAL = ($env.HOME | path join .usr local)
$env.USR_LOCAL_BIN = ($env.USR_LOCAL | path join bin)
$env.USR_LOCAL_LIB = ($env.USR_LOCAL | path join lib)
$env.USR_LOCAL_SHARE = ($env.USR_LOCAL | path join share)
$env.USR_LOCAL_SOURCE = ($env.USR_LOCAL | path join source)
env-path -p $env.USR_LOCAL_BIN

$env.USR_LOCAL_DOWN = ($env.USR_LOCAL | path join down)
$env.USR_LOCAL_APK = ($env.USR_LOCAL_DOWN | path join apk)
$env.USR_LOCAL_DEB = ($env.USR_LOCAL_DOWN | path join deb)
$env.USR_LOCAL_FONT = ($env.USR_LOCAL_DOWN | path join font)

$env.USR_LOCAL_SHARE_BIN = ($env.USR_LOCAL_SHARE | path join bin)
$env.USR_LOCAL_SHARE_LIB = ($env.USR_LOCAL_SHARE | path join lib)
$env.USR_LOCAL_SHARE_BUILD = ($env.USR_LOCAL_SHARE | path join build)
$env.USR_LOCAL_SHARE_APP_IMAGE = ($env.USR_LOCAL_SHARE | path join appimage)

$env.NUSHELL_BIN = ($env.USR_LOCAL_LIB | path join nushell)
env-path $env.NUSHELL_BIN

$env.HELIX_PATH = ($env.USR_LOCAL_LIB | path join helix)
$env.HELIX_RUNTIME = ($env.HELIX_PATH | path join runtime)
$env.HELIX_DEFAULT_RUNTIME = ($env.HELIX_PATH | path join runtime)

$env.NVIM_PATH = ($env.USR_LOCAL_LIB | path join nvim)
$env.NVIM_BIN = ($env.NVIM_PATH | path join bin)
env-path $env.NVIM_BIN

$env.SFTPGO_PATH = ($env.USR_LOCAL_LIB | path join sftpgo)
env-path $env.SFTPGO_PATH

$env.VSCODIUM_PATH = ($env.USR_LOCAL_LIB | path join vscodium)
$env.VSCODIUM_BIN = ($env.VSCODIUM_PATH | path join bin)
env-path $env.VSCODIUM_BIN

$env.CODE_SERVER_PATH = ($env.USR_LOCAL_LIB | path join code-server)
$env.CODE_SERVER_BIN = ($env.CODE_SERVER_PATH | path join bin)
env-path $env.CODE_SERVER_BIN

$env.SCRCPY_BIN = ($env.USR_LOCAL_LIB | path join scrcpy)
env-path $env.SCRCPY_BIN

$env.MITMPROXY_BIN = ($env.USR_LOCAL_LIB | path join mitmproxy)
env-path $env.MITMPROXY_BIN

$env.SSHX_BIN = ($env.USR_LOCAL_LIB | path join sshx)
env-path $env.SSHX_BIN

$env.AMBER_BIN = ($env.USR_LOCAL_LIB | path join amber)
env-path $env.AMBER_BIN

$env.RINGBOARD_BIN = ($env.USR_LOCAL_LIB | path join ringboard)
env-path $env.RINGBOARD_BIN

$env.UV_BIN = ($env.USR_LOCAL_LIB | path join uv)
env-path $env.UV_BIN

$env.CARGO_BINSTALL_BIN = ($env.USR_LOCAL_LIB | path join cargo-binstall)
env-path $env.CARGO_BINSTALL_BIN

$env.CARBONYL_BIN = ($env.USR_LOCAL_LIB | path join carbonyl)
env-path $env.CARBONYL_BIN

$env.MONGOSH_PATH = ($env.USR_LOCAL_LIB | path join mongosh)
$env.MONGOSH_BIN = ($env.MONGOSH_PATH | path join bin)
env-path $env.MONGOSH_BIN

$env.DOCKER_BIN = ($env.USR_LOCAL_LIB | path join docker)
env-path $env.DOCKER_BIN

$env.VENTOY_PATH = ($env.USR_LOCAL_LIB | path join ventoy)

$env.OLLAMA_PATH = ($env.USR_LOCAL_LIB | path join ollama)
$env.OLLAMA_BIN = ($env.OLLAMA_PATH | path join bin)
env-path $env.OLLAMA_BIN

$env.GITOXIDE_BIN = ($env.USR_LOCAL_LIB | path join gitoxide)
env-path $env.GITOXIDE_BIN

$env.YAZI_BIN = ($env.USR_LOCAL_LIB | path join yazi)
env-path $env.YAZI_BIN

$env.DENO_PATH = ($env.HOME | path join .deno)
$env.DENO_BIN = ($env.DENO_PATH | path join bin)
env-path $env.DENO_BIN

$env.NODE_PATH = ($env.USR_LOCAL_LIB | path join node)
$env.NODE_BIN = ($env.NODE_PATH | path join bin)
env-path $env.NODE_BIN

$env.LUA_LSP_PATH = ($env.USR_LOCAL_LIB | path join lua-lsp)
$env.LUA_LSP_BIN = ($env.LUA_LSP_PATH | path join bin)
env-path $env.LUA_LSP_BIN

$env.GOROOT = ($env.USR_LOCAL_LIB | path join go)
$env.GOROOTBIN = ($env.GOROOT | path join bin)
env-path $env.GOROOTBIN

$env.ZIG_PATH = ($env.USR_LOCAL_LIB | path join zig)
env-path $env.ZIG_PATH

$env.VLANG_PATH = ($env.USR_LOCAL_LIB | path join v)
env-path $env.VLANG_PATH

$env.JAVA_PATH = ($env.USR_LOCAL_LIB | path join jdk)
$env.JAVA_BIN = ($env.JAVA_PATH | path join bin)
$env.JAVA_HOME = $env.JAVA_PATH
env-path $env.JAVA_BIN

$env.JDTLS_PATH = ($env.USR_LOCAL_LIB | path join jdtls)
$env.JDTLS_BIN = ($env.JDTLS_PATH | path join bin)
env-path $env.JDTLS_BIN

$env.KOTLIN_PATH = ($env.USR_LOCAL_LIB | path join kotlin)
$env.KOTLIN_BIN = ($env.KOTLIN_PATH | path join bin)
env-path $env.KOTLIN_BIN

$env.KOTLIN_NATIVE_PATH = ($env.USR_LOCAL_LIB | path join kotlin-native)
$env.KOTLIN_NATIVE_BIN = ($env.KOTLIN_NATIVE_PATH | path join bin)
env-path $env.KOTLIN_NATIVE_BIN

$env.KOTLIN_LSP_PATH = ($env.USR_LOCAL_LIB | path join kotlin-language-server)
$env.KOTLIN_LSP_BIN = ($env.KOTLIN_LSP_PATH | path join bin)
env-path $env.KOTLIN_LSP_BIN

$env.FVM_PATH = ($env.USR_LOCAL_LIB | path join fvm)
env-path $env.FVM_PATH

$env.VOLTA_PATH = ($env.USR_LOCAL_LIB | path join volta)
env-path $env.VOLTA_PATH

$env.PNPM_HOME = ($env.HOME | path join .pnpm)
env-path $env.PNPM_HOME

$env.FLUTTER_PATH = ($env.USR_LOCAL_LIB | path join flutter)
$env.FLUTTER_BIN = ($env.FLUTTER_PATH | path join bin)
env-path $env.FLUTTER_BIN

$env.DART_PATH = ($env.USR_LOCAL_LIB | path join dart-sdk)
$env.DART_BIN = ($env.DART_PATH | path join bin)
env-path $env.DART_BIN

$env.ANDORID_STUDIO_PATH = ($env.USR_LOCAL_LIB | path join android-studio)
$env.ANDROID_STUDIO_BIN = ($env.ANDORID_STUDIO_PATH | path join bin)
env-path $env.ANDROID_STUDIO_BIN

$env.BITCOIN_PATH = ($env.USR_LOCAL_LIB | path join bitcoin)
$env.BITCOIN_BIN = ($env.BITCOIN_PATH | path join bin)
env-path $env.BITCOIN_BIN

$env.BTCD_PATH = ($env.USR_LOCAL_LIB | path join btcd)
env-path $env.BTCD_PATH

$env.AST_GREP_BIN = ($env.USR_LOCAL_LIB | path join ast-grep)
env-path $env.AST_GREP_BIN

$env.LIGHTNING_PATH = ($env.USR_LOCAL_LIB | path join lightning)
env-path $env.LIGHTNING_PATH

$env.SCILAB_PATH = ($env.USR_LOCAL_LIB | path join scilab)
$env.SCILAB_BIN = ($env.SCILAB_PATH | path join bin)
env-path $env.SCILAB_BIN

$env.REMOTE_MOUSE_PATH = ($env.USR_LOCAL_LIB | path join remote-mouse)
# $env.REMOTE_MOUSE_LIB = ($env.REMOTE_MOUSE_PATH | path join lib)

$env.LOCAL_PATH = ($env.HOME | path join .local)
$env.LOCAL_BIN = ($env.LOCAL_PATH | path join bin)
$env.LOCAL_SHARE = ($env.LOCAL_PATH | path join share)
$env.LOCAL_SHARE_FONTS = ($env.LOCAL_SHARE | path join fonts)
$env.LOCAL_SHARE_APPLICATIONS = ($env.LOCAL_SHARE | path join applications)
env-path $env.LOCAL_BIN

$env.GOPATH = ($env.HOME | path join .go)
$env.GOBIN = ($env.GOPATH | path join bin)
env-path $env.GOBIN

$env.CARGOPATH = ($env.HOME | path join .cargo)
$env.CARGOBIN = ($env.CARGOPATH | path join bin)
env-path $env.CARGOBIN

$env.GHCUPPATH = ($env.HOME | path join .ghcup)
$env.GHCUPBIN = ($env.GHCUPPATH | path join bin)
env-path $env.GHCUPBIN

$env.VOLTA_PATH = ($env.HOME | path join .volta)
$env.VOLTA_BIN = ($env.VOLTA_PATH | path join bin)
env-path $env.VOLTA_BIN

$env.NPM_CONFIG_PREFIX = ($env.HOME | path join .npm)
$env.NPM_CONFIG_BIN = ($env.NPM_CONFIG_PREFIX | path join bin)
env-path $env.NPM_CONFIG_BIN

$env.PIPX_HOME = ($env.HOME | path join .pipx)
$env.PIPX_BIN_DIR = ($env.PIPX_HOME | path join bin)
env-path $env.PIPX_BIN_DIR

$env.DOTNET_ROOT = ($env.HOME | path join .dotnet)
$env.DOTNET_CLI_TELEMETRY_OPTOUT = false
env-path $env.DOTNET_ROOT

$env.ANDROID_HOME = ($env.HOME | path join Android Sdk)
$env.ANDROID_SDK_ROOT = ($env.HOME | path join Android Sdk)

$env.ANDROID_EMULATOR = ($env.ANDROID_HOME | path join emulator)
env-path $env.ANDROID_EMULATOR

$env.ANDROID_PLATFORM_TOOLS = ($env.ANDROID_HOME | path join platform-tools)
env-path $env.ANDROID_PLATFORM_TOOLS

$env.ANDROID_CMDLINE_TOOLS = ($env.ANDROID_HOME | path join cmdline-tools latest)
$env.ANDROID_CMDLINE_TOOLS_BIN = ($env.ANDROID_CMDLINE_TOOLS | path join bin)
env-path $env.ANDROID_CMDLINE_TOOLS_BIN

$env.EDITOR = 'hx'
$env.VISUAL = 'hx'
# $env.SHELL = ($env.USR_LOCAL_BIN | path join 'nu')
# $env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
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
