
export def helix [ --global(-g) --editor ] {
  let version = github get_version 'helix-editor/helix'

  let bin = ($env.HELIX_PATH | path join hx)
  let path = share helix $version

  if (no-exist $path) {
    https download $'https://github.com/helix-editor/helix/releases/download/($version)/helix-($version)-x86_64-linux.tar.xz'
    extract tar $'helix-($version)-x86_64-linux.tar.xz'
    umv -d $'helix-($version)-x86_64-linux' -p $path
  }

  symlink $path $env.HELIX_PATH

  if $global {
    global $bin
  }
  if $editor {
    global $bin editor
  }
}

export def nvim [] {
  let version = github get_version 'neovim/neovim'

  let path = share nvim $version

  if (no-exist $path) {
    https download $'https://github.com/neovim/neovim/releases/download/v($version)/nvim-linux64.tar.gz'
    extract tar nvim-linux64.tar.gz
    umv -f nvim-linux64 -p $path
  }

  symlink $path $env.NVIM_PATH
}

export def nushell [] {
  let version = github get_version 'nushell/nushell'
  let path = share nu $version

  if (no-exist $path) {
    https download $'https://github.com/nushell/nushell/releases/download/($version)/nu-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'nu-($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'nu-($version)-x86_64-unknown-linux-gnu' -f 'nu' -p $path
  }

  bind -r nu $path
}

export def starship [] {
  let version = github get_version 'starship/starship'
  let path = share starship $version

  if (no-exist $path) {
    https download $'https://github.com/starship/starship/releases/download/v($version)/starship-x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'starship-x86_64-unknown-linux-gnu.tar.gz'
    umv -f 'starship' -p $path
  }

  bind -r starship $path
}

export def zoxide [] {
  let version = github get_version 'ajeetdsouza/zoxide'
  let path = share zoxide $version

  if (no-exist $path) {
    https download $'https://github.com/ajeetdsouza/zoxide/releases/download/v($version)/zoxide-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'zoxide-($version)-x86_64-unknown-linux-musl.tar.gz' -d 'zoxide-x86_64-unknown-linux-musl'
    umv -d 'zoxide-x86_64-unknown-linux-musl' -f 'zoxide' -p $path
  }

  bind -r zoxide $path
}

export def zellij [] {
  let version = github get_version 'zellij-org/zellij'
  let path = share zellij $version

  if (no-exist $path) {
    https download $'https://github.com/zellij-org/zellij/releases/download/v($version)/zellij-x86_64-unknown-linux-musl.tar.gz'
    extract tar 'zellij-x86_64-unknown-linux-musl.tar.gz'
    umv -f 'zellij' -p $path
  }

  bind -r zellij $path
}

export def rg [] {
  let version = github get_version 'BurntSushi/ripgrep'
  let path = share rg $version

  if (no-exist $path) {
    https download $'https://github.com/BurntSushi/ripgrep/releases/download/($version)/ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
    umv -d $'ripgrep-($version)-x86_64-unknown-linux-musl' -f 'rg' -p $path
  }

  bind -r rg $path
}

export def fd [] {
  let version = github get_version 'sharkdp/fd'
  let path = share fd $version

  if (no-exist $path) {
    https download $'https://github.com/sharkdp/fd/releases/download/v($version)/fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'fd-v($version)-x86_64-unknown-linux-gnu' -f 'fd' -p $path
  }

  bind -r fd $path
}

export def fzf [] {
  let version = github get_version 'junegunn/fzf'
  let path = share fzf $version

  if (no-exist $path) {
    https download $'https://github.com/junegunn/fzf/releases/download/v($version)/fzf-($version)-linux_amd64.tar.gz'
    extract tar $'fzf-($version)-linux_amd64.tar.gz' -d 'fzf-linux_amd64'
    umv -d fzf-linux_amd64 -f fzf -p $path
  }

  bind -r fzf $path
}

export def marksman [] {
  let version = github get_version 'artempyanykh/marksman'
  let path = share marksman $version

  if (no-exist $path) {
    https download https://github.com/artempyanykh/marksman/releases/download/2023-12-09/marksman-linux-x64 -o marksman
    chmod 755 marksman
    umv  -f marksman -p $path
  }

  bind marksman $path
}

export def v-analyzer [] {
  let version = github get_version 'vlang/v-analyzer'
  let path = share v-analyzer $version

  if (no-exist $path) {
    https download https://github.com/vlang/v-analyzer/releases/download/($version)/v-analyzer-linux-x86_64.zip
    extract zip v-analyzer-linux-x86_64.zip
    umv  -f v-analyzer -p $path
  }

  bind v-analyzer $path
}

export def zls [] {
  let version = github get_version 'zigtools/zls'
  let path = share zls $version

  if (no-exist $path) {
    https download https://github.com/zigtools/zls/releases/download/($version)/zls-x86_64-linux.tar.xz
    extract tar zls-x86_64-linux.tar.xz -d zls-x86_64-linux
    umv -d zls-x86_64-linux -f zls -p $path
  }

  bind zls $path
}

export def broot [] {
  let version = github get_version 'Canop/broot'

  let bin = bin broot
  let path = share broot $version

  if (no-exist $path) {
    https download https://github.com/Canop/broot/releases/download/v($version)/broot_($version).zip
    extract zip broot_($version).zip -d 'broot'
    umv -d 'broot' -f 'x86_64-linux/broot' -p $path
  }

  symlink $path $bin
}

export def mirrord [] {
  let version = github get_version 'metalbear-co/mirrord'

  let bin = bin mirrord
  let path = share mirrord $version

  if (no-exist $path) {
    https download $"https://github.com/metalbear-co/mirrord/releases/download/($version)/mirrord_linux_x86_64" -o mirrord
    chmod 755 mirrord
    umv -f mirrord -p $path
  }

  symlink $path $bin
}

export def gitu [] {
  let version = github get_version 'altsem/gitu'

  let bin = bin gitu
  let path = share gitu $version

  if (no-exist $path) {
    https download $'https://github.com/altsem/gitu/releases/download/v($version)/gitu-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'gitu-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'gitu-v($version)-x86_64-unknown-linux-gnu' -f 'gitu' -p $path
  }

  symlink $path $bin
}

export def fm [] {
  let version = github get_version 'mistakenelf/fm'

  let bin = bin fm
  let path = share fm $version

  if (no-exist $path) {
    https download $"https://github.com/mistakenelf/fm/releases/download/v($version)/fm_($version)_linux_amd64.tar.gz"
    extract tar $"fm_($version)_linux_amd64.tar.gz" -d fm_linux_amd64
    umv -d $'fm_linux_amd64' -f 'fm' -p $path
  }

  symlink $path $bin
}

export def superfile [] {
  let version = github get_version 'yorukot/superfile'

  let bin = bin spf
  let path = share spf $version

  if (no-exist $path) {
    https download $'https://github.com/yorukot/superfile/releases/download/v($version)/superfile-linux-v($version)-amd64.tar.gz'
    extract tar $'superfile-linux-v($version)-amd64.tar.gz'
    umv -d dist -f $'superfile-linux-v($version)-amd64/spf' -p $path
  }

  symlink $path $bin
}

export def zk [] {
  let version = github get_version 'zk-org/zk'

  let bin = bin zk
  let path = share zk $version

  if (no-exist $path) {
    https download $"https://github.com/zk-org/zk/releases/download/v($version)/zk-v($version)-linux-amd64.tar.gz"
    extract tar $"zk-v($version)-linux-amd64.tar.gz" -d zk_linux_amd64
    umv -d $'zk_linux_amd64' -f 'zk' -p $path
  }

  symlink $path $bin
}

export def hostctl [] {
  let version = github get_version 'guumaster/hostctl'

  let bin = bin hostctl
  let path = share hostctl $version

  if (no-exist $path) {
    https download $"https://github.com/guumaster/hostctl/releases/download/v($version)/hostctl_($version)_linux_64-bit.tar.gz"
    extract tar $'hostctl_($version)_linux_64-bit.tar.gz' -d "hostctl_linux"
    umv -d "hostctl_linux" -f hostctl -p $path
  }

  symlink $path $bin
}

export def bat [] {
  let version = github get_version 'sharkdp/bat'

  let bin = bin bat
  let path = share bat $version

  if (no-exist $path) {
    https download $'https://github.com/sharkdp/bat/releases/download/v($version)/bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'bat-v($version)-x86_64-unknown-linux-gnu' -f 'bat' -p $path
  }

  symlink $path $bin
}

export def gdu [] {
  let version = github get_version 'dundee/gdu'
  let path = share gdu $version

  if (no-exist $path) {
    https download $'https://github.com/dundee/gdu/releases/download/v($version)/gdu_linux_amd64.tgz'
    extract tar 'gdu_linux_amd64.tgz'
    umv -f 'gdu_linux_amd64' -p $path
  }

  bind -r gdu $path
}

export def xh [] {
  let version = github get_version 'ducaale/xh'
  let path = share xh $version

  if (no-exist $path) {
    https download $'https://github.com/ducaale/xh/releases/download/v($version)/xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
    umv -d $'xh-v($version)-x86_64-unknown-linux-musl' -f 'xh' -p $path
  }

  bind -r xh $path
}

export def task [] {
  let version = github get_version 'go-task/task'
  let path = share task $version

  if (no-exist $path) {
    https download $"https://github.com/go-task/task/releases/download/v($version)/task_linux_amd64.tar.gz"
    extract tar task_linux_amd64.tar.gz -d task_linux_amd64
    umv -d task_linux_amd64 -f task -p $path
  }

  bind -r task $path
}

export def mouseless [] {
  let version = github get_version 'jbensmann/mouseless'
  let path = share mouseless $version

  if (no-exist $path) {
    https download $'https://github.com/jbensmann/mouseless/releases/download/v($version)/mouseless-linux-amd64.tar.gz'
    extract tar mouseless-linux-amd64.tar.gz
    umv -d dist -f mouseless -p $path
  }

  bind -r mouseless $path
}

export def websocat [] {
  let version = github get_version 'vi/websocat'

  let bin = bin websocat
  let path = share websocat $version

  if (no-exist $path) {
    https download $'https://github.com/vi/websocat/releases/download/v($version)/websocat.x86_64-unknown-linux-musl' -o websocat
    chmod 755 websocat
    umv -f websocat -p $path
  }

  symlink $path $bin
}

export def gum [] {
  let version = github get_version 'charmbracelet/gum'
  let path = share gum $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/gum/releases/download/v($version)/gum_($version)_Linux_x86_64.tar.gz
    extract tar gum_($version)_Linux_x86_64.tar.gz
    umv -d gum_($version)_Linux_x86_64 -f gum -p $path
  }

  bind -r gum $path
}

