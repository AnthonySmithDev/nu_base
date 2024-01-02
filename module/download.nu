
use github.nu

export def gum [] {
  let version = github get_version 'charmbracelet/gum'

  http download $'https://github.com/charmbracelet/gum/releases/download/v($version)/gum_($version)_Linux_x86_64.tar.gz'
  extract tar $'gum_($version)_Linux_x86_64.tar.gz' -d 'gum_Linux_x86_64'
  move -d 'gum_Linux_x86_64' 'gum'
}

export def mods [] {
  let version = github get_version 'charmbracelet/mods'

  http download $'https://github.com/charmbracelet/mods/releases/download/v($version)/mods_($version)_Linux_x86_64.tar.gz'
  extract tar $'mods_($version)_Linux_x86_64.tar.gz' -d 'mods_Linux_x86_64'
  move -d 'mods_Linux_x86_64' 'mods'
}

export def glow [] {
  let version = github get_version 'charmbracelet/glow'

  http download $'https://github.com/charmbracelet/glow/releases/download/v($version)/glow_Linux_x86_64.tar.gz'
  extract tar 'glow_Linux_x86_64.tar.gz' -d 'glow_Linux_x86_64'
  move -d 'glow_Linux_x86_64' 'glow'
}

export def soft [] {
  let version = github get_version 'charmbracelet/soft-serve'

  http download $'https://github.com/charmbracelet/soft-serve/releases/download/v($version)/soft-serve_($version)_Linux_x86_64.tar.gz'
  extract tar $'soft-serve_($version)_Linux_x86_64.tar.gz' -d 'soft-serve_Linux_x86_64'
  move -d 'soft-serve_Linux_x86_64' 'soft'
}

export def vhs [] {
  let version = github get_version 'charmbracelet/vhs'

  http download https://github.com/charmbracelet/vhs/releases/download/v($version)/vhs_($version)_Linux_x86_64.tar.gz
  extract tar vhs_($version)_Linux_x86_64.tar.gz -d 'vhs_linux_x86_64'
  move -d 'vhs_linux_x86_64' 'vhs'
}

export def helix [
  --global
  --editor
] {
  let version = github get_version 'helix-editor/helix'

  let path = share helix $version
  if not ($path | path exists) {
    http download $'https://github.com/helix-editor/helix/releases/download/($version)/helix-($version)-x86_64-linux.tar.xz'
    extract tar $'helix-($version)-x86_64-linux.tar.xz'
    mv -f $'helix-($version)-x86_64-linux' $path
  }

  symlink $path $env.HELIX_PATH

  if $global {
    sudo ln -sf ($env.HELIX_PATH | path join hx) /usr/bin/hx
  }
  if $editor {
    sudo ln -sf ($env.HELIX_PATH | path join hx) /usr/bin/editor
  }
}

export def nushell [--global] {
  let version = github get_version 'nushell/nushell'

  http download $'https://github.com/nushell/nushell/releases/download/($version)/nu-($version)-x86_64-linux-gnu-full.tar.gz'
  extract tar $'nu-($version)-x86_64-linux-gnu-full.tar.gz'
  move -d $'nu-($version)-x86_64-linux-gnu-full' 'nu'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join nu) /usr/bin/nu
  }
}

export def starship [--global] {
  let version = github get_version 'starship/starship'

  http download $'https://github.com/starship/starship/releases/download/v($version)/starship-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'starship-x86_64-unknown-linux-gnu.tar.gz'
  move 'starship'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join starship) /usr/bin/starship
  }
}

export def zoxide [--global] {
  let version = github get_version 'ajeetdsouza/zoxide'

  http download $'https://github.com/ajeetdsouza/zoxide/releases/download/v($version)/zoxide-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'zoxide-($version)-x86_64-unknown-linux-musl.tar.gz' -d 'zoxide-x86_64-unknown-linux-musl'
  move -d 'zoxide-x86_64-unknown-linux-musl' 'zoxide'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join zoxide) /usr/bin/zoxide
  }
}

export def zellij [--global] {
  let version = github get_version 'zellij-org/zellij'

  http download $'https://github.com/zellij-org/zellij/releases/download/v($version)/zellij-x86_64-unknown-linux-musl.tar.gz'
  extract tar 'zellij-x86_64-unknown-linux-musl.tar.gz'
  move 'zellij'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join zellij) /usr/bin/zellij
  }
}

