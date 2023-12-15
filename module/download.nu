
export def gum [] {
  let version = '0.13.0'

  http download $'https://github.com/charmbracelet/gum/releases/download/v($version)/gum_($version)_Linux_x86_64.tar.gz'
  extract tar $'gum_($version)_Linux_x86_64.tar.gz' -d 'gum_Linux_x86_64'
  move -d 'gum_Linux_x86_64' 'gum'
}

export def mods [] {
  let version = '1.1.0'

  http download $'https://github.com/charmbracelet/mods/releases/download/v($version)/mods_($version)_Linux_x86_64.tar.gz'
  extract tar $'mods_($version)_Linux_x86_64.tar.gz' -d 'mods_Linux_x86_64'
  move -d 'mods_Linux_x86_64' 'mods'
}

export def glow [] {
  let version = '1.5.1'

  http download $'https://github.com/charmbracelet/glow/releases/download/v($version)/glow_Linux_x86_64.tar.gz'
  extract tar 'glow_Linux_x86_64.tar.gz' -d 'glow_Linux_x86_64'
  move -d 'glow_Linux_x86_64' 'glow'
}

export def soft [] {
  let version = '0.7.4'

  http download $'https://github.com/charmbracelet/soft-serve/releases/download/v($version)/soft-serve_($version)_Linux_x86_64.tar.gz'
  extract tar $'soft-serve_($version)_Linux_x86_64.tar.gz' -d 'soft-serve_Linux_x86_64'
  move -d 'soft-serve_Linux_x86_64' 'soft'
}

export def vhs [] {
  let version = '0.7.1'

  http download https://github.com/charmbracelet/vhs/releases/download/v($version)/vhs_($version)_Linux_x86_64.tar.gz
  extract tar vhs_($version)_Linux_x86_64.tar.gz -d 'vhs_linux_x86_64'
  move -d 'vhs_linux_x86_64' 'vhs'
}

export def helix [] {
  let version = '23.10'

  http download $'https://github.com/helix-editor/helix/releases/download/($version)/helix-($version)-x86_64-linux.tar.xz'
  extract tar $'helix-($version)-x86_64-linux.tar.xz'
  rm -rf $env.HELIX_PATH
  mv -f $'helix-($version)-x86_64-linux' $env.HELIX_PATH
}

export def nushell [] {
  let version = '0.88.1'

  http download $'https://github.com/nushell/nushell/releases/download/($version)/nu-($version)-x86_64-linux-gnu-full.tar.gz'
  extract tar $'nu-($version)-x86_64-linux-gnu-full.tar.gz'
  move -d $'nu-($version)-x86_64-linux-gnu-full' 'nu'
}

export def starship [] {
  let version = '1.16.0'

  http download $'https://github.com/starship/starship/releases/download/v($version)/starship-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'starship-x86_64-unknown-linux-gnu.tar.gz'
  move 'starship'
}

export def zoxide [] {
  let version = '0.9.2'

  http download $'https://github.com/ajeetdsouza/zoxide/releases/download/v($version)/zoxide-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'zoxide-($version)-x86_64-unknown-linux-musl.tar.gz' -d 'zoxide-x86_64-unknown-linux-musl'
  move -d 'zoxide-x86_64-unknown-linux-musl' 'zoxide'
}

export def zellij [] {
  let version = '0.39.2'

  http download $'https://github.com/zellij-org/zellij/releases/download/v($version)/zellij-x86_64-unknown-linux-musl.tar.gz'
  extract tar 'zellij-x86_64-unknown-linux-musl.tar.gz'
  move 'zellij'
}

export def rg [] {
  let version = '14.0.3'

  http download $'https://github.com/BurntSushi/ripgrep/releases/download/($version)/ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'ripgrep-($version)-x86_64-unknown-linux-musl' 'rg'
}

export def fd [] {
  let version = '8.7.1'

  http download $'https://github.com/sharkdp/fd/releases/download/v($version)/fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'fd-v($version)-x86_64-unknown-linux-gnu' 'fd'
}