export def mods [] {
  let version = github get_version 'charmbracelet/mods'

  let bin = bin mods
  let path = share mods $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/mods/releases/download/v($version)/mods_($version)_Linux_x86_64.tar.gz
    extract tar mods_($version)_Linux_x86_64.tar.gz
    umv -d mods_($version)_Linux_x86_64 -f mods -p $path
  }

  symlink $path $bin
}

export def glow [] {
  let version = github get_version 'charmbracelet/glow'

  let bin = bin glow
  let path = share glow $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/glow/releases/download/v($version)/glow_($version)_Linux_x86_64.tar.gz
    extract tar glow_($version)_Linux_x86_64.tar.gz
    umv -d glow_($version)_Linux_x86_64 -f glow -p $path
  }

  symlink $path $bin
}

export def soft [] {
  let version = github get_version 'charmbracelet/soft-serve'

  let bin = bin soft
  let path = share soft $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/soft-serve/releases/download/v($version)/soft-serve_($version)_Linux_x86_64.tar.gz
    extract tar soft-serve_($version)_Linux_x86_64.tar.gz
    umv -d soft-serve_($version)_Linux_x86_64 -f soft -p $path
  }

  symlink $path $bin
}

export def vhs [] {
  let version = github get_version 'charmbracelet/vhs'

  let bin = bin vhs
  let path = share vhs $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/vhs/releases/download/v($version)/vhs_($version)_Linux_x86_64.tar.gz
    extract tar vhs_($version)_Linux_x86_64.tar.gz
    umv -d vhs_($version)_Linux_x86_64 -f vhs -p $path
  }

  symlink $path $bin
}

export def freeze [] {
  let version = github get_version 'charmbracelet/freeze'

  let bin = bin freeze
  let path = share freeze $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/freeze/releases/download/v($version)/freeze_($version)_Linux_x86_64.tar.gz
    extract tar freeze_($version)_Linux_x86_64.tar.gz
    umv -d freeze_($version)_Linux_x86_64 -f freeze -p $path
  }

  symlink $path $bin
}

export def melt [] {
  let version = github get_version 'charmbracelet/melt'

  let bin = bin melt
  let path = share melt $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/melt/releases/download/v($version)/melt_($version)_Linux_x86_64.tar.gz
    extract tar melt_($version)_Linux_x86_64.tar.gz
    umv -d melt_($version)_Linux_x86_64 -f melt -p $path
  }

  symlink $path $bin
}

export def skate [] {
  let version = github get_version 'charmbracelet/skate'

  let bin = bin skate
  let path = share skate $version

  if (no-exist $path) {
    https download https://github.com/charmbracelet/skate/releases/download/v($version)/skate_($version)_Linux_x86_64.tar.gz
    extract tar skate_($version)_Linux_x86_64.tar.gz -d skate_Linux_x86_64
    umv -d skate_Linux_x86_64 -f skate -p $path
  }

  symlink $path $bin
}

export def amber [] {
  let version = github get_version 'dalance/amber'

  let bin = bin amber
  let path = share amber $version

  if (no-exist $path) {
    https download $'https://github.com/dalance/amber/releases/download/v($version)/amber-v($version)-x86_64-lnx.zip'
    extract zip $'amber-v($version)-x86_64-lnx.zip' -d 'amber-x86_64-lnx'
    umv -d 'amber-x86_64-lnx' -p $path
  }

  symlink $path $bin
}

export def obsidian-cli [] {
  let version = "0.1.6"

  let bin = bin obs
  let path = share obs $version

  if (no-exist $path) {
    https download $'https://github.com/Yakitrak/obsidian-cli/releases/download/v($version)/obsidian-cli_($version)_linux_amd64.tar.gz'
    extract tar $"obsidian-cli_($version)_linux_amd64.tar.gz" -d "obsidian-cli_linux_amd64"
    umv -d 'obsidian-cli_linux_amd64' -f 'obs' -p $path
  }

  symlink $path $bin
}

export def lazygit [] {
  let version = github get_version 'jesseduffield/lazygit'

  let bin = bin lazygit
  let path = share lazygit $version

  if (no-exist $path) {
    https download $'https://github.com/jesseduffield/lazygit/releases/download/v($version)/lazygit_($version)_Linux_x86_64.tar.gz'
    extract tar $'lazygit_($version)_Linux_x86_64.tar.gz' -d 'lazygit_Linux_x86_64'
    umv -d 'lazygit_Linux_x86_64' -f 'lazygit' -p $path
  }

  symlink $path $bin
}

export def lazydocker [] {
  let version = github get_version 'jesseduffield/lazydocker'

  let bin = bin lazydocker
  let path = share lazydocker $version

  if (no-exist $path) {
    https download $'https://github.com/jesseduffield/lazydocker/releases/download/v($version)/lazydocker_($version)_Linux_x86_64.tar.gz'
    extract tar $'lazydocker_($version)_Linux_x86_64.tar.gz' -d 'lazydocker_Linux_x86_64'
    umv -d 'lazydocker_Linux_x86_64' -f 'lazydocker' -p $path
  }

  symlink $path $bin
}

export def jless [] {
  let version = github get_version 'PaulJuliusMartinez/jless'

  let bin = bin jless
  let path = share jless $version

  if (no-exist $path) {
    https download $'https://github.com/PaulJuliusMartinez/jless/releases/download/v($version)/jless-v($version)-x86_64-unknown-linux-gnu.zip'
    extract zip $'jless-v($version)-x86_64-unknown-linux-gnu.zip' -d 'jless-x86_64-unknown-linux-gnu'
    umv -d 'jless-x86_64-unknown-linux-gnu' -f 'jless' -p $path
  }

  symlink $path $bin
}