export def rg [--global] {
  let version = github get_version 'BurntSushi/ripgrep'

  http download $'https://github.com/BurntSushi/ripgrep/releases/download/($version)/ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'ripgrep-($version)-x86_64-unknown-linux-musl' 'rg'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join rg) /usr/bin/rg
  }
}

export def fd [--global] {
  let version = github get_version 'sharkdp/fd'

  http download $'https://github.com/sharkdp/fd/releases/download/v($version)/fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'fd-v($version)-x86_64-unknown-linux-gnu' 'fd'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join fd) /usr/bin/fd
  }
}

export def fzf [] {
  let version = github get_version 'junegunn/fzf'

  http download $'https://github.com/junegunn/fzf/releases/download/($version)/fzf-($version)-linux_amd64.tar.gz'
  extract tar $'fzf-($version)-linux_amd64.tar.gz' -d 'fzf-linux_amd64'
  move -d 'fzf-linux_amd64' 'fzf'
}

export def broot [] {
  let version = github get_version 'Canop/broot'

  http download https://github.com/Canop/broot/releases/download/v($version)/broot_($version).zip
  extract zip broot_($version).zip -d 'broot'
  move -d 'broot' 'x86_64-linux/broot'
}

export def bat [] {
  let version = github get_version 'sharkdp/bat'

  http download $'https://github.com/sharkdp/bat/releases/download/v($version)/bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'bat-v($version)-x86_64-unknown-linux-gnu' 'bat'
}

export def gdu [--global] {
  let version = github get_version 'dundee/gdu'

  http download $'https://github.com/dundee/gdu/releases/download/v($version)/gdu_linux_amd64.tgz'
  extract tar 'gdu_linux_amd64.tgz'
  move 'gdu_linux_amd64' --rn 'gdu'

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join gdu) /usr/bin/gdu
  }
}

export def xh [] {
  let version = github get_version 'ducaale/xh'

  http download $'https://github.com/ducaale/xh/releases/download/v($version)/xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'xh-v($version)-x86_64-unknown-linux-musl' 'xh'
}

export def amber [] {
  let version = github get_version 'dalance/amber'

  http download $'https://github.com/dalance/amber/releases/download/v($version)/amber-v($version)-x86_64-lnx.zip'
  extract zip $'amber-v($version)-x86_64-lnx.zip' -d 'amber-x86_64-lnx'
  move -d 'amber-x86_64-lnx' '*'
}

export def lazygit [] {
  let version = github get_version 'jesseduffield/lazygit'

  http download $'https://github.com/jesseduffield/lazygit/releases/download/v($version)/lazygit_($version)_Linux_x86_64.tar.gz'
  extract tar $'lazygit_($version)_Linux_x86_64.tar.gz' -d 'lazygit_Linux_x86_64'
  move -d 'lazygit_Linux_x86_64' 'lazygit'
}

export def lazydocker [] {
  let version = github get_version 'jesseduffield/lazydocker'

  http download $'https://github.com/jesseduffield/lazydocker/releases/download/v($version)/lazydocker_($version)_Linux_x86_64.tar.gz'
  extract tar $'lazydocker_($version)_Linux_x86_64.tar.gz' -d 'lazydocker_Linux_x86_64'
  move -d 'lazydocker_Linux_x86_64' 'lazydocker'
}

export def jless [] {
  let version = github get_version 'PaulJuliusMartinez/jless'

  http download $'https://github.com/PaulJuliusMartinez/jless/releases/download/v($version)/jless-v($version)-x86_64-unknown-linux-gnu.zip'
  extract zip $'jless-v($version)-x86_64-unknown-linux-gnu.zip' -d 'jless-x86_64-unknown-linux-gnu'
  move -d 'jless-x86_64-unknown-linux-gnu' 'jless'
}

export def pueue [] {
  let version = github get_version 'Nukesor/pueue'

  http download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueue-linux-x86_64' -o pueue
  chmod +x pueue
  move pueue

  http download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueued-linux-x86_64' -o pueued
  chmod +x pueued
  move pueued
}

export def delta [] {
  let version = github get_version 'dandavison/delta'

  http download $'https://github.com/dandavison/delta/releases/download/($version)/delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'delta-($version)-x86_64-unknown-linux-gnu' 'delta'
}

export def bottom [] {
  let version = github get_version 'ClementTsang/bottom'

  http download $'https://github.com/ClementTsang/bottom/releases/download/($version)/bottom_x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'bottom_x86_64-unknown-linux-gnu.tar.gz' -d 'bottom_x86_64-unknown-linux-gnu'
  move -d 'bottom_x86_64-unknown-linux-gnu' 'btm'
}