export def fzf [] {
  let version = '0.44.1'

  http download $'https://github.com/junegunn/fzf/releases/download/($version)/fzf-($version)-linux_amd64.tar.gz'
  extract tar $'fzf-($version)-linux_amd64.tar.gz' -d 'fzf-linux_amd64'
  move -d 'fzf-linux_amd64' 'fzf'
}

export def broot [] {
  let version = '1.30.0'

  http download https://github.com/Canop/broot/releases/download/v($version)/broot_($version).zip
  extract zip broot_($version).zip -d 'broot'
  move -d 'broot' 'x86_64-linux/broot'
}

export def bat [] {
  let version = '0.24.0'

  http download $'https://github.com/sharkdp/bat/releases/download/v($version)/bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'bat-v($version)-x86_64-unknown-linux-gnu' 'bat'
}

export def gdu [--global] {
  let version = '5.25.0'

  http download $'https://github.com/dundee/gdu/releases/download/v($version)/gdu_linux_amd64.tgz'
  extract tar 'gdu_linux_amd64.tgz'
  move 'gdu_linux_amd64' --rn 'gdu'
  if $global {
    sudo ln -sf ($env.USR_LOCAL_BIN | path join gdu) /usr/bin/gdu
  }
}

export def xh [] {
  let version = '0.20.1'

  http download $'https://github.com/ducaale/xh/releases/download/v($version)/xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'xh-v($version)-x86_64-unknown-linux-musl' 'xh'
}

export def amber [] {
  let version = '0.5.9'

  http download $'https://github.com/dalance/amber/releases/download/v($version)/amber-v($version)-x86_64-lnx.zip'
  extract zip $'amber-v($version)-x86_64-lnx.zip' -d 'amber-x86_64-lnx'
  move -d 'amber-x86_64-lnx' '*'
}

export def lazygit [] {
  let version = '0.40.2'

  http download $'https://github.com/jesseduffield/lazygit/releases/download/v($version)/lazygit_($version)_Linux_x86_64.tar.gz'
  extract tar $'lazygit_($version)_Linux_x86_64.tar.gz' -d 'lazygit_Linux_x86_64'
  move -d 'lazygit_Linux_x86_64' 'lazygit'
}

export def lazydocker [] {
  let version = '0.23.1'

  http download $'https://github.com/jesseduffield/lazydocker/releases/download/v($version)/lazydocker_($version)_Linux_x86_64.tar.gz'
  extract tar $'lazydocker_($version)_Linux_x86_64.tar.gz' -d 'lazydocker_Linux_x86_64'
  move -d 'lazydocker_Linux_x86_64' 'lazydocker'
}

export def jless [] {
  let version = '0.9.0'

  http download $'https://github.com/PaulJuliusMartinez/jless/releases/download/v($version)/jless-v($version)-x86_64-unknown-linux-gnu.zip'
  extract zip $'jless-v($version)-x86_64-unknown-linux-gnu.zip' -d 'jless-x86_64-unknown-linux-gnu'
  move -d 'jless-x86_64-unknown-linux-gnu' 'jless'
}

export def pueue [] {
  let version = '3.3.2'

  http download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueue-linux-x86_64' -o pueue
  chmod +x pueue
  move pueue

  http download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueued-linux-x86_64' -o pueued
  chmod +x pueued
  move pueued
}

export def delta [] {
  let version = '0.16.5'

  http download $'https://github.com/dandavison/delta/releases/download/($version)/delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'delta-($version)-x86_64-unknown-linux-gnu' 'delta'
}

export def bottom [] {
  let version = '0.9.6'

  http download $'https://github.com/ClementTsang/bottom/releases/download/($version)/bottom_x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'bottom_x86_64-unknown-linux-gnu.tar.gz' -d 'bottom_x86_64-unknown-linux-gnu'
  move -d 'bottom_x86_64-unknown-linux-gnu' 'btm'
}

export def ttyper [] {
  let version = '1.4.0'

  http download $'https://github.com/max-niederman/ttyper/releases/download/v($version)/ttyper-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'ttyper-x86_64-unknown-linux-gnu.tar.gz' -d 'ttyper-x86_64-unknown-linux-gnu'
  move -d 'ttyper-x86_64-unknown-linux-gnu' 'ttyper'
}