export def silicon [] {
  let version = github get_version 'Aloxaf/silicon'

  let bin = bin silicon
  let path = share silicon $version

  if (no-exist $path) {
    https download $'https://github.com/Aloxaf/silicon/releases/download/v($version)/silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -f 'silicon' -p $path
  }

  symlink $path $bin
}

export def dasel [] {
  let version = github get_version 'TomWright/dasel'

  let bin = bin dasel
  let path = share dasel $version

  if (no-exist $path) {
    https download $"https://github.com/TomWright/dasel/releases/download/v($version)/dasel_linux_amd64" -o dasel
    chmod 755 dasel
    umv -f dasel -p $path
  }

  symlink $path $bin
}

export def pueue [] {
  let version = github get_version 'Nukesor/pueue'

  let bin = bin pueue
  let path = share pueue $version

  if (no-exist $path) {
    https download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueue-linux-x86_64' -o pueue
    chmod 755 pueue
    umv -f pueue -p $path
  }
  symlink $path $bin

  let bin = bin pueued
  let path = share pueued $version

  if (no-exist $path) {
    https download $'https://github.com/Nukesor/pueue/releases/download/v($version)/pueued-linux-x86_64' -o pueued
    chmod 755 pueued
    umv -f pueued -p $path
  }
  symlink $path $bin
}

export def delta [] {
  let version = github get_version 'dandavison/delta'

  let bin = bin delta
  let path = share delta $version

  if (no-exist $path) {
    https download $'https://github.com/dandavison/delta/releases/download/($version)/delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'delta-($version)-x86_64-unknown-linux-gnu' -f 'delta' -p $path
  }

  symlink $path $bin
}

export def difftastic [] {
  let version = github get_version 'Wilfred/difftastic'

  let bin = bin difft
  let path = share difft $version

  if (no-exist $path) {
    https download https://github.com/Wilfred/difftastic/releases/download/($version)/difft-x86_64-unknown-linux-gnu.tar.gz
    extract tar difft-x86_64-unknown-linux-gnu.tar.gz -d difftastic
    umv -d difftastic -f difft -p $path
  }

  symlink $path $bin
}

export def bottom [] {
  let version = github get_version 'ClementTsang/bottom'

  let bin = bin btm
  let path = share btm $version

  if (no-exist $path) {
    https download $'https://github.com/ClementTsang/bottom/releases/download/($version)/bottom_x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'bottom_x86_64-unknown-linux-gnu.tar.gz' -d 'bottom_x86_64-unknown-linux-gnu'
    umv -d 'bottom_x86_64-unknown-linux-gnu' -f 'btm' -p $path
  }

  symlink $path $bin
}

export def ttyper [] {
  let version = github get_version 'max-niederman/ttyper'

  let bin = bin ttyper
  let path = share ttyper $version

  if (no-exist $path) {
    https download $'https://github.com/max-niederman/ttyper/releases/download/v($version)/ttyper-x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'ttyper-x86_64-unknown-linux-gnu.tar.gz' -d 'ttyper-x86_64-unknown-linux-gnu'
    umv -d 'ttyper-x86_64-unknown-linux-gnu' -f 'ttyper' -p $path
  }

  symlink $path $bin
}

export def qrcp [] {
  let version = github get_version 'claudiodangelis/qrcp'

  let bin = bin qrcp
  let path = share qrcp $version

  if (no-exist $path) {
    https download $'https://github.com/claudiodangelis/qrcp/releases/download/($version)/qrcp_($version)_linux_amd64.tar.gz'
    extract tar $'qrcp_($version)_linux_amd64.tar.gz' -d 'qrcp_linux_amd64'
    umv -d 'qrcp_linux_amd64' -f 'qrcp' -p $path
  }

  symlink $path $bin
}

export def usql [] {
  let version = github get_version 'xo/usql'

  let bin = bin usql
  let path = share usql $version

  if (no-exist $path) {
    https download $'https://github.com/xo/usql/releases/download/v($version)/usql-($version)-linux-amd64.tar.bz2'
    extract tar $'usql-($version)-linux-amd64.tar.bz2' -d 'usql-linux-amd64'
    umv -d 'usql-linux-amd64' -f 'usql' -p $path
  }

  symlink $path $bin
}

export def atlas [--eula] {
  let version = github get_version 'ariga/atlas'

  let bin = bin atlas
  let path = share atlas $version

  if (no-exist $path) {
    let filename = if $eula {
      "atlas-linux-amd64-latest"
    } else {
      "atlas-community-linux-amd64-latest"
    }
    https download $"https://release.ariga.io/atlas/($filename)" -o atlas
    chmod 755 atlas
    umv -f atlas -p $path
  }

  symlink $path $bin
}

export def gotty [] {
  let version = github get_version 'yudai/gotty'

  https download $'https://github.com/yudai/gotty/releases/download/v($version)/gotty_linux_amd64.tar.gz'
  extract tar gotty_linux_amd64.tar.gz
  umv -f gotty
}

export def ttyd [] {
  let version = github get_version 'tsl0922/ttyd'

  let bin = bin ttyd
  let path = share ttyd $version

  if (no-exist $path) {
    https download https://github.com/tsl0922/ttyd/releases/download/($version)/ttyd.x86_64 -o ttyd
    chmod 777 ttyd
    umv -f ttyd -p $path
  }

  symlink $path $bin
}

export def tty-share [] {
  let version = github get_version 'elisescu/tty-share'

  let bin = bin tty-share
  let path = share tty-share $version

  if (no-exist $path) {
    https download $'https://github.com/elisescu/tty-share/releases/download/v($version)/tty-share_linux-amd64' -o tty-share
    chmod 755 tty-share
    umv -f tty-share -p $path
  }

  symlink $path $bin
}

export def upterm [] {
  let version = github get_version 'owenthereal/upterm'

  let bin = bin upterm
  let path = share upterm $version

  if (no-exist $path) {
    https download $'https://github.com/owenthereal/upterm/releases/download/v($version)/upterm_linux_amd64.tar.gz'
    extract tar 'upterm_linux_amd64.tar.gz' -d upterm_linux_amd64
    umv -d 'upterm_linux_amd64' -f 'upterm' -p $path
  }

  symlink $path $bin
}

export def kanata [] {
  let version = github get_version 'jtroo/kanata'
  let path = share kanata $version

  if (no-exist $path) {
    https download $"https://github.com/jtroo/kanata/releases/download/v($version)/kanata" -o kanata
    chmod 777 kanata
    umv -f kanata -p $path
  }
  # sudo ./kanata --cfg kanata.kbd
  bind -r kanata $path
}

export def mongosh [] {
  let version = "2.3.1"
  https download $"https://downloads.mongodb.com/compass/mongosh-($version)-linux-x64.tgz"
  extract tar $"mongosh-($version)-linux-x64.tgz"
  chmod 777 $"mongosh-($version)-linux-x64/bin/mongosh"
  sudo cp $"mongosh-($version)-linux-x64/bin/mongosh" /usr/local/bin/
  sudo cp $"mongosh-($version)-linux-x64/bin/mongosh_crypt_v1.so" /usr/local/lib/
  rm -rf $"mongosh-($version)-linux-x64"
}

export def shell2http [] {
  let version = github get_version 'msoap/shell2http'

  https download $'https://github.com/msoap/shell2http/releases/download/v($version)/shell2http_($version)_linux_amd64.tar.gz'
  extract tar $'shell2http_($version)_linux_amd64.tar.gz' -d 'shell2http_linux_amd64'
  umv -d 'shell2http_linux_amd64' -f 'shell2http'
}

export def mprocs [] {
  let version = github get_version 'pvolok/mprocs'

  https download $'https://github.com/pvolok/mprocs/releases/download/v($version)/mprocs-($version)-linux64.tar.gz'
  extract tar $'mprocs-($version)-linux64.tar.gz'
  umv -f 'mprocs'
}

export def dua [] {
  let version = github get_version 'Byron/dua-cli'

  https download $'https://github.com/Byron/dua-cli/releases/download/v($version)/dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -d $'dua-v($version)-x86_64-unknown-linux-musl' -f 'dua'
}

export def grex [] {
  let version = github get_version 'pemistahl/grex'

  https download $'https://github.com/pemistahl/grex/releases/download/v($version)/grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -f 'grex'
}