export def ttyper [] {
  let version = github get_version 'max-niederman/ttyper'

  http download $'https://github.com/max-niederman/ttyper/releases/download/v($version)/ttyper-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'ttyper-x86_64-unknown-linux-gnu.tar.gz' -d 'ttyper-x86_64-unknown-linux-gnu'
  move -d 'ttyper-x86_64-unknown-linux-gnu' 'ttyper'
}

export def qrcp [] {
  let version = github get_version 'claudiodangelis/qrcp'

  http download $'https://github.com/claudiodangelis/qrcp/releases/download/($version)/qrcp_($version)_linux_amd64.tar.gz'
  extract tar $'qrcp_($version)_linux_amd64.tar.gz' -d 'qrcp_linux_amd64'
  move -d 'qrcp_linux_amd64' 'qrcp'
}

export def usql [] {
  let version = github get_version 'xo/usql'

  http download $'https://github.com/xo/usql/releases/download/v($version)/usql-($version)-linux-amd64.tar.bz2'
  extract tar $'usql-($version)-linux-amd64.tar.bz2' -d 'usql-linux-amd64'
  move -d 'usql-linux-amd64' 'usql'
}

export def gotty [] {
  let version = github get_version 'yudai/gotty'

  http download $'https://github.com/yudai/gotty/releases/download/v($version)/gotty_linux_amd64.tar.gz'
  extract tar gotty_linux_amd64.tar.gz
  move gotty
}

export def ttyd [] {
  let version = github get_version 'tsl0922/ttyd'

  http download https://github.com/tsl0922/ttyd/releases/download/($version)/ttyd.x86_64 -o ttyd
  chmod +x ttyd
  move ttyd
}

export def tty-share [] {
  let version = github get_version 'elisescu/tty-share'

  http download $'https://github.com/elisescu/tty-share/releases/download/v($version)/tty-share_linux-amd64' -o tty-share
  chmod +x tty-share
  move tty-share
}

export def upterm [] {
  let version = github get_version 'owenthereal/upterm'

  http download $'https://github.com/owenthereal/upterm/releases/download/v($version)/upterm_linux_amd64.tar.gz'
  extract tar 'upterm_linux_amd64.tar.gz' -d 'upterm_linux_amd64'
  move -d 'upterm_linux_amd64' 'upterm'
}

export def shell2http [] {
  let version = github get_version 'msoap/shell2http'

  http download $'https://github.com/msoap/shell2http/releases/download/v($version)/shell2http_($version)_linux_amd64.tar.gz'
  extract tar $'shell2http_($version)_linux_amd64.tar.gz' -d 'shell2http_linux_amd64'
  move -d 'shell2http_linux_amd64' 'shell2http'
}

export def mprocs [] {
  let version = github get_version 'pvolok/mprocs'

  http download $'https://github.com/pvolok/mprocs/releases/download/v($version)/mprocs-($version)-linux64.tar.gz'
  extract tar $'mprocs-($version)-linux64.tar.gz'
  move 'mprocs'
}

export def dua [] {
  let version = github get_version 'Byron/dua-cli'

  http download $'https://github.com/Byron/dua-cli/releases/download/v($version)/dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'dua-v($version)-x86_64-unknown-linux-musl' 'dua'
}

export def grex [] {
  let version = github get_version 'pemistahl/grex'

  http download $'https://github.com/pemistahl/grex/releases/download/v($version)/grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move 'grex'
}

export def navi [] {
  let version = github get_version 'denisidoro/navi'

  http download $'https://github.com/denisidoro/navi/releases/download/v($version)/navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move 'navi'
}

export def rclone [] {
  let version = github get_version 'rclone/rclone'

  http download $'https://github.com/rclone/rclone/releases/download/v($version)/rclone-v($version)-linux-amd64.zip'
  extract zip $'rclone-v($version)-linux-amd64.zip'
  move -d $'rclone-v($version)-linux-amd64' 'rclone'
}

export def ffsend [] {
  let version = github get_version 'timvisee/ffsend'

  http download $'https://github.com/timvisee/ffsend/releases/download/v($version)/ffsend-v($version)-linux-x64-static' -o ffsend
  chmod +x ffsend
  move 'ffsend'
}