export def qrcp [] {
  let version = '0.11.0'

  http download $'https://github.com/claudiodangelis/qrcp/releases/download/($version)/qrcp_($version)_linux_amd64.tar.gz'
  extract tar $'qrcp_($version)_linux_amd64.tar.gz' -d 'qrcp_linux_amd64'
  move -d 'qrcp_linux_amd64' 'qrcp'
}

export def usql [] {
  let version = '0.17.0'

  http download $'https://github.com/xo/usql/releases/download/v($version)/usql-($version)-linux-amd64.tar.bz2'
  extract tar $'usql-($version)-linux-amd64.tar.bz2' -d 'usql-linux-amd64'
  move -d 'usql-linux-amd64' 'usql'
}

export def gotty [] {
  let version = '1.0.1'

  http download $'https://github.com/yudai/gotty/releases/download/v($version)/gotty_linux_amd64.tar.gz'
  extract tar gotty_linux_amd64.tar.gz
  move gotty
}

export def ttyd [] {
  let version = '1.7.4'

  http download https://github.com/tsl0922/ttyd/releases/download/($version)/ttyd.x86_64 -o ttyd
  chmod +x ttyd
  move ttyd
}

export def tty-share [] {
  let version = '2.4.0'

  http download $'https://github.com/elisescu/tty-share/releases/download/v($version)/tty-share_linux-amd64' -o tty-share
  chmod +x tty-share
  move tty-share
}

export def upterm [] {
  let version = '0.13.0'

  http download $'https://github.com/owenthereal/upterm/releases/download/v($version)/upterm_linux_amd64.tar.gz'
  extract tar 'upterm_linux_amd64.tar.gz' -d 'upterm_linux_amd64'
  move -d 'upterm_linux_amd64' 'upterm'
}

export def shell2http [] {
  let version = '1.16.0'

  http download $'https://github.com/msoap/shell2http/releases/download/v($version)/shell2http_($version)_linux_amd64.tar.gz'
  extract tar $'shell2http_($version)_linux_amd64.tar.gz' -d 'shell2http_linux_amd64'
  move -d 'shell2http_linux_amd64' 'shell2http'
}

export def mprocs [] {
  let version = '0.6.4'

  http download $'https://github.com/pvolok/mprocs/releases/download/v($version)/mprocs-($version)-linux64.tar.gz'
  extract tar $'mprocs-($version)-linux64.tar.gz'
  move 'mprocs'
}

export def dua [] {
  let version = '2.23.0'

  http download $'https://github.com/Byron/dua-cli/releases/download/v($version)/dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'dua-v($version)-x86_64-unknown-linux-musl' 'dua'
}

export def grex [] {
  let version = '1.4.4'

  http download $'https://github.com/pemistahl/grex/releases/download/v($version)/grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move 'grex'
}

export def navi [] {
  let version = '2.23.0'

  http download $'https://github.com/denisidoro/navi/releases/download/v($version)/navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move 'navi'
}

export def rclone [] {
  let version = '1.65.0'

  http download $'https://github.com/rclone/rclone/releases/download/v($version)/rclone-v($version)-linux-amd64.zip'
  extract zip $'rclone-v($version)-linux-amd64.zip'
  move -d $'rclone-v($version)-linux-amd64' 'rclone'
}

export def ffsend [] {
  let version = '0.2.76'

  http download $'https://github.com/timvisee/ffsend/releases/download/v($version)/ffsend-v($version)-linux-x64-static' -o ffsend
  chmod +x ffsend
  move 'ffsend'
}

export def walk [] {
  let version = '1.7.0'

  http download $'https://github.com/antonmedv/walk/releases/download/v($version)/walk_linux_amd64' -o walk
  chmod +x walk
  move 'walk'
}

export def tere [] {
  let version = '1.5.1'

  http download $'https://github.com/mgunyho/tere/releases/download/v($version)/tere-($version)-x86_64-unknown-linux-gnu.zip'
  extract zip $'tere-($version)-x86_64-unknown-linux-gnu.zip'
  move 'tere'
}

export def sd [] {
  let version = '1.0.0'

  http download $'https://github.com/chmln/sd/releases/download/v($version)/sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'sd-v($version)-x86_64-unknown-linux-gnu' 'sd'
}