export def navi [] {
  let version = github get_version 'denisidoro/navi'

  https download $'https://github.com/denisidoro/navi/releases/download/v($version)/navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -f 'navi'
}

export def bore [] {
  let version = github get_version 'ekzhang/bore'

  let bin = bin bore
  let path = share bore $version

  if (no-exist $path) {
    https download $"https://github.com/ekzhang/bore/releases/download/v($version)/bore-v($version)-x86_64-unknown-linux-musl.tar.gz"
    extract tar $"bore-v($version)-x86_64-unknown-linux-musl.tar.gz"
    umv -f bore -p $path
  }

  symlink $path $bin
}

export def rclone [] {
  let version = github get_version 'rclone/rclone'
  let path = share rclone $version

  if (no-exist $path) {
    https download $'https://github.com/rclone/rclone/releases/download/v($version)/rclone-v($version)-linux-amd64.zip'
    extract zip $'rclone-v($version)-linux-amd64.zip'
    umv -d $'rclone-v($version)-linux-amd64' -f 'rclone' -p $path
  }

  bind -r rclone $path
}

export def ffsend [] {
  let version = github get_version 'timvisee/ffsend'

  https download $'https://github.com/timvisee/ffsend/releases/download/v($version)/ffsend-v($version)-linux-x64-static' -o ffsend
  chmod 755 ffsend
  umv -f 'ffsend'
}

export def walk [] {
  let version = github get_version 'antonmedv/walk'

  https download $'https://github.com/antonmedv/walk/releases/download/v($version)/walk_linux_amd64' -o walk
  chmod 755 walk
  umv -f 'walk'
}

export def tere [] {
  let version = github get_version 'mgunyho/tere'

  https download $'https://github.com/mgunyho/tere/releases/download/v($version)/tere-($version)-x86_64-unknown-linux-gnu.zip'
  extract zip $'tere-($version)-x86_64-unknown-linux-gnu.zip'
  umv -f 'tere'
}

export def sd [] {
  let version = github get_version 'chmln/sd'

  https download $'https://github.com/chmln/sd/releases/download/v($version)/sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  umv -d $'sd-v($version)-x86_64-unknown-linux-gnu' -f 'sd'
}

export def sad [] {
  let version = github get_version 'ms-jpq/sad'

  https download $'https://github.com/ms-jpq/sad/releases/download/v($version)/x86_64-unknown-linux-gnu.zip'
  extract zip 'x86_64-unknown-linux-gnu.zip'
  umv -f 'sad'
}

export def fx [] {
  let version = github get_version 'antonmedv/fx'

  https download $'https://github.com/antonmedv/fx/releases/download/($version)/fx_linux_amd64' -o fx
  chmod 755 fx
  umv -f 'fx'
}

export def jqp [] {
  let version = github get_version 'noahgorstein/jqp'

  https download $'https://github.com/noahgorstein/jqp/releases/download/v($version)/jqp_Linux_x86_64.tar.gz'
  extract tar jqp_Linux_x86_64.tar.gz -d jqp_Linux_x86_64
  umv -d jqp_Linux_x86_64 -f jqp
}

export def lux [] {
  let version = github get_version 'iawia002/lux'

  let bin = bin lux
  let path = share lux $version

  if (no-exist $path) {
    https download $'https://github.com/iawia002/lux/releases/download/v($version)/lux_($version)_Linux_x86_64.tar.gz'
    extract tar $'lux_($version)_Linux_x86_64.tar.gz'
    umv -f lux -p $path
  }

  symlink $path $bin
}

export def qrterminal [] {
  let version = github get_version 'mdp/qrterminal'

  https download https://github.com/mdp/qrterminal/releases/download/v($version)/qrterminal_Linux_x86_64.tar.gz
  extract tar qrterminal_Linux_x86_64.tar.gz -d qrterminal_Linux_x86_64
  umv -d qrterminal_Linux_x86_64 -f qrterminal
}

export def genact [] {
  let version = github get_version 'svenstaro/genact'

  let bin = bin genact
  let path = share genact $version

  if (no-exist $path) {
    https download $'https://github.com/svenstaro/genact/releases/download/v($version)/genact-($version)-x86_64-unknown-linux-gnu' -o genact
    chmod 766 genact
    umv -f genact -p $path
  }

  symlink $path $bin
}

export def ouch [] {
  let version = github get_version 'ouch-org/ouch'

  https download $'https://github.com/ouch-org/ouch/releases/download/($version)/ouch-x86_64-unknown-linux-gnu.tar.gz'
  extract tar 'ouch-x86_64-unknown-linux-gnu.tar.gz'
  umv -d 'ouch-x86_64-unknown-linux-gnu' -f 'ouch'
}

export def lsd [] {
  let version = github get_version 'lsd-rs/lsd'

  let bin = bin lsd
  let path = share lsd $version

  if (no-exist $path) {
    https download $'https://github.com/lsd-rs/lsd/releases/download/v($version)/lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'lsd-v($version)-x86_64-unknown-linux-gnu' -f 'lsd' -p $path
  }

  symlink $path $bin
}

export def ast-grep [] {
  let version = github get_version 'ast-grep/ast-grep'

  let bin = bin sg
  let path = share sg $version

  if (no-exist $path) {
    https download https://github.com/ast-grep/ast-grep/releases/download/($version)/sg-x86_64-unknown-linux-gnu.zip
    extract zip sg-x86_64-unknown-linux-gnu.zip
    umv -f sg -p $path
  }

  symlink $path $bin
}

export def d2 [] {
  let version = github get_version 'terrastruct/d2'

  let bin = bin d2
  let path = share d2 $version

  if (no-exist $path) {
    https download $'https://github.com/terrastruct/d2/releases/download/v($version)/d2-v($version)-linux-amd64.tar.gz'
    extract tar $'d2-v($version)-linux-amd64.tar.gz'
    umv -d $'d2-v($version)' -f 'bin/d2' -p $path
  }

  symlink $path $bin
}

export def mdcat [] {
  let version = github get_version 'swsnr/mdcat'

  https download $'https://github.com/swsnr/mdcat/releases/download/($version)/($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -d $'($version)-x86_64-unknown-linux-musl' -f 'mdcat'
}

export def chatgpt [] {
  let version = github get_version 'j178/chatgpt'

  https download $'https://github.com/j178/chatgpt/releases/download/v($version)/chatgpt_Linux_x86_64.tar.gz'
  extract tar 'chatgpt_Linux_x86_64.tar.gz' -d 'chatgpt_Linux_x86_64'
  umv -d 'chatgpt_Linux_x86_64' -f 'chatgpt'
}

export def aichat [] {
  let version = github get_version 'sigoden/aichat'
  let path = share aichat $version

  if (no-exist $path) {
    https download $'https://github.com/sigoden/aichat/releases/download/v($version)/aichat-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'aichat-v($version)-x86_64-unknown-linux-musl.tar.gz' -d aichat-x86_64-unknown-linux-musl
    umv -d aichat-x86_64-unknown-linux-musl -f aichat -p $path
  }

  bind aichat $path
}

export def tgpt [] {
  https download https://github.com/aandrew-me/tgpt/releases/download/v2.2.1/tgpt-linux-amd64 -o tgpt
  chmod 755 tgpt
  umv -f tgpt
}

export def slices [] {
  let version = github get_version 'maaslalani/slides'

  let bin = bin slices
  let path = share slices $version

  if (no-exist $path) {
    https download $'https://github.com/maaslalani/slides/releases/download/v($version)/slides_($version)_linux_amd64.tar.gz'
    extract tar $'slides_($version)_linux_amd64.tar.gz' -d slides_linux_amd64
    umv -d slides_linux_amd64 -f slides -p $path
  }

  symlink $path $bin
}

export def nap [] {
  let version = github get_version 'maaslalani/nap'

  let bin = bin nap
  let path = share nap $version

  if (no-exist $path) {
    https download $'https://github.com/maaslalani/nap/releases/download/v($version)/nap_($version)_linux_amd64.tar.gz'
    extract tar $'nap_($version)_linux_amd64.tar.gz' -d nap_linux_amd64
    umv -d nap_linux_amd64 -f nap -p $path
  }

  symlink $path $bin
}