export def walk [] {
  let version = github get_version 'antonmedv/walk'

  http download $'https://github.com/antonmedv/walk/releases/download/v($version)/walk_linux_amd64' -o walk
  chmod +x walk
  move 'walk'
}

export def tere [] {
  let version = github get_version 'mgunyho/tere'

  http download $'https://github.com/mgunyho/tere/releases/download/v($version)/tere-($version)-x86_64-unknown-linux-gnu.zip'
  extract zip $'tere-($version)-x86_64-unknown-linux-gnu.zip'
  move 'tere'
}

export def sd [] {
  let version = github get_version 'chmln/sd'

  http download $'https://github.com/chmln/sd/releases/download/v($version)/sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'sd-v($version)-x86_64-unknown-linux-gnu' 'sd'
}

export def sad [] {
  let version = github get_version 'ms-jpq/sad'

  http download $'https://github.com/ms-jpq/sad/releases/download/v($version)/x86_64-unknown-linux-gnu.zip'
  extract zip 'x86_64-unknown-linux-gnu.zip'
  move 'sad'
}

export def fx [] {
  let version = github get_version 'antonmedv/fx'

  http download $'https://github.com/antonmedv/fx/releases/download/($version)/fx_linux_amd64' -o fx
  chmod +x fx
  move 'fx'
}

export def lux [] {
  let version = github get_version 'iawia002/lux'

  http download $'https://github.com/iawia002/lux/releases/download/v($version)/lux_($version)_Linux_x86_64.tar.gz'
  extract tar $'lux_($version)_Linux_x86_64.tar.gz'
  move lux
}

export def qrterminal [] {
  let version = github get_version 'mdp/qrterminal'

  http download https://github.com/mdp/qrterminal/releases/download/v($version)/qrterminal_Linux_x86_64.tar.gz
  extract tar qrterminal_Linux_x86_64.tar.gz -d qrterminal_Linux_x86_64
  move -d qrterminal_Linux_x86_64 qrterminal
}

export def genact [] {
  let version = github get_version 'svenstaro/genact'

  http download $'https://github.com/svenstaro/genact/releases/download/v($version)/genact-($version)-x86_64-unknown-linux-gnu' -o genact
  chmod +x genact
  move genact
}

export def ouch [] {
  let version = github get_version 'ouch-org/ouch'

  http download $'https://github.com/ouch-org/ouch/releases/download/($version)/ouch-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'ouch-x86_64-unknown-linux-gnu.tar.gz'
  move -d 'ouch-x86_64-unknown-linux-gnu' 'ouch'
}

export def lsd [] {
  let version = github get_version 'lsd-rs/lsd'

  http download $'https://github.com/lsd-rs/lsd/releases/download/v($version)/lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'lsd-v($version)-x86_64-unknown-linux-gnu' 'lsd'
}

export def mdcat [] {
  let version = github get_version 'swsnr/mdcat'

  http download $'https://github.com/swsnr/mdcat/releases/download/mdcat-($version)/mdcat-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'mdcat-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'mdcat-($version)-x86_64-unknown-linux-musl' 'mdcat'
}

export def chatgpt [] {
  let version = github get_version 'j178/chatgpt'

  http download $'https://github.com/j178/chatgpt/releases/download/v($version)/chatgpt_Linux_x86_64.tar.gz'
  extract tar 'chatgpt_Linux_x86_64.tar.gz' -d 'chatgpt_Linux_x86_64'
  move -d 'chatgpt_Linux_x86_64' 'chatgpt'
}

export def tgpt [] {
  http download https://github.com/aandrew-me/tgpt/releases/download/v2.2.1/tgpt-linux-amd64 -o tgpt
  chmod +x tgpt
  move tgpt
}

export def silicon [] {
  let version = github get_version 'Aloxaf/silicon'

  http download $'https://github.com/Aloxaf/silicon/releases/download/v($version)/silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move 'silicon'
}

export def nap [] {
  let version = github get_version 'maaslalani/nap'

  http download $'https://github.com/maaslalani/nap/releases/download/v($version)/nap_($version)_linux_amd64.tar.gz'
  extract tar $'nap_($version)_linux_amd64.tar.gz' -d 'nap_linux_amd64'
  move -d 'nap_linux_amd64' 'nap'
}

export def clangd [] {
  let version = github get_version 'clangd/clangd'

  http download $'https://github.com/clangd/clangd/releases/download/($version)/clangd-linux-($version).zip'
  extract zip $'clangd-linux-($version).zip'
  move -d $'clangd_($version)' 'bin/clangd'
}