export def sad [] {
  let version = '0.4.23'

  http download $'https://github.com/ms-jpq/sad/releases/download/v($version)/x86_64-unknown-linux-gnu.zip'
  extract zip 'x86_64-unknown-linux-gnu.zip'
  move 'sad'
}

export def fx [] {
  let version = '31.0.0'

  http download $'https://github.com/antonmedv/fx/releases/download/($version)/fx_linux_amd64' -o fx
  chmod +x fx
  move 'fx'
}

export def lux [] {
  let version = '0.22.0'
  http download $'https://github.com/iawia002/lux/releases/download/v($version)/lux_($version)_Linux_x86_64.tar.gz'
  extract tar $'lux_($version)_Linux_x86_64.tar.gz'
  move lux
}

export def qrterminal [] {
  let version = '3.2.0'
  http download https://github.com/mdp/qrterminal/releases/download/v($version)/qrterminal_Linux_x86_64.tar.gz
  extract tar qrterminal_Linux_x86_64.tar.gz -d qrterminal_Linux_x86_64
  move -d qrterminal_Linux_x86_64 qrterminal
}

export def genact [] {
  let version = '1.3.0'

  http download $'https://github.com/svenstaro/genact/releases/download/v($version)/genact-($version)-x86_64-unknown-linux-gnu' -o genact
  chmod +x genact
  move 'genact'
}

export def ouch [] {
  let version = '0.5.1'

  http download $'https://github.com/ouch-org/ouch/releases/download/($version)/ouch-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'ouch-x86_64-unknown-linux-gnu.tar.gz'
  move -d 'ouch-x86_64-unknown-linux-gnu' 'ouch'
}

export def lsd [] {
  let version = '1.0.0'

  http download $'https://github.com/lsd-rs/lsd/releases/download/v($version)/lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'lsd-v($version)-x86_64-unknown-linux-gnu' 'lsd'
}

export def mdcat [] {
  let version = '2.1.0'

  http download $'https://github.com/swsnr/mdcat/releases/download/mdcat-($version)/mdcat-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'mdcat-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'mdcat-($version)-x86_64-unknown-linux-musl' 'mdcat'
}

export def chatgpt [] {
  let version = '1.3'

  http download $'https://github.com/j178/chatgpt/releases/download/v($version)/chatgpt_Linux_x86_64.tar.gz'
  extract tar 'chatgpt_Linux_x86_64.tar.gz' -d 'chatgpt_Linux_x86_64'
  move -d 'chatgpt_Linux_x86_64' 'chatgpt'
}

export def silicon [] {
  let version = '0.5.2'

  http download $'https://github.com/Aloxaf/silicon/releases/download/v($version)/silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move 'silicon'
}

export def nap [] {
  let version = '0.1.1'

  http download $'https://github.com/maaslalani/nap/releases/download/v($version)/nap_($version)_linux_amd64.tar.gz'
  extract tar $'nap_($version)_linux_amd64.tar.gz' -d 'nap_linux_amd64'
  move -d 'nap_linux_amd64' 'nap'
}

export def clangd [] {
  let version = '17.0.3'

  http download $'https://github.com/clangd/clangd/releases/download/($version)/clangd-linux-($version).zip'
  extract zip $'clangd-linux-($version).zip'
  move -d $'clangd_($version)' 'bin/clangd'

  # mv $'clangd_($version)/bin/clangd' $env.USR_LOCAL_BIN
  # rm -rf $'clangd_($version)'
}

export def coreutils [] {
  let version = '0.0.23'

  http download $'https://github.com/uutils/coreutils/releases/download/($version)/coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  move -d $'coreutils-($version)-x86_64-unknown-linux-musl' 'coreutils'
}

export def carapace [] {
  let version = '0.28.5'

  http download $'https://github.com/rsteube/carapace-bin/releases/download/v($version)/carapace-bin_linux_amd64.tar.gz'
  extract tar 'carapace-bin_linux_amd64.tar.gz' -d 'carapace-bin_linux_amd64'
  move -d 'carapace-bin_linux_amd64' 'carapace'
}