export def invoice [] {
  let version = github get_version 'maaslalani/invoice'

  let bin = bin invoice
  let path = share invoice $version

  if (no-exist $path) {
    https download $'https://github.com/maaslalani/invoice/releases/download/v($version)/invoice_($version)_linux_amd64.tar.gz'
    extract tar $'invoice_($version)_linux_amd64.tar.gz' -d invoice_linux_amd64
    umv -d invoice_linux_amd64 -f invoice -p $path
  }

  symlink $path $bin
}

export def clangd [] {
  let version = github get_version 'clangd/clangd'
  let path = share clangd $version

  if (no-exist $path) {
    https download $'https://github.com/clangd/clangd/releases/download/($version)/clangd-linux-($version).zip'
    extract zip $'clangd-linux-($version).zip'
    umv -d $'clangd_($version)' -f 'bin/clangd' -p $path
  }

  bind -r clangd $path
}

export def coreutils [] {
  let version = github get_version 'uutils/coreutils'

  https download $'https://github.com/uutils/coreutils/releases/download/($version)/coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -d $'coreutils-($version)-x86_64-unknown-linux-musl' -f 'coreutils'
}

export def carapace [] {
  let version = github get_version 'rsteube/carapace-bin'

  let bin = bin carapace
  let path = share carapace $version

  if (no-exist $path) {
    https download $'https://github.com/rsteube/carapace-bin/releases/download/v($version)/carapace-bin_linux_amd64.tar.gz'
    extract tar 'carapace-bin_linux_amd64.tar.gz' -d 'carapace-bin_linux_amd64'
    umv -d 'carapace-bin_linux_amd64' -f 'carapace' -p $path
  }

  symlink $path $bin
}

export def bombardier [] {
  let version = github get_version 'codesenberg/bombardier'

  https download $'https://github.com/codesenberg/bombardier/releases/download/v($version)/bombardier-linux-amd64' -o bombardier
  chmod 766 bombardier
  umv -f 'bombardier'
}

export def ruff [] {
  let version = github get_version 'astral-sh/ruff'

  let bin = bin ruff
  let path = share ruff $version

  if (no-exist $path) {
    https download $'https://github.com/astral-sh/ruff/releases/download/v($version)/ruff-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'ruff-($version)-x86_64-unknown-linux-musl.tar.gz'
    umv -f ruff -p $path
  }

  symlink $path $bin
}

export def micro [] {
  let version = github get_version 'zyedidia/micro'

  https download $'https://github.com/zyedidia/micro/releases/download/v($version)/micro-($version)-linux64.tar.gz'
  extract tar $'micro-($version)-linux64.tar.gz'
  umv -d $'micro-($version)' -f micro
}

export def dufs [] {
  let version = github get_version 'sigoden/dufs'

  https download $'https://github.com/sigoden/dufs/releases/download/v($version)/dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  extract tar $'dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
  umv -f dufs
}

export def miniserve [] {
  let version = github get_version 'svenstaro/miniserve'

  https download $'https://github.com/svenstaro/miniserve/releases/download/v($version)/miniserve-($version)-x86_64-unknown-linux-gnu' -o miniserve
  chmod 755 miniserve
  umv -f miniserve
}

export def onefetch [] {
  let version = github get_version 'o2sh/onefetch'

  https download $'https://github.com/o2sh/onefetch/releases/download/($version)/onefetch-linux.tar.gz'
  extract tar onefetch-linux.tar.gz
  umv -f onefetch
}

export def gping [] {
  let version = github get_version 'orf/gping'

  https download $'https://github.com/orf/gping/releases/download/($version)/gping-x86_64-unknown-linux-musl.tar.gz'
  extract tar gping-x86_64-unknown-linux-musl.tar.gz
  umv -f gping
}

export def duf [] {
  let version = github get_version 'muesli/duf'

  https download https://github.com/muesli/duf/releases/download/v($version)/duf_($version)_linux_x86_64.tar.gz
  extract tar duf_($version)_linux_x86_64.tar.gz -d duf_linux_x86_64
  umv -d duf_linux_x86_64 -f duf
}

export def github [] {
  let version = github get_version 'cli/cli'

  let bin = bin gh
  let path = share gh $version

  if (no-exist $path) {
    https download https://github.com/cli/cli/releases/download/v($version)/gh_($version)_linux_amd64.tar.gz
    extract tar gh_($version)_linux_amd64.tar.gz
    umv -d gh_($version)_linux_amd64 -f bin/gh -p $path
  }

  symlink $path $bin
}

export def gitlab [] {
  let version = "1.46.1"

  let bin = bin glab
  let path = share glab $version

  if (no-exist $path) {
    https download $"https://gitlab.com/gitlab-org/cli/-/releases/v($version)/downloads/glab_($version)_Linux_x86_64.tar.gz"
    extract tar $"glab_($version)_Linux_x86_64.tar.gz" -d glab_Linux_x86_64
    umv -d glab_Linux_x86_64 -f bin/glab -p $path
  }

  symlink $path $bin
}

export def dive [] {
  let version = github get_version 'wagoodman/dive'

  https download https://github.com/wagoodman/dive/releases/download/v($version)/dive_($version)_linux_amd64.tar.gz
  extract tar dive_($version)_linux_amd64.tar.gz -d dive_linux_amd64
  umv -d dive_linux_amd64 -f dive
}

export def hyperfine [] {
  let version = github get_version 'sharkdp/hyperfine'

  https download $'https://github.com/sharkdp/hyperfine/releases/download/v($version)/hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  umv -d $'hyperfine-v($version)-x86_64-unknown-linux-gnu' -f hyperfine
}

export def taskell [] {
  let version = github get_version 'smallhadroncollider/taskell'

  let bin = bin taskell
  let path = share taskell $version

  if (no-exist $path) {
    https download $'https://github.com/smallhadroncollider/taskell/releases/download/($version)/taskell-($version)_x86-64-linux.tar.gz'
    extract tar $'taskell-($version)_x86-64-linux.tar.gz' -d taskell_x86-64-linux
    umv -d taskell_x86-64-linux -f taskell -p $path
  }

  symlink $path $bin
}

export def kubectl [--install] {
  let version = http get https://dl.k8s.io/release/stable.txt

  let bin = bin kubectl
  let path = share kubectl $version

  if (no-exist $path) {
    https download $"https://dl.k8s.io/release/($version)/bin/linux/amd64/kubectl" -o kubectl
    chmod 755 kubectl
    umv -f kubectl -p $path
  }

  if $install {
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  }

  symlink $path $bin
}

export def k9s [] {
  let version = github get_version 'derailed/k9s'

  let bin = bin k9s
  let path = share k9s $version

  if (no-exist $path) {
    https download $"https://github.com/derailed/k9s/releases/download/v($version)/k9s_Linux_amd64.tar.gz"
    extract tar k9s_Linux_amd64.tar.gz -d k9s_Linux_amd64
    umv -d k9s_Linux_amd64 -f k9s -p $path
  }

  symlink $path $bin
}

export def bettercap [] {
  let version = github get_version 'bettercap/bettercap'
  let path = share bettercap $version

  if (no-exist $path) {
    https download $'https://github.com/bettercap/bettercap/releases/download/v($version)/bettercap_linux_amd64_v($version).zip'
    extract zip $'bettercap_linux_amd64_v($version).zip' -d bettercap_linux_amd64
    umv -d 'bettercap_linux_amd64' -f 'bettercap' -p $path
  }

  bind -r bettercap $path
}

export def viddy [] {
  let version = github get_version 'sachaos/viddy'
  let path = share viddy $version

  if (no-exist $path) {
    https download $'https://github.com/sachaos/viddy/releases/download/v($version)/viddy-v($version)-linux-x86_64.tar.gz'
    extract tar $'viddy-v($version)-linux-x86_64.tar.gz'
    umv -f viddy -p $path
  }

  bind viddy $path
}

export def yazi [] {
  let version = github get_version 'sxyazi/yazi'

  https download $'https://github.com/sxyazi/yazi/releases/download/v($version)/yazi-x86_64-unknown-linux-gnu.zip'
  extract zip yazi-x86_64-unknown-linux-gnu.zip
  umv -d yazi-x86_64-unknown-linux-gnu -f yazi
}

export def kmon [] {
  let version = github get_version 'orhun/kmon'

  https download $'https://github.com/orhun/kmon/releases/download/v($version)/kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
  umv -d $'kmon-($version)' -f kmon
}