export def coreutils [] {
  let version = github get_version 'uutils/coreutils'

  http download $'https://github.com/uutils/coreutils/releases/download/($version)/coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'coreutils-($version)-x86_64-unknown-linux-musl' 'coreutils'
}

export def carapace [] {
  let version = github get_version 'rsteube/carapace-bin'

  http download $'https://github.com/rsteube/carapace-bin/releases/download/v($version)/carapace-bin_linux_amd64.tar.gz'
  extract tar 'carapace-bin_linux_amd64.tar.gz' -d 'carapace-bin_linux_amd64'
  move -d 'carapace-bin_linux_amd64' 'carapace'
}

export def bombardier [] {
  let version = github get_version 'codesenberg/bombardier'

  http download $'https://github.com/codesenberg/bombardier/releases/download/v($version)/bombardier-linux-amd64' -o bombardier
  chmod +x bombardier
  move 'bombardier'
}

export def ruff [] {
  let version = github get_version 'astral-sh/ruff'

  http download https://github.com/astral-sh/ruff/releases/download/v($version)/ruff-x86_64-unknown-linux-gnu.tar.gz
  extract tar ruff-x86_64-unknown-linux-gnu.tar.gz
  move 'ruff'
}

export def micro [] {
  let version = github get_version 'zyedidia/micro'

  http download $'https://github.com/zyedidia/micro/releases/download/v($version)/micro-($version)-linux64.tar.gz'
  extract tar $'micro-($version)-linux64.tar.gz'
  move -d $'micro-($version)' micro
}

export def dufs [] {
  let version = github get_version 'sigoden/dufs'

  http download $'https://github.com/sigoden/dufs/releases/download/v($version)/dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move dufs
}

export def miniserve [] {
  let version = github get_version 'svenstaro/miniserve'

  http download $'https://github.com/svenstaro/miniserve/releases/download/v($version)/miniserve-($version)-x86_64-unknown-linux-gnu' -o miniserve
  chmod +x miniserve
  move miniserve
}

export def onefetch [] {
  let version = github get_version 'o2sh/onefetch'

  http download $'https://github.com/o2sh/onefetch/releases/download/($version)/onefetch-linux.tar.gz'
  extract tar onefetch-linux.tar.gz
  move onefetch
}

export def gping [] {
  let version = github get_version 'orf/gping'

  http download $'https://github.com/orf/gping/releases/download/gping-v($version)/gping-x86_64-unknown-linux-musl.tar.gz'
  extract tar gping-x86_64-unknown-linux-musl.tar.gz
  move gping
}

export def duf [] {
  let version = github get_version 'muesli/duf'

  http download https://github.com/muesli/duf/releases/download/v($version)/duf_($version)_linux_x86_64.tar.gz
  extract tar duf_($version)_linux_x86_64.tar.gz -d duf_linux_x86_64
  move -d duf_linux_x86_64 duf
}

export def gh [] {
  let version = github get_version 'cli/cli'

  http download https://github.com/cli/cli/releases/download/v($version)/gh_($version)_linux_amd64.tar.gz
  extract tar gh_($version)_linux_amd64.tar.gz
  move -d gh_($version)_linux_amd64 bin/gh
}

export def dive [] {
  let version = github get_version 'wagoodman/dive'

  http download https://github.com/wagoodman/dive/releases/download/v($version)/dive_($version)_linux_amd64.tar.gz
  extract tar dive_($version)_linux_amd64.tar.gz -d dive_linux_amd64
  move -d dive_linux_amd64 dive
}

export def hyperfine [] {
  let version = github get_version 'sharkdp/hyperfine'

  http download $'https://github.com/sharkdp/hyperfine/releases/download/v($version)/hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'hyperfine-v($version)-x86_64-unknown-linux-gnu' hyperfine
}

export def taskell [] {
  let version = github get_version 'smallhadroncollider/taskell'

  http download $'https://github.com/smallhadroncollider/taskell/releases/download/($version)/taskell-($version)_x86-64-linux.tar.gz'
  extract tar $'taskell-($version)_x86-64-linux.tar.gz'
  move taskell
}

export def bettercap [--global] {
  let version = github get_version 'bettercap/bettercap'

  http download $'https://github.com/bettercap/bettercap/releases/download/v($version)/bettercap_linux_amd64_v($version).zip'
  extract zip $'bettercap_linux_amd64_v($version).zip' -d bettercap_linux_amd64
  move -d bettercap_linux_amd64 bettercap

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join bettercap) /usr/bin/bettercap
  }
}