export def bombardier [] {
  let version = '1.2.6'

  http download $'https://github.com/codesenberg/bombardier/releases/download/v($version)/bombardier-linux-amd64' -o bombardier
  chmod +x bombardier
  move 'bombardier'
}

export def ruff [] {
  let version = '0.1.7'

  http download https://github.com/astral-sh/ruff/releases/download/v($version)/ruff-x86_64-unknown-linux-gnu.tar.gz
  extract tar ruff-x86_64-unknown-linux-gnu.tar.gz
  move 'ruff'
}

export def micro [] {
  let version = '2.0.13'

  http download $'https://github.com/zyedidia/micro/releases/download/v($version)/micro-($version)-linux64.tar.gz'
  extract tar $'micro-($version)-linux64.tar.gz'
  move -d $'micro-($version)' micro
}

export def dufs [] {
  let version = '0.38.0'

  http download $'https://github.com/sigoden/dufs/releases/download/v($version)/dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  move dufs
}

export def miniserve [] {
  let version = '0.24.0'

  http download $'https://github.com/svenstaro/miniserve/releases/download/v($version)/miniserve-($version)-x86_64-unknown-linux-gnu' -o miniserve
  chmod +x miniserve
  move miniserve
}

export def onefetch [] {
  let version = '2.19.0'

  http download $'https://github.com/o2sh/onefetch/releases/download/($version)/onefetch-linux.tar.gz'
  extract tar onefetch-linux.tar.gz
  move onefetch
}

export def gping [] {
  let version = '1.16.0'

  http download $'https://github.com/orf/gping/releases/download/gping-v($version)/gping-x86_64-unknown-linux-musl.tar.gz'
  extract tar gping-x86_64-unknown-linux-musl.tar.gz
  move gping
}

export def duf [] {
  let version = '0.8.1'

  http download https://github.com/muesli/duf/releases/download/v($version)/duf_($version)_linux_x86_64.tar.gz
  extract tar duf_($version)_linux_x86_64.tar.gz -d duf_linux_x86_64
  move -d duf_linux_x86_64 duf
}

export def gh [] {
  let version = '2.40.0'

  http download https://github.com/cli/cli/releases/download/v($version)/gh_($version)_linux_amd64.tar.gz
  extract tar gh_($version)_linux_amd64.tar.gz
  move -d gh_($version)_linux_amd64 bin/gh
}

export def dive [] {
  let version = '0.11.0'

  http download https://github.com/wagoodman/dive/releases/download/v($version)/dive_($version)_linux_amd64.tar.gz
  extract tar dive_($version)_linux_amd64.tar.gz -d dive_linux_amd64
  move -d dive_linux_amd64 dive
}

export def hyperfine [] {
  let version = '1.18.0'

  http download $'https://github.com/sharkdp/hyperfine/releases/download/v($version)/hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'hyperfine-v($version)-x86_64-unknown-linux-gnu' hyperfine
}

export def taskell [] {
  let version = '1.11.4'

  http download $'https://github.com/smallhadroncollider/taskell/releases/download/($version)/taskell-($version)_x86-64-linux.tar.gz'
  extract tar $'taskell-($version)_x86-64-linux.tar.gz'
  move taskell
}

export def bettercap [] {
  let version = '2.31.1'

  http download $'https://github.com/bettercap/bettercap/releases/download/v($version)/bettercap_linux_amd64_v($version).zip'
  extract zip $'bettercap_linux_amd64_v($version).zip' -d bettercap_linux_amd64
  move -d bettercap_linux_amd64 bettercap

  sudo ln -sf ($env.USR_LOCAL_BIN | path join bettercap) /usr/bin/bettercap
}

export def viddy [] {
  let viddy = '0.4.0'

  http download $'https://github.com/sachaos/viddy/releases/download/v($version)/viddy_Linux_x86_64.tar.gz'
  extract tar viddy_Linux_x86_64.tar.gz -d viddy_Linux_x86_64
  move -d viddy_Linux_x86_64 viddy
}