def "move dir" [src: string, dst: string] {
  mv -p -f $src $dst
}

export def --env ollama [] {
  let version = github get_version 'ollama/ollama'
  let path = share ollama $version

  if (no-exist $path) {
    https download https://github.com/ollama/ollama/releases/download/v0.3.12/ollama-linux-amd64.tgz
    extract tar ollama-linux-amd64.tgz -d ollama-linux-amd64
    move dir ollama-linux-amd64 $path
  }

  env-path $env.OLLAMA_BIN
  symlink $path $env.OLLAMA_PATH
}

export def plandex [] {
  let version = github get_version 'plandex-ai/plandex'

  let bin = bin plandex
  let path = share plandex $version

  if (no-exist $path) {
    https download $"https://github.com/plandex-ai/plandex/releases/download/cli%2Fv($version)/plandex_($version)_linux_amd64.tar.gz"
    extract tar $"plandex_($version)_linux_amd64.tar.gz" -d plandex_linux_amd64
    umv -d plandex_linux_amd64 -f plandex -p $path
  }

  symlink $path $bin
}

export def localAI [] {
  let version = github get_version 'mudler/LocalAI'

  https download https://github.com/mudler/LocalAI/releases/download/($version)/local-ai-avx-Linux-x86_64 -o local-ai
  chmod 755 local-ai
  umv -f local-ai
}

export def lan-mouse [ --desktop(-d), --service(-s) ] {
  let version = github get_version 'feschber/lan-mouse'

  let bin = bin lan-mouse
  let path = share lan-mouse $version

  if (no-exist $path) {
    https download $"https://github.com/feschber/lan-mouse/releases/download/v($version)/lan-mouse" -o lan-mouse
    chmod 777 lan-mouse
    umv -f lan-mouse -p $path
  }

  symlink $path $bin

  if $desktop {
    let src = ($env.NU_BASE_FILES | path join applications lan-mouse.desktop)
    cp $src $env.LOCAL_SHARE_APPLICATIONS
  }

  if $service {
    let src = ($env.CONFIG_SYSTEMD_USER_SRC | path join lan-mouse.service)
    cp $src ~/.config/systemd/user
    systemctl --user daemon-reload
    systemctl --user enable lan-mouse.service
    systemctl --user start lan-mouse.service
  }
}

export def volta [--node] {
  let version = github get_version 'volta-cli/volta'

  https download $'https://github.com/volta-cli/volta/releases/download/v($version)/volta-($version)-linux.tar.gz'
  extract tar $'volta-($version)-linux.tar.gz' -d 'volta-linux'
  umv -d $'volta-($version)-linux' -f '*'

  if $node {
    ^volta install node@latest
  }
}

export def fvm [] {
  let version = github get_version 'leoafarias/fvm'

  let path = share fvm $version
  if (no-exist $path) {
    https download $'https://github.com/leoafarias/fvm/releases/download/($version)/fvm-($version)-linux-x64.tar.gz'
    extract tar $'fvm-($version)-linux-x64.tar.gz'
    umv -d fvm -p $path
  }

  symlink $path $env.FVM_PATH
}

export def lapce [] {
  let version = github get_version 'lapce/lapce'

  let bin = bin lapce
  let path = share lapce $version

  if (no-exist $path) {
    https download https://github.com/lapce/lapce/releases/latest/download/Lapce-linux.tar.gz
    extract tar Lapce-linux.tar.gz
    umv -d Lapce -f lapce -p $path
  }

  symlink $path $bin
}

export def vscodium [] {
  let version = github get_version 'VSCodium/vscodium'

  let path = share vscodium $version
  if (no-exist $path) {
    https download $'https://github.com/VSCodium/vscodium/releases/download/($version)/VSCodium-linux-x64-($version).tar.gz'
    extract tar $'VSCodium-linux-x64-($version).tar.gz' -d vscodium
    umv -d vscodium -p $path
  }

  symlink $path $env.VSCODIUM_PATH
}