export def viddy [] {
  let version = github get_version 'sachaos/viddy'

  http download $'https://github.com/sachaos/viddy/releases/download/v($version)/viddy_Linux_x86_64.tar.gz'
  extract tar viddy_Linux_x86_64.tar.gz -d viddy_Linux_x86_64
  move -d viddy_Linux_x86_64 viddy
}

export def yazi [] {
  let version = github get_version 'sxyazi/yazi'

  http download $'https://github.com/sxyazi/yazi/releases/download/v($version)/yazi-x86_64-unknown-linux-gnu.zip'
  extract zip yazi-x86_64-unknown-linux-gnu.zip
  move -d yazi-x86_64-unknown-linux-gnu yazi
}

export def kmon [] {
  let version = github get_version 'orhun/kmon'

  http download $'https://github.com/orhun/kmon/releases/download/v($version)/kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'kmon-($version)' kmon
}

export def ollama [] {
  let version = github get_version 'jmorganca/ollama'

  http download https://github.com/jmorganca/ollama/releases/download/v($version)/ollama-linux-amd64 -o ollama
  chmod +x ollama
  move ollama
}

export def localAI [] {
  let version = github get_version 'mudler/LocalAI'

  http download https://github.com/mudler/LocalAI/releases/download/v($version)/local-ai-avx-Linux-x86_64 -o local-ai
  chmod +x local-ai
  move local-ai
}

export def volta [--node] {
  let version = github get_version 'volta-cli/volta'

  http download $'https://github.com/volta-cli/volta/releases/download/v($version)/volta-($version)-linux.tar.gz'
  extract tar $'volta-($version)-linux.tar.gz' -d 'volta-linux'
  move -d $'volta-($version)-linux' '*'

  if $node {
    ^volta install node@latest
  }
}

export def fvm [] {
  let version = github get_version 'leoafarias/fvm'

  let path = share fvm $version
  if not ($path | path exists) {
    http download $'https://github.com/leoafarias/fvm/releases/download/($version)/fvm-($version)-linux-x64.tar.gz'
    extract tar $'fvm-($version)-linux-x64.tar.gz'
    mv -f fvm $path
  }

  symlink $path $env.FVM_PATH
}

export def vscodium [] {
  let version = github get_version 'VSCodium/vscodium'

  let path = share vscodium $version
  if not ($path | path exists) {
    http download $'https://github.com/VSCodium/vscodium/releases/download/($version)/VSCodium-linux-x64-($version).tar.gz'
    extract tar $'VSCodium-linux-x64-($version).tar.gz' -d vscodium
    mv -f vscodium $path
  }

  symlink $path $env.VSCODIUM_PATH
}

export def termshark [] {
  let version = github get_version 'gcla/termshark'

  http download $'https://github.com/gcla/termshark/releases/download/v($version)/termshark_($version)_linux_x64.tar.gz'
  extract tar $'termshark_($version)_linux_x64.tar.gz'
  move -d $'termshark_($version)_linux_x64' termshark
}

export def termscp [] {
  let version = github get_version 'veeso/termscp'

  http download $'https://github.com/veeso/termscp/releases/download/v($version)/termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move termscp
}

export def kbt [] {
  let version = github get_version 'bloznelis/kbt'

  http download $'https://github.com/bloznelis/kbt/releases/download/($version)/kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'kbt-($version)-x86_64-unknown-linux-gnu' kbt
}

export def trippy [--global] {
  let version = github get_version 'fujiapple852/trippy'

  http download $'https://github.com/fujiapple852/trippy/releases/download/($version)/trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'trippy-($version)-x86_64-unknown-linux-gnu' trip

  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join trip) /usr/bin/trip
  }
}

export def gitui [] {
  let version = github get_version 'extrawurst/gitui'

  http download $'https://github.com/extrawurst/gitui/releases/download/v($version)/gitui-linux-musl.tar.gz'
  extract tar gitui-linux-musl.tar.gz
  move gitui
}

export def monolith [] {
  let version = github get_version 'Y2Z/monolith'

  http download https://github.com/Y2Z/monolith/releases/download/v2.7.0/monolith-gnu-linux-x86_64 -o monolith
  chmod +x monolith
  move monolith
}