export def yazi [] {
  let version = '0.1.5'

  http download $'https://github.com/sxyazi/yazi/releases/download/v($version)/yazi-x86_64-unknown-linux-gnu.zip'
  extract zip yazi-x86_64-unknown-linux-gnu.zip
  move -d yazi-x86_64-unknown-linux-gnu yazi
}

export def kmon [] {
  let version = '1.6.4'

  http download $'https://github.com/orhun/kmon/releases/download/v($version)/kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  move -d $'kmon-($version)' kmon
}

export def volta [] {
  let version = '1.1.1'

  http download $'https://github.com/volta-cli/volta/releases/download/v($version)/volta-($version)-linux.tar.gz'
  extract tar $'volta-($version)-linux.tar.gz' -d 'volta-linux'
  move -d $'volta-($version)-linux' '*'

  ^volta install node@latest
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
  let version = ([ "18.18.2" "20.9.0" "21.2.0" ] | input list)

  http download $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz'
  extract tar $'node-v($version)-linux-x64.tar.gz'
  rm -rf $env.NODE_PATH
  mv -f $'node-v($version)-linux-x64' $env.NODE_PATH
}

export def golang [] {
  let version = '1.21.4'

  http download $'https://go.dev/dl/go($version).linux-amd64.tar.gz'
  extract tar $'go($version).linux-amd64.tar.gz'
  rm -rf $env.GOROOT
  mv -f 'go' $env.GOROOT
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
  let version = '20.0.2'

  http download $'https://download.java.net/java/GA/jdk($version)/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-($version)_linux-x64_bin.tar.gz'
  extract tar $'openjdk-($version)_linux-x64_bin.tar.gz'
  rm -rf $env.JAVA_PATH
  mv -f $'jdk-($version)' $env.JAVA_PATH
}

export def kotlin [] {
  let version = '1.9.10'

  http download $'https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-native-linux-x86_64-($version).tar.gz'
  extract tar $'kotlin-native-linux-x86_64-($version).tar.gz'
  rm -rf $env.KOTLIN_PATH
  mv -f $'kotlin-native-linux-x86_64-($version)' $env.KOTLIN_PATH
}

export def flutter [] {
  let version = '3.13.3'

  http download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz'
  extract tar $'flutter_linux_($version)-stable.tar.xz'
  rm -rf $env.FLUTTER_PATH
  mv -f 'flutter' $env.FLUTTER_PATH
  # ^flutter doctor --android-licenses
}

export def dart [] {
  let version = '3.1.1'

  http download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip'
  extract zip 'dartsdk-linux-x64-release.zip'
  rm -rf $env.DART_PATH
  mv -f 'dart-sdk' $env.DART_PATH
}

export def android-studio [] {
  let version = '2022.3.1.20'

  http download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz'
  extract tar $'android-studio-($version)-linux.tar.gz'
  rm -rf $env.STUDIO_PATH
  mv -f 'android-studio' $env.STUDIO_PATH
  # ^sdkmanager --sdk_root=$env.ANDROID_HOME --install "cmdline-tools;latest"
  # ^sdkmanager --sdk_root=$env.ANDROID_HOME --licenses
}

export def bitcoin [] {
  let version = '25.1'

  http download $'https://bitcoincore.org/bin/bitcoin-core-($version)/bitcoin-($version)-x86_64-linux-gnu.tar.gz'
  extract tar $'bitcoin-($version)-x86_64-linux-gnu.tar.gz'
  rm -rf $env.BITCOIN_PATH
  mv -f $'bitcoin-($version)' $env.BITCOIN_PATH
}

export def lightning-network [] {
  let version = '0.17.0-beta'

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

export def browser-extension [] {
  let extensions = [
    'https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb'
    'https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh'
    'https://chrome.google.com/webstore/detail/volume-booster/anmbbeeiaollmpadookgoakpfjkbidaf'
    'https://chrome.google.com/webstore/detail/simple-translate/ibplnjkanclpjokhdolnendpplpjiace'
    'https://chrome.google.com/webstore/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg'
    'https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai'
    'https://chrome.google.com/webstore/detail/user-javascript-and-css/nbhcbdghjpllgmfilhnhkllmkecfmpld'
  ]
  for $extension in $extensions {
    brave-browser $extension
  }
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