export def zed [] {
  (curl https://zed.dev/install.sh | sh)
}

export def code-server [] {
  let version = github get_version 'coder/code-server'

  let path = share code-server $version
  if (no-exist $path) {
    https download $'https://github.com/coder/code-server/releases/download/v($version)/code-server-($version)-linux-amd64.tar.gz'
    extract tar $'code-server-($version)-linux-amd64.tar.gz'
    umv -d $'code-server-($version)-linux-amd64' -p $path
  }

  symlink $path $env.CODE_SERVER_PATH
}

export def termshark [] {
  let version = github get_version 'gcla/termshark'

  https download $'https://github.com/gcla/termshark/releases/download/v($version)/termshark_($version)_linux_x64.tar.gz'
  extract tar $'termshark_($version)_linux_x64.tar.gz'
  umv -d $'termshark_($version)_linux_x64' -f termshark
}

export def termscp [] {
  let version = github get_version 'veeso/termscp'

  https download $'https://github.com/veeso/termscp/releases/download/v($version)/termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
  umv -f termscp
}

export def kbt [] {
  let version = github get_version 'bloznelis/kbt'

  https download $'https://github.com/bloznelis/kbt/releases/download/($version)/kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
  extract tar $'kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
  umv -d $'kbt-($version)-x86_64-unknown-linux-gnu' -f kbt
}

export def trippy [] {
  let version = github get_version 'fujiapple852/trippy'
  let path = share trippy $version

  if (no-exist $path) {
    https download $'https://github.com/fujiapple852/trippy/releases/download/($version)/trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
    umv -d $'trippy-($version)-x86_64-unknown-linux-gnu' -f 'trip' -p $path
  }

  bind -r trippy $path
}

export def gitui [] {
  let version = github get_version 'extrawurst/gitui'

  https download $'https://github.com/extrawurst/gitui/releases/download/v($version)/gitui-linux-musl.tar.gz'
  extract tar gitui-linux-musl.tar.gz
  umv -f gitui
}

export def monolith [] {
  let version = github get_version 'Y2Z/monolith'

  https download https://github.com/Y2Z/monolith/releases/download/v2.7.0/monolith-gnu-linux-x86_64 -o monolith
  chmod 755 monolith
  umv -f monolith
}

export def dijo [] {
  let version = github get_version 'nerdypepper/dijo'

  https download $'https://github.com/nerdypepper/dijo/releases/download/v($version)/dijo-x86_64-linux' -o dijo
  chmod 755 dijo
  umv -f dijo
}

export def ventoy [] {
  let version = '1.0.98'

  let path = share ventoy $version
  if (no-exist $path) {
    https download $'https://github.com/ventoy/Ventoy/releases/download/v($version)/ventoy-($version)-linux.tar.gz'
    extract tar $'ventoy-($version)-linux.tar.gz'
    umv -d $'ventoy-($version)' -p $path
  }

  symlink $path $env.VENTOY_PATH
}

export def stash [] {
  let version = '0.26.2'

  let bin = bin stash
  let path = share stash $version

  if (no-exist $path) {
    https download $'https://github.com/stashapp/stash/releases/download/v($version)/stash-linux' -o stash
    chmod 777 stash
    umv -f stash -p $path
  }

  symlink $path $bin
}

export def AdGuardHome [] {
  let version = github get_version 'AdguardTeam/AdGuardHome'
  let path = share AdGuardHome $version

  if (no-exist $path) {
    https download https://github.com/AdguardTeam/AdGuardHome/releases/download/v($version)/AdGuardHome_linux_amd64.tar.gz
    extract tar AdGuardHome_linux_amd64.tar.gz
    umv -d AdGuardHome -f AdGuardHome -p $path
  }

  bind -r AdGuardHome $path
}

export def superhtml [] {
  let version = github get_version 'kristoff-it/superhtml'
  let path = share superhtml $version

  if (no-exist $path) {
    https download https://github.com/kristoff-it/superhtml/releases/download/v($version)/x86_64-linux-musl.tar.gz
    extract tar x86_64-linux-musl.tar.gz
    umv -d x86_64-linux-musl -f superhtml -p $path
  }

  bind superhtml $path
}

export def mitmproxy [] {
  let version = github get_version 'mitmproxy/mitmproxy'

  let bin = bin mitmproxy
  let path = share mitmproxy $version

  if (no-exist $path) {
    https download wget $'https://downloads.mitmproxy.org/($version)/mitmproxy-($version)-linux-x86_64.tar.gz'
    extract tar $'mitmproxy-($version)-linux-x86_64.tar.gz' -d 'mitmproxy'
    umv -d 'mitmproxy' -p $path
  }

  symlink $path $bin
}

export def hetty [] {
  let version = github get_version 'dstotijn/hetty'

  let bin = bin hetty
  let path = share hetty $version

  if (no-exist $path) {
    https download https://github.com/dstotijn/hetty/releases/download/v($version)/hetty_($version)_Linux_x86_64.tar.gz
    extract tar hetty_($version)_Linux_x86_64.tar.gz -d hetty
    umv -d 'hetty' -f 'hetty' -p $path
  }

  symlink $path $bin
}

export def fclones [] {
  let version = github get_version 'pkolaczk/fclones'

  let bin = bin fclones
  let path = share fclones $version

  if (no-exist $path) {
    https download $"https://github.com/pkolaczk/fclones/releases/download/v($version)/fclones-($version)-linux-musl-x86_64.tar.gz"
    extract tar $"fclones-($version)-linux-musl-x86_64.tar.gz"
    umv -d target -f x86_64-unknown-linux-musl/release/fclones -p $path
    rm -rf target
  }

  symlink $path $bin
}

export def nano-work-server [] {
  let version = github get_version 'nanocurrency/nano-work-server'

  let bin = bin nano-work-server
  let path = share nano-work-server $version

  if (no-exist $path) {
    https download $"https://github.com/nanocurrency/nano-work-server/releases/download/V($version)/nano-work-server" -o nano-work-server
    chmod 755 nano-work-server
    umv -f nano-work-server -p $path
  }

  symlink $path $bin
}

export def devtunnel [] {
  let bin = bin devtunnel
  let path = share devtunnel latest

  if (no-exist $path) {
    https download https://aka.ms/TunnelsCliDownload/linux-x64 -o devtunnel
    chmod 777 devtunnel
    umv -f devtunnel -p $path
  }

  symlink $path $bin
}

export def cloudflared [] {
  let bin = bin cloudflared
  let path = share cloudflared latest

  if (no-exist $path) {
    https download https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
    chmod 777 cloudflared
    umv -f cloudflared -p $path
  }

  symlink $path $bin
}

export def pinggy [] {
  let bin = bin pinggy
  let path = share pinggy latest

  if (no-exist $path) {
    https download https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/v0.1.0-beta.1/linux/amd64/pinggy
    chmod 777 pinggy
    umv -f pinggy -p $path
  }

  symlink $path $bin
}

export def speedtest [] {
  let version = '1.2.0'

  let bin = bin speedtest
  let path = share speedtest $version

  if (no-exist $path) {
    https download $'https://install.speedtest.net/app/cli/ookla-speedtest-($version)-linux-x86_64.tgz'
    extract tar $'ookla-speedtest-($version)-linux-x86_64.tgz' -d 'ookla-speedtest-linux-x86_64'
    umv -d 'ookla-speedtest-linux-x86_64' -f 'speedtest' -p $path
  }

  symlink $path $bin
}

export def nix [] {
  curl -L 'https://nixos.org/nix/install' | bash -s -- --daemon
}

export def devbox [] {
  if (which devbox | is-empty) {
    curl -fsSL 'https://get.jetpack.io/devbox' | bash
  }
}

export def tailscale [] {
  if (which tailscale | is-empty) {
    curl -fsSL 'https://tailscale.com/install.sh' | sh
  }
}

export def deno [] {
  curl -fsSL https://deno.land/install.sh | sh
}

export def --env node [ --latest ] {
  let versions = ["21.2.0" "20.9.0" "18.18.2"]

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = share node $version
  if (no-exist $path) {
    https download $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz'
    extract tar $'node-v($version)-linux-x64.tar.gz'
    umv -d $'node-v($version)-linux-x64' -p $path
  }

  env-path $env.NODE_BIN
  symlink $path $env.NODE_PATH
}

export def --env golang [ --latest ] {
  # https://go.dev/dl/?mode=json
  let versions = ['1.22.2' '1.21.5' '1.20.12' '1.20.3' '1.19.13']

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = share go $version
  if (no-exist $path) {
    https download $'https://go.dev/dl/go($version).linux-amd64.tar.gz'
    extract tar $'go($version).linux-amd64.tar.gz'
    umv -d go -p $path
  }

  env-path $env.GOBIN
  symlink $path $env.GOROOT
}

export def --env rust [ --latest, --force ] {
  if $force or not ("~/.rustup/toolchains" | path exists) {
    # curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh -s -- -q -y
    wget -O- --https-only --secure-protocol=auto --quiet --show-progress https://sh.rustup.rs | sh -s -- -q -y
  }
  env-path $env.CARGOBIN
}

export def haskell [ --latest ] {
  if not ("~/.ghcup" | path exists) {
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  }
}

export def vlang [] {
  let version = 'latest'

  let path = share vlang $version
  if (no-exist $path) {
    https download $'https://github.com/vlang/v/releases/($version)/download/v_linux.zip'
    extract zip v_linux.zip
    umv -d 'v' -p $path
  }

  env-path $env.VLANG_PATH
  symlink $path $env.VLANG_PATH
}

export def --env java [ --latest(-l) ] {
  let versions = [
    [version, build, hash];
    ['21' '35' 'fd2272bbf8e04c3dbaee13770090416c']
    ['17' '35' '0d483333a00540d886896bac774ff48b']
  ]

  let release = if $latest {
    ($versions | first)
  } else {
    let select = choose ($versions | get version)
    if ($select | is-empty) {
      return
    }
    let element = ($versions | where version == $select)
    if ($element | is-empty) {
      return
    }
    ($element | first)
  }

  let hash = ($release | get hash)
  let build = ($release | get build)
  let version = ($release | get version)

  let path = share java $version
  if (no-exist $path) {
    https download $'https://download.java.net/java/GA/jdk($version)/($hash)/($build)/GPL/openjdk-($version)_linux-x64_bin.tar.gz'
    extract tar $'openjdk-($version)_linux-x64_bin.tar.gz'
    umv -d $'jdk-($version)' -p $path
  }

  env-path $env.JAVA_BIN
  symlink $path $env.JAVA_PATH
}

export def --env jdtls [] {
  let path = share jdtls 'latest'
  if (no-exist $path) {
    https download https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz -o jdt-language-server-latest.tar.gz
    extract tar jdt-language-server-latest.tar.gz -d jdtls
    umv -d jdtls -p $path
  }

  env-path $env.JDTLS_BIN
  symlink $path $env.JDTLS_PATH
}

export def --env kotlin [] {
  let version = github get_version 'JetBrains/kotlin'

  let path = share kotlin $version
  if (no-exist $path) {
    https download $"https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-compiler-($version).zip"
    extract zip $"kotlin-compiler-($version).zip"
    umv -d kotlinc -p $path
  }

  env-path $env.KOTLIN_BIN
  symlink $path $env.KOTLIN_PATH
}

export def --env kotlin-native [] {
  let version = github get_version 'JetBrains/kotlin'

  let path = share kotlin-native $version
  if (no-exist $path) {
    https download $"https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-native-prebuilt-linux-x86_64-($version).tar.gz"
    extract tar $'kotlin-native-prebuilt-linux-x86_64-($version).tar.gz'
    umv -d $'kotlin-native-prebuilt-linux-x86_64-($version)' -p $path
  }

  env-path $env.KOTLIN_NATIVE_BIN
  symlink $path $env.KOTLIN_NATIVE_PATH
}

export def --env kotlin-language-server [] {
  let version = github get_version 'fwcd/kotlin-language-server'

  let path = share kotlin-language-server $version
  if (no-exist $path) {
    https download $'https://github.com/fwcd/kotlin-language-server/releases/download/($version)/server.zip'
    extract zip server.zip
    umv -d server -p $path
  }

  env-path $env.KOTLIN_LSP_BIN
  symlink $path $env.KOTLIN_LSP_PATH
}

export def --env lua-language-server [] {
  let version = github get_version 'LuaLS/lua-language-server'
  let path = share lua-language-server $version

  if (no-exist $path) {
    https download $'https://github.com/LuaLS/lua-language-server/releases/download/($version)/lua-language-server-($version)-linux-x64.tar.gz'
    extract tar $'lua-language-server-($version)-linux-x64.tar.gz' -d lua-language-server
    umv -d lua-language-server -p $path
  }

  env-path $env.LUA_LSP_BIN
  symlink $path $env.LUA_LSP_PATH
}

def dart_latest [] {
  http get https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION  | from json | get version
}

export def --env dart [] {
  let version = (dart_latest)

  let path = share dart $version
  if (no-exist $path) {
    https download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip'
    extract zip 'dartsdk-linux-x64-release.zip'
    umv -d 'dart-sdk' -p $path
  }

  env-path $env.DART_BIN
  symlink $path $env.DART_PATH
}

def flutter_latest [] {
  http get https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | get releases | where channel == stable | get version | first
}

export def --env flutter [ --latest(-l) ] {
  let versions = [(flutter_latest) '3.10.6' '3.7.12' '3.0.5' '2.10.5' '2.2.3']

  let version = if $latest {
    ($versions | first)
  } else {
    let select = choose $versions
    if ($select | is-empty) {
      return
    }
    ($select)
  }

  let path = share flutter $version
  if (no-exist $path) {
    https download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz'
    extract tar $'flutter_linux_($version)-stable.tar.xz'
    umv -d 'flutter' -p $path
  }

  env-path $env.FLUTTER_BIN
  symlink $path $env.FLUTTER_PATH
}

export def --env android-studio [ --desktop(-d) ] {
  let version = '2024.1.1.11'

  let path = share android-studio $version
  if (no-exist $path) {
    https download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz'
    extract tar $'android-studio-($version)-linux.tar.gz'
    umv -d android-studio -p $path
  }
  env-path $env.ANDROID_STUDIO_BIN

  symlink $path $env.ANDORID_STUDIO_PATH

  if $desktop {
    let src = ($env.NU_BASE_FILES | path join applications android-studio.desktop)
    cp $src $env.LOCAL_SHARE_APPLICATIONS
  }
}

export def --env android-cmdline-tools [] {
  if not ($env.ANDROID_CMDLINE_TOOLS_PATH | path exists) {
    https download https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    extract zip commandlinetools-linux-11076708_latest.zip
    mkdir ($env.ANDROID_CMDLINE_TOOLS_PATH | path dirname)
    umv -d cmdline-tools -p $env.ANDROID_CMDLINE_TOOLS_PATH
  }
  env-path $env.ANDROID_CMDLINE_TOOLS_BIN
}

export def --env android-platform-tools [] {
  if not ($env.ANDROID_PLATFORM_TOOLS | path exists) {
    https download https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    extract zip platform-tools-latest-linux.zip
    umv -d platform-tools -p $env.ANDROID_PLATFORM_TOOLS
  }
  env-path $env.ANDROID_PLATFORM_TOOLS
}

export def --env bitcoin [] {
  let version = github get_version 'bitcoin/bitcoin'

  let path = share bitcoin $version

  if (no-exist $path) {
    https download $'https://bitcoincore.org/bin/bitcoin-core-($version)/bitcoin-($version)-x86_64-linux-gnu.tar.gz'
    extract tar $'bitcoin-($version)-x86_64-linux-gnu.tar.gz'
    umv -d $'bitcoin-($version)' -p $path
  }

  env-path $env.BITCOIN_BIN
  symlink $path $env.BITCOIN_PATH
}

export def --env lightning-network [] {
  let version = github get_version 'lightningnetwork/lnd'

  let path = share lightning $version

  if (no-exist $path) {
    https download $'https://github.com/lightningnetwork/lnd/releases/download/v($version)/lnd-linux-amd64-v($version).tar.gz'
    extract tar $'lnd-linux-amd64-v($version).tar.gz'
    umv -d $'lnd-linux-amd64-v($version)' -p $path
  }

  env-path $env.LIGHTNING_PATH
  symlink $path $env.LIGHTNING_PATH
}

export def scilab [] {
  let version = '2024.1.0'

  https download $'https://www.scilab.org/download/($version)/scilab-($version).bin.x86_64-linux-gnu.tar.xz'
  extract tar $'scilab-($version).bin.x86_64-linux-gnu.tar.xz'
  umv -d $'scilab-($version)' -p $env.SCILAB_PATH
}

export def remote-mouse [] {
  https download 'https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip'
  extract zip 'RemoteMouse_x86_64.zip' -d 'RemoteMouse_x86_64'
  umv -d 'RemoteMouse_x86_64' -p $env.REMOTE_MOUSE_PATH
  rm ($env.REMOTE_MOUSE_PATH | path join install.sh)
}

export def docker [--group] {
  let version = '26.1.3'

  let bin = bin docker
  let path = share docker $version

  if (no-exist $path) {
    https download https://download.docker.com/linux/static/stable/x86_64/docker-($version).tgz
    extract tar docker-($version).tgz
    umv -f docker -p $path
  }

  if $group {
    sudo groupadd docker
    sudo usermod -aG docker $env.USER
  }

  symlink $path $bin
}

export def core [] {
  xh
  gum
  mods
  glow

  helix
  nushell
  starship
  zoxide
  zellij

  rg
  fd
  bat
  fzf
  jless
  lazygit
  lazydocker

  gdu
  qrcp
  gitu
  ttyper
  bottom
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

def choose [versions: list] {
  if not (^which gum | is-empty) {
    (^gum choose ...$versions)
  } else {
    ($versions | input list)
  }
}

export def firefox-de [] {
  https download https://download-installer.cdn.mozilla.net/pub/devedition/releases/129.0b6/linux-x86_64/es-ES/firefox-129.0b6.tar.bz2
  extract tar firefox-129.0b6.tar.bz2

  sudo mv firefox /opt
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
}

def share [name: string, version: string] {
  $env.USR_LOCAL_SHARE | path join ([$name $version] | str join '_')
}

def bin [name: string] {
  $env.USR_LOCAL_BIN | path join $name
}

def symlink [src: string, dst: string] {
  rm -rf $dst
  ln -sf $src $dst
}

def bind [name: string, src: string, --root(-r)] {
  if $root {
    let dst = ($env.USR_ROOT_BIN | path join $name)
    sudo rm -rf $dst
    sudo ln -sf $src $dst
  }
  let dst = ($env.USR_LOCAL_BIN | path join $name)
  rm -rf $dst
  ln -sf $src $dst
}

def global [src: string, name?: string] {
  let name = if $name != null { $name } else { $src | path basename }
  let dest = ("/usr/local/bin" | path join $name)

  sudo rm -rf $dest
  sudo ln -sf $src $dest
}

def no-exist [path: string] {
 not ($path | path exists)
}

def umv [
  --path(-p): string = "",
  --dir(-d): string = "",
  --file(-f): string = "",
  ] {
  let dest = if ($path | is-empty) {
    ($env.USR_LOCAL_BIN | path join ($file | path basename))
  } else { $path }
  let src = ([$dir, $file] | path join)

  if ($dest | path exists) {
    rm -rf $dest
  }

  mv -f $src $dest

  if ($dir | path exists) {
    rm -rf $dir
  }
}

export def "ubuntu desktop" [] {
  https download https://releases.ubuntu.com/23.10/ubuntu-23.10.1-desktop-amd64.iso
}

export def "ubuntu server" [] {
  https download https://releases.ubuntu.com/23.10/ubuntu-23.10-live-server-amd64.iso
}

export def "ubuntu sway" [] {
  https download https://downloads.ubuntusway.com/stable/23.10/ubuntusway-23.10-desktop-amd64.iso
}

export def "manjaro gnome" [] {
  https download https://download.manjaro.org/gnome/23.1.4/manjaro-gnome-23.1.4-240406-linux66.iso
}

export def "manjaro sway" [] {
  https download https://manjaro-sway.download/download?file=manjaro-sway-23.1.4-240422-linux66.iso -o manjaro-sway-23.1.4-240422-linux66.iso
}

export def "tileOS sway" [] {
  https download https://downloads.tile-os.com/stable/sway/tileos-sway-1.0-desktop-amd64.iso
}

export def "tileOS river" [] {
  https download https://downloads.tile-os.com/stable/river/tileos-river-1.0-desktop-amd64.iso
}