export def dijo [] {
  let version = github get_version 'nerdypepper/dijo'

  http download $'https://github.com/nerdypepper/dijo/releases/download/v($version)/dijo-x86_64-linux' -o dijo
  chmod +x dijo
  move dijo
}

export def mitmproxy [] {
  let version = '10.1.6'

  http download $'https://downloads.mitmproxy.org/($version)/mitmproxy-($version)-linux-x86_64.tar.gz'
  extract tar $'mitmproxy-($version)-linux-x86_64.tar.gz' -d 'mitmproxy'
  move -d 'mitmproxy' '*'
}

export def speedtest [] {
  let version = '1.2.0'

  http download $'https://install.speedtest.net/app/cli/ookla-speedtest-($version)-linux-x86_64.tgz'
  extract tar $'ookla-speedtest-($version)-linux-x86_64.tgz' -d 'ookla-speedtest-linux-x86_64'
  move -d 'ookla-speedtest-linux-x86_64' 'speedtest'
}

export def nix [] {
  curl -L 'https://nixos.org/nix/install' | bash -s -- --daemon
}

export def devbox [] {
  curl -fsSL 'https://get.jetpack.io/devbox' | bash
}

export def tailscale [] {
  curl -fsSL 'https://tailscale.com/install.sh' | sh
}

export def node [] {
  let version = choose ["18.18.2" "20.9.0" "21.2.0"]

  let path = share node $version
  if not ($path | path exists) {
    http download $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz'
    extract tar $'node-v($version)-linux-x64.tar.gz'
    mv -f $'node-v($version)-linux-x64' $path
  }

  symlink $path $env.NODE_PATH
}

export def golang [] {
  let version = choose ['1.21.5' '1.20.12' '1.19.13']

  let path = share go $version
  if not ($path | path exists) {
    http download $'https://go.dev/dl/go($version).linux-amd64.tar.gz'
    extract tar $'go($version).linux-amd64.tar.gz'
    mv -f go $path
  }

  symlink $path $env.GOROOT
}

export def rust [] {
  curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh -s -- -y
}

export def vlang [] {
  http download https://github.com/vlang/v/releases/latest/download/v_linux.zip
  extract zip v_linux.zip
  mv -f 'v' $env.VLANG_PATH
}

export def java [] {
  let releases = [
    [version, build, hash];
    ['21' '35' 'fd2272bbf8e04c3dbaee13770090416c']
    ['17' '35' '0d483333a00540d886896bac774ff48b']
  ]

  let version = choose ($releases | get version)
  let release = ($releases | where version == $version | first)

  let hash = ($release | get hash)
  let build = ($release | get build)

  let path = share java $version
  if not ($path | path exists) {
    http download $'https://download.java.net/java/GA/jdk($version)/($hash)/($build)/GPL/openjdk-($version)_linux-x64_bin.tar.gz'
    extract tar $'openjdk-($version)_linux-x64_bin.tar.gz'
    mv -f $'jdk-($version)' $path
  }

  symlink $path $env.JAVA_PATH
}

export def jdtls [] {
  let path = share jdtls 'latest'
  if not ($path | path exists) {
    http download https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz -o jdt-language-server-latest.tar.gz
    extract tar jdt-language-server-latest.tar.gz -d jdtls
    mv -f jdtls $path
  }
  symlink $path $env.JDTLS_PATH
}

export def kotlin [] {
  let version = '1.9.22'

  http download $'https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-native-linux-x86_64-($version).tar.gz'
  extract tar $'kotlin-native-linux-x86_64-($version).tar.gz'
  rm -rf $env.KOTLIN_PATH
  mv -f $'kotlin-native-linux-x86_64-($version)' $env.KOTLIN_PATH
}

export def dart [] {
  let version = '3.2.4'

  let path = share dart $version
  if not ($path | path exists) {
    http download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip'
    extract zip 'dartsdk-linux-x64-release.zip'
    mv -f 'dart-sdk' $path
  }

  symlink $path $env.DART_PATH
}

export def flutter [--studio] {
  let version = choose ['3.16.5' '2.10.5' '2.2.3']

  let path = share flutter $version
  if not ($path | path exists) {
    http download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz'
    extract tar $'flutter_linux_($version)-stable.tar.xz'
    mv -f flutter $path
  }

  symlink $path $env.FLUTTER_PATH

  if $studio {
    android-studio --tools
  }
}

export def android-studio [--tools] {
  let version = '2023.1.1.26'

  let path = share studio $version
  if not ($path | path exists) {
    http download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz'
    extract tar $'android-studio-($version)-linux.tar.gz'
    mv -f android-studio $path
  }

  symlink $path $env.STUDIO_PATH

  if $tools {
    android-cmdline-tools --sdk
  }
}

export def android-cmdline-tools [--sdk] {
  http download https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
  extract zip commandlinetools-linux-10406996_latest.zip
  mkdir ($env.ANDROID_HOME | path join 'cmdline-tools')
  mv -f cmdline-tools $env.CMDLINE_TOOLS

  if $sdk {
    android-sdk
  }
}

export def android-platform-tools [] {
  http download https://dl.google.com/android/repository/platform-tools-latest-linux.zip
  extract zip platform-tools-latest-linux.zip
  mv -f platform-tools $env.PLATFORM_TOOLS
}

export def android-sdk [] {
  let sdkmanager = $env.CMDLINE_TOOLS_BIN | path join 'sdkmanager'

  ^$sdkmanager --licenses
  ^$sdkmanager --install "platforms;android-30"
  ^$sdkmanager --install "build-tools;30.0.3"
  ^$sdkmanager --install "build-tools;34.0.0"
}

export def bitcoin [] {
  let version = '25.1'

  http download $'https://bitcoincore.org/bin/bitcoin-core-($version)/bitcoin-($version)-x86_64-linux-gnu.tar.gz'
  extract tar $'bitcoin-($version)-x86_64-linux-gnu.tar.gz'
  rm -rf $env.BITCOIN_PATH
  mv -f $'bitcoin-($version)' $env.BITCOIN_PATH
}

export def lightning-network [] {
  let version = '0.17.3-beta'

  http download $'https://github.com/lightningnetwork/lnd/releases/download/v($version)/lnd-linux-amd64-v($version).tar.gz'
  extract tar $'lnd-linux-amd64-v($version).tar.gz'
  rm -rf $env.LIGHTNING_PATH
  mv -f $'lnd-linux-amd64-v($version)' $env.LIGHTNING_PATH
}

export def scilab [] {
  let version = '2024.0.0'

  http download $'https://www.scilab.org/download/($version)/scilab-($version).bin.x86_64-linux-gnu.tar.xz'
  extract tar $'scilab-($version).bin.x86_64-linux-gnu.tar.xz'
  rm -rf $env.SCILAB_PATH
  mv -f $'scilab-($version)' $env.SCILAB_PATH
}

export def remote-mouse [] {
  http download 'https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip'
  extract zip 'RemoteMouse_x86_64.zip' -d 'RemoteMouse_x86_64'
  rm -rf $env.REMOTE_MOUSE_PATH
  mv -f 'RemoteMouse_x86_64' $env.REMOTE_MOUSE_PATH
  rm ($env.REMOTE_MOUSE_PATH | path join install.sh)
}

export def docker [] {
  let version = '24.0.7'

  http download https://download.docker.com/linux/static/stable/x86_64/docker-($version).tgz
  extract tar docker-($version).tgz
  sudo cp docker/* /usr/bin/

  sudo groupadd docker
  sudo usermod -aG docker $env.USER

  bash -c 'sudo dockerd &'
}

export def core [] {
  xh

  gum
  mods
  glow
  soft

  helix
  nushell
  starship
  zoxide
  zellij

  rg
  fd
  fzf
  bat
  lazygit
  lazydocker
  jless

  gdu
  pueue
  delta
  dufs
  qrcp
  bottom
  ttyper
  silicon
  amber
  broot
  usql
}

export def extra [] {
  lux
  genact
  qrterminal
  bombardier
  rclone
  vhs
  nap
  sd
  sad
  lsd
  gping
}

export def lang [] {
  node
  golang
  rust
}

def move [
  file: string
  --rn: string
  --dir(-d): string
] {
  if $dir != null {
    mv -f ($env.PWD | path join $dir $file) $env.USR_LOCAL_BIN
    rm -rf $dir
  } else {
    let name = if $rn != null { $rn } else { $file }
    mv -f ($env.PWD | path join $file) ($env.USR_LOCAL_BIN | path join $name)
  }
}

def choose [versions: list] {
  if not (^which gum | is-empty) {
    (^gum choose $versions)
  } else {
    ($versions | input list)
  }
}

def share [name: string, version: string] {
  $env.USR_LOCAL_SHARE | path join ([$name $version] | str join '_')
}

def symlink [src: string, dst: string] {
  rm -rf $dst
  ln -sf $src $dst
}
