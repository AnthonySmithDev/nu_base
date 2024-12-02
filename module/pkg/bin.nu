
export def xh [] {
  let version = ghub version 'ducaale/xh'
  let path = share xh $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ducaale/xh/releases/download/v($version)/xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'xh-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'xh-v($version)-x86_64-unknown-linux-musl' -f xh -p $path
  }

  bind file -r xh $path
}

export def helix [] {
  let version = ghub version 'helix-editor/helix'
  let path = share helix $version

  if ($path | path-not-exists) {
    https download $'https://github.com/helix-editor/helix/releases/download/($version)/helix-($version)-x86_64-linux.tar.xz'
    extract tar $'helix-($version)-x86_64-linux.tar.xz'
    move -d $'helix-($version)-x86_64-linux' -p $path
  }

  bind file -r hx ($path | path join hx)
}

export def nushell [] {
  let version = ghub version 'nushell/nushell'
  let path = share nu $version

  if ($path | path-not-exists) {
    https download $'https://github.com/nushell/nushell/releases/download/($version)/nu-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'nu-($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'nu-($version)-x86_64-unknown-linux-gnu' -f nu -p $path
  }

  bind file -r nu $path
}

export def starship [] {
  let version = ghub version 'starship/starship'
  let path = share starship $version

  if ($path | path-not-exists) {
    https download $'https://github.com/starship/starship/releases/download/v($version)/starship-x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'starship-x86_64-unknown-linux-gnu.tar.gz'
    move -f starship -p $path
  }

  bind file -r starship $path
}

export def zoxide [] {
  let version = ghub version 'ajeetdsouza/zoxide'
  let path = share zoxide $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ajeetdsouza/zoxide/releases/download/v($version)/zoxide-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'zoxide-($version)-x86_64-unknown-linux-musl.tar.gz' -d 'zoxide-x86_64-unknown-linux-musl'
    move -d 'zoxide-x86_64-unknown-linux-musl' -f zoxide -p $path
  }

  bind file -r zoxide $path
}

export def zellij [] {
  let version = ghub version 'zellij-org/zellij'
  let path = share zellij $version

  if ($path | path-not-exists) {
    https download $'https://github.com/zellij-org/zellij/releases/download/v($version)/zellij-x86_64-unknown-linux-musl.tar.gz'
    extract tar 'zellij-x86_64-unknown-linux-musl.tar.gz'
    move -f zellij -p $path
  }

  bind file -r zellij $path
}

export def rg [] {
  let version = ghub version 'BurntSushi/ripgrep'
  let path = share rg $version

  if ($path | path-not-exists) {
    https download $'https://github.com/BurntSushi/ripgrep/releases/download/($version)/ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'ripgrep-($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'ripgrep-($version)-x86_64-unknown-linux-musl' -f rg -p $path
  }

  bind file -r rg $path
}

export def fd [] {
  let version = ghub version 'sharkdp/fd'
  let path = share fd $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sharkdp/fd/releases/download/v($version)/fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'fd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'fd-v($version)-x86_64-unknown-linux-gnu' -f fd -p $path
  }

  bind file -r fd $path
}

export def fzf [] {
  let version = ghub version 'junegunn/fzf'
  let path = share fzf $version

  if ($path | path-not-exists) {
    https download $'https://github.com/junegunn/fzf/releases/download/v($version)/fzf-($version)-linux_amd64.tar.gz'
    extract tar $'fzf-($version)-linux_amd64.tar.gz' -d 'fzf-linux_amd64'
    move -d fzf-linux_amd64 -f fzf -p $path
  }

  bind file -r fzf $path
}

export def gum [] {
  let version = ghub version 'charmbracelet/gum'
  let path = share gum $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/gum/releases/download/v($version)/gum_($version)_Linux_x86_64.tar.gz
    extract tar gum_($version)_Linux_x86_64.tar.gz
    move -d gum_($version)_Linux_x86_64 -f gum -p $path
  }

  bind file gum $path
}

export def mods [] {
  let version = ghub version 'charmbracelet/mods'
  let path = share mods $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/mods/releases/download/v($version)/mods_($version)_Linux_x86_64.tar.gz
    extract tar mods_($version)_Linux_x86_64.tar.gz
    move -d mods_($version)_Linux_x86_64 -f mods -p $path
  }

  bind file mods $path
}

export def glow [] {
  let version = ghub version 'charmbracelet/glow'
  let path = share glow $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/glow/releases/download/v($version)/glow_($version)_Linux_x86_64.tar.gz
    extract tar glow_($version)_Linux_x86_64.tar.gz
    move -d glow_($version)_Linux_x86_64 -f glow -p $path
  }

  bind file glow $path
}

export def soft [] {
  let version = ghub version 'charmbracelet/soft-serve'
  let path = share soft $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/soft-serve/releases/download/v($version)/soft-serve_($version)_Linux_x86_64.tar.gz
    extract tar soft-serve_($version)_Linux_x86_64.tar.gz
    move -d soft-serve_($version)_Linux_x86_64 -f soft -p $path
  }

  bind file soft $path
}

export def vhs [] {
  let version = ghub version 'charmbracelet/vhs'
  let path = share vhs $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/vhs/releases/download/v($version)/vhs_($version)_Linux_x86_64.tar.gz
    extract tar vhs_($version)_Linux_x86_64.tar.gz
    move -d vhs_($version)_Linux_x86_64 -f vhs -p $path
  }

  bind file vhs $path
}

export def freeze [] {
  let version = ghub version 'charmbracelet/freeze'
  let path = share freeze $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/freeze/releases/download/v($version)/freeze_($version)_Linux_x86_64.tar.gz
    extract tar freeze_($version)_Linux_x86_64.tar.gz
    move -d freeze_($version)_Linux_x86_64 -f freeze -p $path
  }

  bind file freeze $path
}

export def melt [] {
  let version = ghub version 'charmbracelet/melt'
  let path = share melt $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/melt/releases/download/v($version)/melt_($version)_Linux_x86_64.tar.gz
    extract tar melt_($version)_Linux_x86_64.tar.gz
    move -d melt_($version)_Linux_x86_64 -f melt -p $path
  }

  bind file melt $path
}

export def skate [] {
  let version = ghub version 'charmbracelet/skate'
  let path = share skate $version

  if ($path | path-not-exists) {
    https download https://github.com/charmbracelet/skate/releases/download/v($version)/skate_($version)_Linux_x86_64.tar.gz
    extract tar skate_($version)_Linux_x86_64.tar.gz
    move -d skate_($version)_Linux_x86_64 -f skate -p $path
  }

  bind file skate $path
}

export def --env nvim [] {
  let version = ghub version 'neovim/neovim'
  let path = share nvim $version

  if ($path | path-not-exists) {
    https download $'https://github.com/neovim/neovim/releases/download/v($version)/nvim-linux64.tar.gz'
    extract tar nvim-linux64.tar.gz
    move -f nvim-linux64 -p $path
  }

  bind dir $path $env.NVIM_PATH
  env-path $env.NVIM_BIN
}

export def broot [] {
  let version = ghub version 'Canop/broot'
  let path = share broot $version

  if ($path | path-not-exists) {
    https download https://github.com/Canop/broot/releases/download/v($version)/broot_($version).zip
    extract zip broot_($version).zip -d 'broot'
    move -d 'broot' -f x86_64-linux/broot -p $path
  }

  bind file broot $path
}

export def mirrord [] {
  let version = ghub version 'metalbear-co/mirrord'
  let path = share mirrord $version

  if ($path | path-not-exists) {
    https download $"https://github.com/metalbear-co/mirrord/releases/download/($version)/mirrord_linux_x86_64" -o mirrord
    add-execute mirrord
    move -f mirrord -p $path
  }

  bind file mirrord $path
}

export def gitu [] {
  let version = ghub version 'altsem/gitu'
  let path = share gitu $version

  if ($path | path-not-exists) {
    https download $'https://github.com/altsem/gitu/releases/download/v($version)/gitu-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'gitu-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'gitu-v($version)-x86_64-unknown-linux-gnu' -f gitu -p $path
  }

  bind file gitu $path
}

export def fm [] {
  let version = ghub version 'mistakenelf/fm'
  let path = share fm $version

  if ($path | path-not-exists) {
    https download $"https://github.com/mistakenelf/fm/releases/download/v($version)/fm_($version)_linux_amd64.tar.gz"
    extract tar $"fm_($version)_linux_amd64.tar.gz" -d fm_linux_amd64
    move -d $'fm_linux_amd64' -f fm -p $path
  }

  bind file fm $path
}

export def superfile [] {
  let version = ghub version 'yorukot/superfile'
  let path = share spf $version

  if ($path | path-not-exists) {
    https download $'https://github.com/yorukot/superfile/releases/download/v($version)/superfile-linux-v($version)-amd64.tar.gz'
    extract tar $'superfile-linux-v($version)-amd64.tar.gz'
    move -d dist -f $'superfile-linux-v($version)-amd64/spf' -p $path
  }

  bind file spf $path
}

export def zk [] {
  let version = ghub version 'zk-org/zk'
  let path = share zk $version

  if ($path | path-not-exists) {
    https download $"https://github.com/zk-org/zk/releases/download/v($version)/zk-v($version)-linux-amd64.tar.gz"
    extract tar $"zk-v($version)-linux-amd64.tar.gz" -d zk_linux_amd64
    move -d $'zk_linux_amd64' -f zk -p $path
  }

  bind file zk $path
}

export def hostctl [] {
  let version = ghub version 'guumaster/hostctl'
  let path = share hostctl $version

  if ($path | path-not-exists) {
    https download $"https://github.com/guumaster/hostctl/releases/download/v($version)/hostctl_($version)_linux_64-bit.tar.gz"
    extract tar $'hostctl_($version)_linux_64-bit.tar.gz' -d "hostctl_linux"
    move -d "hostctl_linux" -f hostctl -p $path
  }

  bind file hostctl $path
}

export def bat [] {
  let version = ghub version 'sharkdp/bat'
  let path = share bat $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sharkdp/bat/releases/download/v($version)/bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'bat-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'bat-v($version)-x86_64-unknown-linux-gnu' -f bat -p $path
  }

  bind file bat $path
}

export def gdu [] {
  let version = ghub version 'dundee/gdu'
  let path = share gdu $version

  if ($path | path-not-exists) {
    https download $'https://github.com/dundee/gdu/releases/download/v($version)/gdu_linux_amd64.tgz'
    extract tar 'gdu_linux_amd64.tgz'
    move -f gdu_linux_amd64 -p $path
  }

  bind file -r gdu $path
}

export def task [] {
  let version = ghub version 'go-task/task'
  let path = share task $version

  if ($path | path-not-exists) {
    https download $"https://github.com/go-task/task/releases/download/v($version)/task_linux_amd64.tar.gz"
    extract tar task_linux_amd64.tar.gz -d task_linux_amd64
    move -d task_linux_amd64 -f task -p $path
  }

  bind file -r task $path
}

export def mouseless [] {
  let version = ghub version 'jbensmann/mouseless'
  let path = share mouseless $version

  if ($path | path-not-exists) {
    https download $'https://github.com/jbensmann/mouseless/releases/download/v($version)/mouseless-linux-amd64.tar.gz'
    extract tar mouseless-linux-amd64.tar.gz
    move -d dist -f mouseless -p $path
  }

  bind file -r mouseless $path
}

export def websocat [] {
  let version = ghub version 'vi/websocat'
  let path = share websocat latest
  # let path = share websocat $version

  if ($path | path-not-exists) {
    https download https://github.com/vi/websocat/releases/download/v4.0.0-alpha1/websocat4.x86_64-unknown-linux-musl -o websocat
    # https download $'https://github.com/vi/websocat/releases/download/v($version)/websocat.x86_64-unknown-linux-musl' -o websocat
    add-execute websocat
    move -f websocat -p $path
  }

  bind file websocat $path
}

export def --env amber [] {
  let version = ghub version 'dalance/amber'
  let path = share amber $version

  if ($path | path-not-exists) {
    https download $'https://github.com/dalance/amber/releases/download/v($version)/amber-v($version)-x86_64-lnx.zip'
    extract zip $'amber-v($version)-x86_64-lnx.zip' -d 'amber-x86_64-lnx'
    move -d 'amber-x86_64-lnx' -p $path
  }

  bind dir $path $env.AMBER_BIN
  env-path $env.AMBER_BIN
}

export def obsidian-cli [] {
  let version = ghub version 'Yakitrak/obsidian-cli'
  let path = share obsidian-cli $version

  if ($path | path-not-exists) {
    https download $'https://github.com/Yakitrak/obsidian-cli/releases/download/v($version)/obsidian-cli_($version)_linux_amd64.tar.gz'
    extract tar $"obsidian-cli_($version)_linux_amd64.tar.gz" -d "obsidian-cli_linux_amd64"
    move -d obsidian-cli_linux_amd64 -f obsidian-cli -p $path
  }

  bind file obsidian-cli $path
}

export def lazygit [] {
  let version = ghub version 'jesseduffield/lazygit'
  let path = share lazygit $version

  if ($path | path-not-exists) {
    https download $'https://github.com/jesseduffield/lazygit/releases/download/v($version)/lazygit_($version)_Linux_x86_64.tar.gz'
    extract tar $'lazygit_($version)_Linux_x86_64.tar.gz' -d 'lazygit_Linux_x86_64'
    move -d lazygit_Linux_x86_64 -f lazygit -p $path
  }

  bind file lazygit $path
}

export def lazydocker [] {
  let version = ghub version 'jesseduffield/lazydocker'
  let path = share lazydocker $version

  if ($path | path-not-exists) {
    https download $'https://github.com/jesseduffield/lazydocker/releases/download/v($version)/lazydocker_($version)_Linux_x86_64.tar.gz'
    extract tar $'lazydocker_($version)_Linux_x86_64.tar.gz' -d 'lazydocker_Linux_x86_64'
    move -d lazydocker_Linux_x86_64 -f lazydocker -p $path
  }

  bind file lazydocker $path
}

export def oxker [] {
  let version = ghub version 'mrjackwills/oxker'
  let path = share oxker $version

  if ($path | path-not-exists) {
    https download https://github.com/mrjackwills/oxker/releases/download/v($version)/oxker_linux_x86_64.tar.gz
    extract tar oxker_linux_x86_64.tar.gz
    move -f oxker -p $path
  }

  bind file oxker $path
}

export def lazycli [] {
  let version = ghub version 'jesseduffield/lazycli'
  let path = share lazycli $version

  if ($path | path-not-exists) {
    https download https://github.com/jesseduffield/lazycli/releases/download/v($version)/lazycli-linux-x64.tar.gz
    extract tar lazycli-linux-x64.tar.gz
    move -f lazycli -p $path
  }

  bind file lazycli $path
}

export def horcrux [] {
  let version = ghub version 'jesseduffield/horcrux'
  let path = share horcrux $version

  if ($path | path-not-exists) {
    https download https://github.com/jesseduffield/horcrux/releases/download/v($version)/horcrux_($version)_Linux_x86_64.tar.gz
    extract tar horcrux_($version)_Linux_x86_64.tar.gz -d horcrux_Linux_x86_64
    move -d horcrux_Linux_x86_64 -f horcrux -p $path
  }

  bind file horcrux $path
}

export def tweety [] {
  let version = ghub version 'pomdtr/tweety'
  let path = share tweety $version

  if ($path | path-not-exists) {
    https download $'https://github.com/pomdtr/tweety/releases/download/v($version)/tweety-($version)-linux_amd64.tar.gz'
    extract tar $'tweety-($version)-linux_amd64.tar.gz' -d tweety-linux_amd64
    move -d tweety-linux_amd64 -f tweety -p $path
  }

  bind file tweety $path
}

export def podman-tui [] {
  let version = ghub version 'containers/podman-tui'
  let path = share podman-tui $version

  if ($path | path-not-exists) {
    https download https://github.com/containers/podman-tui/releases/download/v1.2.3/podman-tui-release-linux_amd64.zip
    extract zip podman-tui-release-linux_amd64.zip
    move -d podman-tui-release-linux_amd64 -f podman-tui-($version)/podman-tui -p $path
  }

  bind file -r podman-tui $path
}

export def jless [] {
  let version = ghub version 'PaulJuliusMartinez/jless'
  let path = share jless $version

  if ($path | path-not-exists) {
    https download $'https://github.com/PaulJuliusMartinez/jless/releases/download/v($version)/jless-v($version)-x86_64-unknown-linux-gnu.zip'
    extract zip $'jless-v($version)-x86_64-unknown-linux-gnu.zip' -d 'jless-x86_64-unknown-linux-gnu'
    move -d jless-x86_64-unknown-linux-gnu -f jless -p $path
  }

  bind file jless $path
}

export def silicon [] {
  let version = ghub version 'Aloxaf/silicon'
  let path = share silicon $version

  if ($path | path-not-exists) {
    https download $'https://github.com/Aloxaf/silicon/releases/download/v($version)/silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'silicon-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -f silicon -p $path
  }

  bind file silicon $path
}

export def dasel [] {
  let version = ghub version 'TomWright/dasel'
  let path = share dasel $version

  if ($path | path-not-exists) {
    https download $"https://github.com/TomWright/dasel/releases/download/v($version)/dasel_linux_amd64" -o dasel
    add-execute dasel
    move -f dasel -p $path
  }

  bind file dasel $path
}

export def pueue [] {
  let version = ghub version 'Nukesor/pueue'

  let path = share pueue $version
  if ($path | path-not-exists) {
    https download https://github.com/Nukesor/pueue/releases/download/v($version)/pueue-x86_64-unknown-linux-musl -o pueue
    add-execute pueue
    move -f pueue -p $path
  }
  bind file pueue $path

  let path = share pueued $version
  if ($path | path-not-exists) {
    https download https://github.com/Nukesor/pueue/releases/download/v($version)/pueued-x86_64-unknown-linux-musl -o pueued
    add-execute pueued
    move -f pueued -p $path
  }
  bind file pueued $path
}

export def delta [] {
  let version = ghub version 'dandavison/delta'
  let path = share delta $version

  if ($path | path-not-exists) {
    https download $'https://github.com/dandavison/delta/releases/download/($version)/delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'delta-($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'delta-($version)-x86_64-unknown-linux-gnu' -f delta -p $path
  }

  bind file delta $path
}

export def difftastic [] {
  let version = ghub version 'Wilfred/difftastic'
  let path = share difft $version

  if ($path | path-not-exists) {
    https download https://github.com/Wilfred/difftastic/releases/download/($version)/difft-x86_64-unknown-linux-gnu.tar.gz
    extract tar difft-x86_64-unknown-linux-gnu.tar.gz -d difftastic
    move -d difftastic -f difft -p $path
  }

  bind file difft $path
}

export def bottom [] {
  let version = ghub version 'ClementTsang/bottom'
  let path = share btm $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ClementTsang/bottom/releases/download/($version)/bottom_x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'bottom_x86_64-unknown-linux-gnu.tar.gz' -d 'bottom_x86_64-unknown-linux-gnu'
    move -d 'bottom_x86_64-unknown-linux-gnu' -f btm -p $path
  }

  bind file btm $path
}

export def ttyper [] {
  let version = ghub version 'max-niederman/ttyper'
  let path = share ttyper $version

  if ($path | path-not-exists) {
    https download $'https://github.com/max-niederman/ttyper/releases/download/v($version)/ttyper-x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'ttyper-x86_64-unknown-linux-gnu.tar.gz' -d 'ttyper-x86_64-unknown-linux-gnu'
    move -d 'ttyper-x86_64-unknown-linux-gnu' -f ttyper -p $path
  }

  bind file ttyper $path
}

export def qrcp [] {
  let version = ghub version 'claudiodangelis/qrcp'
  let path = share qrcp $version

  if ($path | path-not-exists) {
    https download $'https://github.com/claudiodangelis/qrcp/releases/download/($version)/qrcp_($version)_linux_amd64.tar.gz'
    extract tar qrcp_($version)_linux_amd64.tar.gz -d qrcp_linux_amd64
    move -d qrcp_linux_amd64 -f qrcp -p $path
  }

  bind file qrcp $path
}

export def qrsync [] {
  let version = ghub version 'crisidev/qrsync'
  let path = share qrsync $version

  if ($path | path-not-exists) {
    https download $'https://github.com/crisidev/qrsync/releases/download/v($version)/qrsync-x86_64-unknown-linux-gnu.tar.gz'
    extract tar qrsync-x86_64-unknown-linux-gnu.tar.gz
    move -f qrsync -p $path
  }

  bind file qrsync $path
}

export def binsider [] {
  let version = ghub version 'orhun/binsider'
  let path = share binsider $version

  if ($path | path-not-exists) {
    https download $'https://github.com/orhun/binsider/releases/download/v($version)/binsider-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'binsider-($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'binsider-($version)' -f binsider -p $path
  }

  bind file binsider $path
}

export def usql [] {
  let version = ghub version 'xo/usql'
  let path = share usql $version

  if ($path | path-not-exists) {
    https download $'https://github.com/xo/usql/releases/download/v($version)/usql-($version)-linux-amd64.tar.bz2'
    extract tar $'usql-($version)-linux-amd64.tar.bz2' -d 'usql-linux-amd64'
    move -d 'usql-linux-amd64' -f usql -p $path
  }

  bind file usql $path
}

export def atlas [--eula] {
  let version = ghub version 'ariga/atlas'
  let path = share atlas $version

  if ($path | path-not-exists) {
    let filename = if $eula {
      "atlas-linux-amd64-latest"
    } else {
      "atlas-community-linux-amd64-latest"
    }
    https download $"https://release.ariga.io/atlas/($filename)" -o atlas
    add-execute atlas
    move -f atlas -p $path
  }

  bind file atlas $path
}

export def gotty [] {
  let version = ghub version 'yudai/gotty'
  let path = share atlas $version

  if ($path | path-not-exists) {
    https download $'https://github.com/yudai/gotty/releases/download/v($version)/gotty_linux_amd64.tar.gz'
    extract tar gotty_linux_amd64.tar.gz
    move -f gotty -p $path
  }

  bind file gotty $path
}

export def ttyd [] {
  let version = ghub version 'tsl0922/ttyd'
  let path = share ttyd $version

  if ($path | path-not-exists) {
    https download https://github.com/tsl0922/ttyd/releases/download/($version)/ttyd.x86_64 -o ttyd
    add-execute ttyd
    move -f ttyd -p $path
  }

  bind file ttyd $path
}

export def tty-share [] {
  let version = ghub version 'elisescu/tty-share'
  let path = share tty-share $version

  if ($path | path-not-exists) {
    https download $'https://github.com/elisescu/tty-share/releases/download/v($version)/tty-share_linux-amd64' -o tty-share
    add-execute tty-share
    move -f tty-share -p $path
  }

  bind file tty-share $path
}

export def upterm [] {
  let version = ghub version 'owenthereal/upterm'
  let path = share upterm $version

  if ($path | path-not-exists) {
    https download $'https://github.com/owenthereal/upterm/releases/download/v($version)/upterm_linux_amd64.tar.gz'
    extract tar 'upterm_linux_amd64.tar.gz' -d upterm_linux_amd64
    move -d 'upterm_linux_amd64' -f upterm -p $path
  }

  bind file upterm $path
}

export def --env sftpgo [] {
  let version = ghub version 'drakkan/sftpgo'
  let path = share sftpgo $version

  if ($path | path-not-exists) {
    https download https://github.com/drakkan/sftpgo/releases/download/v($version)/sftpgo_v($version)_linux_x86_64.tar.xz
    extract tar sftpgo_v($version)_linux_x86_64.tar.xz -d sftpgo_linux_x86_64
    move -d sftpgo_linux_x86_64 -p $path
  }

  bind dir $path $env.SFTPGO_PATH
  env-path $env.SFTPGO_PATH
}

export def telegram [] {
  let version = ghub version 'telegramdesktop/tdesktop'
  let path = share telegram $version

  if ($path | path-not-exists) {
    https download $'https://github.com/telegramdesktop/tdesktop/releases/download/v($version)/tsetup.($version).tar.xz'
    extract tar $'tsetup.($version).tar.xz'
    move -d Telegram -f Telegram -p $path
  }

  bind file telegram $path
}

export def tdl [] {
  let version = ghub version 'iyear/tdl'
  let path = share tdl $version

  if ($path | path-not-exists) {
    https download $'https://github.com/iyear/tdl/releases/download/v($version)/tdl_Linux_64bit.tar.gz'
    extract tar tdl_Linux_64bit.tar.gz -d tdl_Linux_64bit
    move -d tdl_Linux_64bit -f tdl -p $path
  }

  bind file tdl $path
}

export def kanata [] {
  let version = ghub version 'jtroo/kanata'
  let path = share kanata $version

  if ($path | path-not-exists) {
    https download $"https://github.com/jtroo/kanata/releases/download/v($version)/kanata" -o kanata
    add-execute kanata
    move -f kanata -p $path
  }

  bind file -r kanata $path
}

export def --env mongosh [] {
  let version = '2.3.1'
  let path = share mongosh $version

  if ($path | path-not-exists) {
    https download $"https://downloads.mongodb.com/compass/mongosh-($version)-linux-x64.tgz"
    extract tar $"mongosh-($version)-linux-x64.tgz"
    mv $"mongosh-($version)-linux-x64/bin" $path
  }

  bind dir $path $env.MONGOSH_BIN
  env-path $env.MONGOSH_BIN
}

export def shell2http [] {
  let version = ghub version 'msoap/shell2http'
  let path = share shell2http $version

  if ($path | path-not-exists) {
    https download $'https://github.com/msoap/shell2http/releases/download/v($version)/shell2http_($version)_linux_amd64.tar.gz'
    extract tar $'shell2http_($version)_linux_amd64.tar.gz' -d 'shell2http_linux_amd64'
    move -d 'shell2http_linux_amd64' -f shell2http -p $path
  }

  bind file shell2http $path
}

export def mprocs [] {
  let version = ghub version 'pvolok/mprocs'
  let path = share mprocs $version

  if ($path | path-not-exists) {
    https download $'https://github.com/pvolok/mprocs/releases/download/v($version)/mprocs-($version)-linux-x86_64-musl.tar.gz'
    extract tar $'mprocs-($version)-linux-x86_64-musl.tar.gz'
    move -f mprocs -p $path
  }

  bind file mprocs $path
}

export def dua [] {
  let version = ghub version 'Byron/dua-cli'
  let path = share dua $version

  if ($path | path-not-exists) {
    https download $'https://github.com/Byron/dua-cli/releases/download/v($version)/dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'dua-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'dua-v($version)-x86_64-unknown-linux-musl' -f dua -p $path
  }

  bind file dua $path
}

export def grex [] {
  let version = ghub version 'pemistahl/grex'
  let path = share grex $version

  if ($path | path-not-exists) {
    https download $'https://github.com/pemistahl/grex/releases/download/v($version)/grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'grex-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -f grex -p $path
  }

  bind file grex $path
}

export def navi [] {
  let version = ghub version 'denisidoro/navi'
  let path = share navi $version

  if ($path | path-not-exists) {
    https download $'https://github.com/denisidoro/navi/releases/download/v($version)/navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'navi-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -f navi -p $path
  }

  bind file navi $path
}

export def bore [] {
  let version = ghub version 'ekzhang/bore'
  let path = share bore $version

  if ($path | path-not-exists) {
    https download $"https://github.com/ekzhang/bore/releases/download/v($version)/bore-v($version)-x86_64-unknown-linux-musl.tar.gz"
    extract tar $"bore-v($version)-x86_64-unknown-linux-musl.tar.gz"
    move -f bore -p $path
  }

  bind file bore $path
}

export def rclone [] {
  let version = ghub version 'rclone/rclone'
  let path = share rclone $version

  if ($path | path-not-exists) {
    https download $'https://github.com/rclone/rclone/releases/download/v($version)/rclone-v($version)-linux-amd64.zip'
    extract zip $'rclone-v($version)-linux-amd64.zip'
    move -d $'rclone-v($version)-linux-amd64' -f rclone -p $path
  }

  bind file -r rclone $path
}

export def ffsend [] {
  let version = ghub version 'timvisee/ffsend'
  let path = share ffsend $version

  if ($path | path-not-exists) {
    https download $'https://github.com/timvisee/ffsend/releases/download/v($version)/ffsend-v($version)-linux-x64-static' -o ffsend
    add-execute ffsend
    move -f ffsend -p $path
  }

  bind file ffsend $path
}

export def walk [] {
  let version = ghub version 'antonmedv/walk'
  let path = share walk $version

  if ($path | path-not-exists) {
    https download $'https://github.com/antonmedv/walk/releases/download/v($version)/walk_linux_amd64' -o walk
    add-execute walk
    move -f walk -p $path
  }

  bind file walk $path
}

export def tere [] {
  let version = ghub version 'mgunyho/tere'
  let path = share tere $version

  if ($path | path-not-exists) {
    https download $'https://github.com/mgunyho/tere/releases/download/v($version)/tere-($version)-x86_64-unknown-linux-gnu.zip'
    extract zip $'tere-($version)-x86_64-unknown-linux-gnu.zip'
    move -f tere -p $path
  }

  bind file tere $path
}

export def sd [] {
  let version = ghub version 'chmln/sd'
  let path = share sd $version

  if ($path | path-not-exists) {
    https download $'https://github.com/chmln/sd/releases/download/v($version)/sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'sd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'sd-v($version)-x86_64-unknown-linux-gnu' -f sd -p $path
  }

  bind file sd $path
}

export def sad [] {
  let version = ghub version 'ms-jpq/sad'
  let path = share sad $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ms-jpq/sad/releases/download/v($version)/x86_64-unknown-linux-gnu.zip'
    extract zip 'x86_64-unknown-linux-gnu.zip'
    move -f sad -p $path
  }

  bind file sad $path
}

export def fx [] {
  let version = ghub version 'antonmedv/fx'
  let path = share fx $version

  if ($path | path-not-exists) {
    https download $'https://github.com/antonmedv/fx/releases/download/($version)/fx_linux_amd64' -o fx
    add-execute fx
    move -f fx -p $path
  }

  bind file fx $path
}

export def jqp [] {
  let version = ghub version 'noahgorstein/jqp'
  let path = share jqp $version

  if ($path | path-not-exists) {
    https download $'https://github.com/noahgorstein/jqp/releases/download/v($version)/jqp_Linux_x86_64.tar.gz'
    extract tar jqp_Linux_x86_64.tar.gz -d jqp_Linux_x86_64
    move -d jqp_Linux_x86_64 -f jqp -p $path
  }

  bind file jqp $path
}

export def lux [] {
  let version = ghub version 'iawia002/lux'
  let path = share lux $version

  if ($path | path-not-exists) {
    https download $'https://github.com/iawia002/lux/releases/download/v($version)/lux_($version)_Linux_x86_64.tar.gz'
    extract tar $'lux_($version)_Linux_x86_64.tar.gz'
    move -f lux -p $path
  }

  bind file lux $path
}

export def qrterminal [] {
  let version = ghub version 'mdp/qrterminal'
  let path = share qrterminal $version

  if ($path | path-not-exists) {
    https download https://github.com/mdp/qrterminal/releases/download/v($version)/qrterminal_Linux_x86_64.tar.gz
    extract tar qrterminal_Linux_x86_64.tar.gz -d qrterminal_Linux_x86_64
    move -d qrterminal_Linux_x86_64 -f qrterminal -p $path
  }

  bind file qrterminal $path
}

export def qrrs [] {
  let version = ghub version 'Lenivaya/qrrs'
  let path = share qrrs $version

  if ($path | path-not-exists) {
    https download https://github.com/Lenivaya/qrrs/releases/download/v($version)/qrrs-x86_64-unknown-linux-musl.tar.gz
    extract tar qrrs-x86_64-unknown-linux-musl.tar.gz
    move -f qrrs -p $path
  }

  bind file qrrs $path
}

export def genact [] {
  let version = ghub version 'svenstaro/genact'
  let path = share genact $version

  if ($path | path-not-exists) {
    https download $'https://github.com/svenstaro/genact/releases/download/v($version)/genact-($version)-x86_64-unknown-linux-gnu' -o genact
    add-execute genact
    move -f genact -p $path
  }

  bind file genact $path
}

export def ouch [] {
  let version = ghub version 'ouch-org/ouch'
  let path = share ouch $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ouch-org/ouch/releases/download/($version)/ouch-x86_64-unknown-linux-gnu.tar.gz'
    extract tar 'ouch-x86_64-unknown-linux-gnu.tar.gz'
    move -d 'ouch-x86_64-unknown-linux-gnu' -f ouch -p $path
  }

  bind file ouch $path
}

export def lsd [] {
  let version = ghub version 'lsd-rs/lsd'
  let path = share lsd $version

  if ($path | path-not-exists) {
    https download $'https://github.com/lsd-rs/lsd/releases/download/v($version)/lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'lsd-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'lsd-v($version)-x86_64-unknown-linux-gnu' -f lsd -p $path
  }

  bind file lsd $path
}

export def ast-grep [] {
  let version = ghub version 'ast-grep/ast-grep'
  let path = share sg $version

  if ($path | path-not-exists) {
    https download https://github.com/ast-grep/ast-grep/releases/download/($version)/sg-x86_64-unknown-linux-gnu.zip
    extract zip sg-x86_64-unknown-linux-gnu.zip
    move -f sg -p $path
  }

  bind file sg $path
}

export def d2 [] {
  let version = ghub version 'terrastruct/d2'
  let path = share d2 $version

  if ($path | path-not-exists) {
    https download $'https://github.com/terrastruct/d2/releases/download/v($version)/d2-v($version)-linux-amd64.tar.gz'
    extract tar $'d2-v($version)-linux-amd64.tar.gz'
    move -d $'d2-v($version)' -f bin/d2 -p $path
  }

  bind file d2 $path
}

export def mdcat [] {
  let version = ghub version 'swsnr/mdcat'
  let path = share mdcat $version

  if ($path | path-not-exists) {
    https download $'https://github.com/swsnr/mdcat/releases/download/($version)/($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'($version)-x86_64-unknown-linux-musl' -f mdcat -p $path
  }

  bind file mdcat $path
}

export def chatgpt [] {
  let version = ghub version 'j178/chatgpt'
  let path = share chatgpt $version

  if ($path | path-not-exists) {
    https download $'https://github.com/j178/chatgpt/releases/download/v($version)/chatgpt_Linux_x86_64.tar.gz'
    extract tar 'chatgpt_Linux_x86_64.tar.gz' -d 'chatgpt_Linux_x86_64'
    move -d 'chatgpt_Linux_x86_64' -f chatgpt -p $path
  }

  bind file chatgpt $path
}

export def aichat [] {
  let version = ghub version 'sigoden/aichat'
  let path = share aichat $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sigoden/aichat/releases/download/v($version)/aichat-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'aichat-v($version)-x86_64-unknown-linux-musl.tar.gz' -d aichat-x86_64-unknown-linux-musl
    move -d aichat-x86_64-unknown-linux-musl -f aichat -p $path
  }

  bind file aichat $path
}

export def tgpt [] {
  let version = '2.2.1'
  let path = share tgpt $version

  if ($path | path-not-exists) {
    https download https://github.com/aandrew-me/tgpt/releases/download/v($version)/tgpt-linux-amd64 -o tgpt
    add-execute tgpt
    move -f tgpt -p $path
  }

  bind file tgpt $path
}

export def slices [] {
  let version = ghub version 'maaslalani/slides'
  let path = share slices $version

  if ($path | path-not-exists) {
    https download $'https://github.com/maaslalani/slides/releases/download/v($version)/slides_($version)_linux_amd64.tar.gz'
    extract tar $'slides_($version)_linux_amd64.tar.gz' -d slides_linux_amd64
    move -d slides_linux_amd64 -f slides -p $path
  }

  bind file slices $path
}

export def nap [] {
  let version = ghub version 'maaslalani/nap'
  let path = share nap $version

  if ($path | path-not-exists) {
    https download $'https://github.com/maaslalani/nap/releases/download/v($version)/nap_($version)_linux_amd64.tar.gz'
    extract tar $'nap_($version)_linux_amd64.tar.gz' -d nap_linux_amd64
    move -d nap_linux_amd64 -f nap -p $path
  }

  bind file nap $path
}

export def invoice [] {
  let version = ghub version 'maaslalani/invoice'
  let path = share invoice $version

  if ($path | path-not-exists) {
    https download $'https://github.com/maaslalani/invoice/releases/download/v($version)/invoice_($version)_linux_amd64.tar.gz'
    extract tar $'invoice_($version)_linux_amd64.tar.gz' -d invoice_linux_amd64
    move -d invoice_linux_amd64 -f invoice -p $path
  }

  bind file invoice $path
}

export def coreutils [] {
  let version = ghub version 'uutils/coreutils'
  let path = share coreutils $version

  if ($path | path-not-exists) {
    https download $'https://github.com/uutils/coreutils/releases/download/($version)/coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'coreutils-($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'coreutils-($version)-x86_64-unknown-linux-musl' -f coreutils -p $path
  }

  bind file coreutils $path
}

export def carapace [] {
  let version = ghub version 'rsteube/carapace-bin'
  let path = share carapace $version

  if ($path | path-not-exists) {
    https download $'https://github.com/rsteube/carapace-bin/releases/download/v($version)/carapace-bin_linux_amd64.tar.gz'
    extract tar 'carapace-bin_linux_amd64.tar.gz' -d 'carapace-bin_linux_amd64'
    move -d 'carapace-bin_linux_amd64' -f carapace -p $path
  }

  bind file carapace $path
}

export def bombardier [] {
  let version = ghub version 'codesenberg/bombardier'
  let path = share bombardier $version

  if ($path | path-not-exists) {
    https download $'https://github.com/codesenberg/bombardier/releases/download/v($version)/bombardier-linux-amd64' -o bombardier
    add-execute bombardier
    move -f bombardier -p $path
  }

  bind file bombardier $path
}

export def ruff [] {
  let version = ghub version 'astral-sh/ruff'
  let path = share ruff $version

  if ($path | path-not-exists) {
    https download $'https://github.com/astral-sh/ruff/releases/download/v($version)/ruff-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'ruff-($version)-x86_64-unknown-linux-musl.tar.gz'
    move -f ruff -p $path
  }

  bind file ruff $path
}

export def --env uv [] {
  let version = ghub version 'astral-sh/uv'
  let path = share uv $version

  if ($path | path-not-exists) {
    https download https://github.com/astral-sh/uv/releases/download/($version)/uv-x86_64-unknown-linux-musl.tar.gz
    extract tar uv-x86_64-unknown-linux-musl.tar.gz
    move -d uv-x86_64-unknown-linux-musl -p $path
  }

  bind dir $path $env.UV_BIN
  env-path $env.UV_BIN
}

export def micro [] {
  let version = ghub version 'zyedidia/micro'
  let path = share micro $version

  if ($path | path-not-exists) {
    https download $'https://github.com/zyedidia/micro/releases/download/v($version)/micro-($version)-linux64.tar.gz'
    extract tar $'micro-($version)-linux64.tar.gz'
    move -d $'micro-($version)' -f micro -p $path
  }

  bind file micro $path
}

export def dufs [] {
  let version = ghub version 'sigoden/dufs'
  let path = share dufs $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sigoden/dufs/releases/download/v($version)/dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'dufs-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -f dufs -p $path
  }

  bind file dufs $path
}

export def miniserve [] {
  let version = ghub version 'svenstaro/miniserve'
  let path = share miniserve $version

  if ($path | path-not-exists) {
    https download $'https://github.com/svenstaro/miniserve/releases/download/v($version)/miniserve-($version)-x86_64-unknown-linux-gnu' -o miniserve
    add-execute miniserve
    move -f miniserve -p $path
  }

  bind file miniserve $path
}

export def simple-http-server [] {
  let version = ghub version 'TheWaWaR/simple-http-server'
  let path = share simple-http-server $version

  if ($path | path-not-exists) {
    https download https://github.com/TheWaWaR/simple-http-server/releases/download/v($version)/x86_64-unknown-linux-musl-simple-http-server -o simple-http-server
    add-execute simple-http-server
    move -f simple-http-server -p $path
  }

  bind file simple-http-server $path
}

export def ftpserver [] {
  let version = ghub version 'fclairamb/ftpserver'
  let path = share ftpserver $version

  if ($path | path-not-exists) {
    https download https://github.com/fclairamb/ftpserver/releases/download/v($version)/ftpserver_($version)_linux_amd64.tar.gz
    extract tar ftpserver_($version)_linux_amd64.tar.gz -d ftpserver_linux_amd64
    move -d ftpserver_linux_amd64 -f ftpserver -p $path
  }

  bind file ftpserver $path
}

export def onefetch [] {
  let version = ghub version 'o2sh/onefetch'
  let path = share onefetch $version

  if ($path | path-not-exists) {
    https download $'https://github.com/o2sh/onefetch/releases/download/($version)/onefetch-linux.tar.gz'
    extract tar onefetch-linux.tar.gz
    move -f onefetch -p $path
  }

  bind file onefetch $path
}

export def gping [] {
  let version = ghub version 'orf/gping'
  let path = share gping $version

  if ($path | path-not-exists) {
    https download $'https://github.com/orf/gping/releases/download/($version)/gping-x86_64-unknown-linux-musl.tar.gz'
    extract tar gping-x86_64-unknown-linux-musl.tar.gz
    move -f gping -p $path
  }

  bind file gping $path
}

export def duf [] {
  let version = ghub version 'muesli/duf'
  let path = share duf $version

  if ($path | path-not-exists) {
    https download https://github.com/muesli/duf/releases/download/v($version)/duf_($version)_linux_x86_64.tar.gz
    extract tar duf_($version)_linux_x86_64.tar.gz -d duf_linux_x86_64
    move -d duf_linux_x86_64 -f duf -p $path
  }

  bind file duf $path
}

export def github [] {
  let version = ghub version 'cli/cli'
  let path = share gh $version

  if ($path | path-not-exists) {
    https download https://github.com/cli/cli/releases/download/v($version)/gh_($version)_linux_amd64.tar.gz
    extract tar gh_($version)_linux_amd64.tar.gz
    move -d gh_($version)_linux_amd64 -f bin/gh -p $path
  }

  bind file gh $path
}

export def gitlab [] {
  let version = '1.49.0'
  let path = share glab $version

  if ($path | path-not-exists) {
    https download https://gitlab.com/gitlab-org/cli/-/releases/v($version)/downloads/glab_($version)_linux_amd64.tar.gz
    extract tar glab_($version)_linux_amd64.tar.gz -d glab_linux_amd64
    move -d glab_linux_amd64 -f bin/glab -p $path
  }

  bind file glab $path
}

export def gitlab-runner [] {
  sudo curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"
  sudo chmod 777 /usr/local/bin/gitlab-runner
  sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
  sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
  sudo gitlab-runner start
}

export def dive [] {
  let version = ghub version 'wagoodman/dive'
  let path = share dive $version

  if ($path | path-not-exists) {
    https download https://github.com/wagoodman/dive/releases/download/v($version)/dive_($version)_linux_amd64.tar.gz
    extract tar dive_($version)_linux_amd64.tar.gz -d dive_linux_amd64
    move -d dive_linux_amd64 -f dive -p $path
  }

  bind file dive $path
}

export def hyperfine [] {
  let version = ghub version 'sharkdp/hyperfine'
  let path = share hyperfine $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sharkdp/hyperfine/releases/download/v($version)/hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'hyperfine-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'hyperfine-v($version)-x86_64-unknown-linux-gnu' -f hyperfine -p $path
  }

  bind file hyperfine $path
}

export def taskell [] {
  let version = ghub version 'smallhadroncollider/taskell'
  let path = share taskell $version

  if ($path | path-not-exists) {
    https download $'https://github.com/smallhadroncollider/taskell/releases/download/($version)/taskell-($version)_x86-64-linux.tar.gz'
    extract tar $'taskell-($version)_x86-64-linux.tar.gz' -d taskell_x86-64-linux
    move -d taskell_x86-64-linux -f taskell -p $path
  }

  bind file taskell $path
}

export def doctl [] {
  let version = ghub version 'digitalocean/doctl'
  let path = share doctl $version

  if ($path | path-not-exists) {
    https download $'https://github.com/digitalocean/doctl/releases/download/v($version)/doctl-($version)-linux-amd64.tar.gz'
    extract tar $'doctl-($version)-linux-amd64.tar.gz'
    move -f doctl -p $path
  }

  bind file doctl $path
}

export def hcloud [] {
  let version = ghub version 'hetznercloud/cli'
  let path = share hcloud $version

  if ($path | path-not-exists) {
    https download https://github.com/hetznercloud/cli/releases/download/v($version)/hcloud-linux-amd64.tar.gz
    extract tar hcloud-linux-amd64.tar.gz -d hcloud-linux-amd64
    move -d hcloud-linux-amd64 -f hcloud -p $path
  }

  bind file hcloud $path
}

export def kubectl [] {
  let version = http get https://dl.k8s.io/release/stable.txt
  let path = share kubectl $version

  if ($path | path-not-exists) {
    https download https://dl.k8s.io/release/($version)/bin/linux/amd64/kubectl -o kubectl
    add-execute kubectl
    move -f kubectl -p $path
  }

  bind file -r kubectl $path
}

export def kubecolor [] {
  let version = ghub version 'kubecolor/kubecolor'
  let path = share kubecolor $version

  if ($path | path-not-exists) {
    https download https://github.com/kubecolor/kubecolor/releases/download/v($version)/kubecolor_($version)_linux_amd64.tar.gz
    extract tar kubecolor_($version)_linux_amd64.tar.gz -d kubecolor_linux_amd64
    move -d kubecolor_linux_amd64 -f kubecolor -p $path
  }

  bind file kubecolor $path
}

export def kubetui [] {
  let version = ghub version 'sarub0b0/kubetui'
  let path = share kubetui $version

  if ($path | path-not-exists) {
    https download https://github.com/sarub0b0/kubetui/releases/download/v($version)/kubetui-x86_64-unknown-linux-musl -o kubetui
    add-execute kubetui
    move -f kubetui -p $path
  }

  bind file kubetui $path
}

export def kube-prompt [] {
  let version = ghub version 'c-bata/kube-prompt'
  let path = share kube-prompt $version

  if ($path | path-not-exists) {
    https download https://github.com/c-bata/kube-prompt/releases/download/v($version)/kube-prompt_v($version)_linux_amd64.zip
    extract zip kube-prompt_v($version)_linux_amd64.zip
    move -f kube-prompt -p $path
  }

  bind file kube-prompt $path
}

export def k9s [] {
  let version = ghub version 'derailed/k9s'
  let path = share k9s $version

  if ($path | path-not-exists) {
    https download $"https://github.com/derailed/k9s/releases/download/v($version)/k9s_Linux_amd64.tar.gz"
    extract tar k9s_Linux_amd64.tar.gz -d k9s_Linux_amd64
    move -d k9s_Linux_amd64 -f k9s -p $path
  }

  bind file k9s $path
}

export def kdash [] {
  let version = ghub version 'kdash-rs/kdash'
  let path = share kdash $version

  if ($path | path-not-exists) {
    https download https://github.com/kdash-rs/kdash/releases/download/v($version)/kdash-linux-musl.tar.gz
    extract tar kdash-linux-musl.tar.gz
    move -f kdash -p $path
  }

  bind file kdash $path
}

export def bettercap [] {
  let version = ghub version 'bettercap/bettercap'
  let path = share bettercap $version

  if ($path | path-not-exists) {
    https download $'https://github.com/bettercap/bettercap/releases/download/v($version)/bettercap_linux_amd64_v($version).zip'
    extract zip $'bettercap_linux_amd64_v($version).zip' -d bettercap_linux_amd64
    move -d 'bettercap_linux_amd64' -f bettercap -p $path
  }

  bind file -r bettercap $path
}

export def viddy [] {
  let version = ghub version 'sachaos/viddy'
  let path = share viddy $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sachaos/viddy/releases/download/v($version)/viddy-v($version)-linux-x86_64.tar.gz'
    extract tar $'viddy-v($version)-linux-x86_64.tar.gz'
    move -f viddy -p $path
  }

  bind file viddy $path
}

export def hwatch [] {
  let version = ghub version 'blacknon/hwatch'
  let path = share hwatch $version

  if ($path | path-not-exists) {
    https download $'https://github.com/blacknon/hwatch/releases/download/($version)/hwatch-($version).x86_64-unknown-linux-musl.tar.gz'
    extract tar $'hwatch-($version).x86_64-unknown-linux-musl.tar.gz' -d hwatch-unknown-linux
    move -d hwatch-unknown-linux -f bin/hwatch -p $path
  }

  bind file hwatch $path
}

export def yazi [] {
  let version = ghub version 'sxyazi/yazi'
  let path = share yazi $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sxyazi/yazi/releases/download/v($version)/yazi-x86_64-unknown-linux-gnu.zip'
    extract zip yazi-x86_64-unknown-linux-gnu.zip
    move -d yazi-x86_64-unknown-linux-gnu -f yazi -p $path
  }

  bind file yazi $path
}

export def kmon [] {
  let version = ghub version 'orhun/kmon'
  let path = share kmon $version

  if ($path | path-not-exists) {
    https download $'https://github.com/orhun/kmon/releases/download/v($version)/kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'kmon-($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'kmon-($version)' -f kmon -p $path
  }

  bind file kmon $path
}

export def --env ollama [] {
  let version = ghub version 'ollama/ollama'
  let path = share ollama $version

  if ($path | path-not-exists) {
    https download https://github.com/ollama/ollama/releases/download/v($version)/ollama-linux-amd64.tgz
    extract tar ollama-linux-amd64.tgz -d ollama-linux-amd64
    move dir ollama-linux-amd64 $path
  }

  bind dir $path $env.OLLAMA_PATH
  env-path $env.OLLAMA_BIN
}

export def plandex [] {
  let version = ghub version 'plandex-ai/plandex'
  let path = share plandex $version

  if ($path | path-not-exists) {
    https download $"https://github.com/plandex-ai/plandex/releases/download/cli%2Fv($version)/plandex_($version)_linux_amd64.tar.gz"
    extract tar $"plandex_($version)_linux_amd64.tar.gz" -d plandex_linux_amd64
    move -d plandex_linux_amd64 -f plandex -p $path
  }

  bind file plandex $path
}

export def local-ai [] {
  let version = ghub version 'mudler/LocalAI'
  let path = share local-ai $version

  if ($path | path-not-exists) {
    https download https://github.com/mudler/LocalAI/releases/download/v($version)/local-ai-Linux-x86_64 -o local-ai
    add-execute local-ai
    move -f local-ai -p $path
  }

  bind file local-ai $path
}

export def lan-mouse [ --desktop(-d), --service(-s) ] {
  let version = ghub version 'feschber/lan-mouse'
  let path = share lan-mouse $version

  if ($path | path-not-exists) {
    https download $"https://github.com/feschber/lan-mouse/releases/download/v($version)/lan-mouse" -o lan-mouse
    add-execute lan-mouse
    move -f lan-mouse -p $path
  }

  bind file lan-mouse $path

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

export def lapce [] {
  let version = ghub version 'lapce/lapce'
  let path = share lapce $version

  if ($path | path-not-exists) {
    https download https://github.com/lapce/lapce/releases/latest/download/Lapce-linux.tar.gz
    extract tar Lapce-linux.tar.gz
    move -d Lapce -f lapce -p $path
  }

  bind file lapce $path
}

export def --env vscodium [] {
  let version = ghub version 'VSCodium/vscodium'
  let path = share vscodium $version

  if ($path | path-not-exists) {
    https download $'https://github.com/VSCodium/vscodium/releases/download/($version)/VSCodium-linux-x64-($version).tar.gz'
    extract tar $'VSCodium-linux-x64-($version).tar.gz' -d vscodium
    move -d vscodium -p $path
  }

  bind dir $path $env.VSCODIUM_PATH
  env-path $env.VSCODIUM_BIN
}

export def zed [ --force(-f) ] {
  if $force or (which zed | is-empty) {
    curl https://zed.dev/install.sh | sh
  }
}

export def --env code-server [] {
  let version = ghub version 'coder/code-server'
  let path = share code-server $version

  if ($path | path-not-exists) {
    https download $'https://github.com/coder/code-server/releases/download/v($version)/code-server-($version)-linux-amd64.tar.gz'
    extract tar $'code-server-($version)-linux-amd64.tar.gz'
    move -d $'code-server-($version)-linux-amd64' -p $path
  }

  bind dir $path $env.CODE_SERVER_PATH
  env-path $env.CODE_SERVER_BIN
}

export def termshark [] {
  let version = ghub version 'gcla/termshark'
  let path = share termshark $version

  if ($path | path-not-exists) {
    https download $'https://github.com/gcla/termshark/releases/download/v($version)/termshark_($version)_linux_x64.tar.gz'
    extract tar $'termshark_($version)_linux_x64.tar.gz'
    move -d $'termshark_($version)_linux_x64' -f termshark -p $path
  }

  bind file termshark $path
}

export def termscp [] {
  let version = ghub version 'veeso/termscp'
  let path = share termscp $version

  if ($path | path-not-exists) {
    https download $'https://github.com/veeso/termscp/releases/download/v($version)/termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'termscp-v($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -f termscp -p $path
  }

  bind file termscp $path
}

export def kbt [] {
  let version = ghub version 'bloznelis/kbt'
  let path = share kbt $version

  if ($path | path-not-exists) {
    https download $'https://github.com/bloznelis/kbt/releases/download/($version)/kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'kbt-($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'kbt-($version)-x86_64-unknown-linux-gnu' -f kbt -p $path
  }

  bind file kbt $path
}

export def trippy [] {
  let version = ghub version 'fujiapple852/trippy'
  let path = share trippy $version

  if ($path | path-not-exists) {
    https download $'https://github.com/fujiapple852/trippy/releases/download/($version)/trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
    extract tar $'trippy-($version)-x86_64-unknown-linux-gnu.tar.gz'
    move -d $'trippy-($version)-x86_64-unknown-linux-gnu' -f trip -p $path
  }

  bind file -r trippy $path
}

export def gitui [] {
  let version = ghub version 'extrawurst/gitui'
  let path = share gitui $version

  if ($path | path-not-exists) {
    https download $'https://github.com/extrawurst/gitui/releases/download/v($version)/gitui-linux-musl.tar.gz'
    extract tar gitui-linux-musl.tar.gz
    move -f gitui -p $path
  }

  bind file gitui $path
}

export def monolith [] {
  let version = ghub version 'Y2Z/monolith'
  let path = share monolith $version

  if ($path | path-not-exists) {
    https download https://github.com/Y2Z/monolith/releases/download/v2.7.0/monolith-gnu-linux-x86_64 -o monolith
    add-execute monolith
    move -f monolith -p $path
  }

  bind file monolith $path
}

export def dijo [] {
  let version = ghub version 'nerdypepper/dijo'
  let path = share dijo $version

  if ($path | path-not-exists) {
    https download $'https://github.com/nerdypepper/dijo/releases/download/v($version)/dijo-x86_64-linux' -o dijo
    add-execute dijo
    move -f dijo -p $path
  }

  bind file dijo $path
}

export def ventoy [] {
  let version = ghub version 'ventoy/Ventoy'
  let path = share ventoy $version

  if ($path | path-not-exists) {
    https download $'https://github.com/ventoy/Ventoy/releases/download/v($version)/ventoy-($version)-linux.tar.gz'
    extract tar $'ventoy-($version)-linux.tar.gz'
    move -d $'ventoy-($version)' -p $path
  }

  bind dir $path $env.VENTOY_PATH
}

export def stash [] {
  let version = '0.27.2'
  let path = share stash $version

  if ($path | path-not-exists) {
    https download $'https://github.com/stashapp/stash/releases/download/v($version)/stash-linux' -o stash
    add-execute stash
    move -f stash -p $path
  }

  bind file stash $path
}

export def AdGuardHome [] {
  let version = ghub version 'AdguardTeam/AdGuardHome'
  let path = share AdGuardHome $version

  if ($path | path-not-exists) {
    https download https://github.com/AdguardTeam/AdGuardHome/releases/download/v($version)/AdGuardHome_linux_amd64.tar.gz
    extract tar AdGuardHome_linux_amd64.tar.gz
    move -d AdGuardHome -f AdGuardHome -p $path
  }

  bind file -r AdGuardHome $path
}

export def superhtml [] {
  let version = ghub version 'kristoff-it/superhtml'
  let path = share superhtml $version

  if ($path | path-not-exists) {
    https download https://github.com/kristoff-it/superhtml/releases/download/v($version)/x86_64-linux-musl.tar.gz
    extract tar x86_64-linux-musl.tar.gz
    move -d x86_64-linux-musl -f superhtml -p $path
  }

  bind file superhtml $path
}

export def --env mitmproxy [] {
  let version = ghub version 'mitmproxy/mitmproxy'
  let path = share mitmproxy $version

  if ($path | path-not-exists) {
    https download wget $'https://downloads.mitmproxy.org/($version)/mitmproxy-($version)-linux-x86_64.tar.gz'
    extract tar $'mitmproxy-($version)-linux-x86_64.tar.gz' -d 'mitmproxy'
    move -d 'mitmproxy' -p $path
  }

  bind dir $path $env.MITMPROXY_BIN
  env-path $env.MITMPROXY_BIN
}

export def proxyfor [] {
  let version = ghub version 'sigoden/proxyfor'
  let path = share proxyfor $version

  if ($path | path-not-exists) {
    https download $'https://github.com/sigoden/proxyfor/releases/download/v($version)/proxyfor-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'proxyfor-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -f proxyfor -p $path
  }

  bind file proxyfor $path
}

export def hetty [] {
  let version = ghub version 'dstotijn/hetty'
  let path = share hetty $version

  if ($path | path-not-exists) {
    https download https://github.com/dstotijn/hetty/releases/download/v($version)/hetty_($version)_Linux_x86_64.tar.gz
    extract tar hetty_($version)_Linux_x86_64.tar.gz -d hetty
    move -d 'hetty' -f hetty -p $path
  }

  bind file hetty $path
}

export def fclones [] {
  let version = ghub version 'pkolaczk/fclones'
  let path = share fclones $version

  if ($path | path-not-exists) {
    https download $"https://github.com/pkolaczk/fclones/releases/download/v($version)/fclones-($version)-linux-musl-x86_64.tar.gz"
    extract tar $"fclones-($version)-linux-musl-x86_64.tar.gz"
    move -d target -f x86_64-unknown-linux-musl/release/fclones -p $path
    rm -rf target
  }

  bind file fclones $path
}

export def nano-work-server [] {
  let version = ghub version 'nanocurrency/nano-work-server'
  let path = share nano-work-server $version

  if ($path | path-not-exists) {
    https download $"https://github.com/nanocurrency/nano-work-server/releases/download/V($version)/nano-work-server" -o nano-work-server
    add-execute nano-work-server
    move -f nano-work-server -p $path
  }

  bind file nano-work-server $path
}

export def mkcert [] {
  deps mkcert

  let version = ghub version 'FiloSottile/mkcert'
  let path = share mkcert $version

  if ($path | path-not-exists) {
    https download $'https://github.com/FiloSottile/mkcert/releases/download/v($version)/mkcert-v($version)-linux-amd64' -o mkcert
    add-execute mkcert
    move -f mkcert -p $path
  }

  bind file mkcert $path
}

export def devtunnel [] {
  let path = share devtunnel latest

  if ($path | path-not-exists) {
    https download https://aka.ms/TunnelsCliDownload/linux-x64 -o devtunnel
    add-execute devtunnel
    move -f devtunnel -p $path
  }

  bind file devtunnel $path
}

export def cloudflared [] {
  let path = share cloudflared latest

  if ($path | path-not-exists) {
    https download https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
    add-execute cloudflared
    move -f cloudflared -p $path
  }

  bind file cloudflared $path
}

export def pinggy [] {
  let path = share pinggy latest

  if ($path | path-not-exists) {
    https download https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/v0.1.0-beta.1/linux/amd64/pinggy
    add-execute pinggy
    move -f pinggy -p $path
  }

  bind file pinggy $path
}

export def speedtest [] {
  let version = '1.2.0'
  let path = share speedtest $version

  if ($path | path-not-exists) {
    https download $'https://install.speedtest.net/app/cli/ookla-speedtest-($version)-linux-x86_64.tgz'
    extract tar $'ookla-speedtest-($version)-linux-x86_64.tgz' -d 'ookla-speedtest-linux-x86_64'
    move -d 'ookla-speedtest-linux-x86_64' -f speedtest -p $path
  }

  bind file speedtest $path
}

export def librespeed [] {
  let version = ghub version 'librespeed/speedtest-cli'
  let path = share librespeed $version

  if ($path | path-not-exists) {
    https download $'https://github.com/librespeed/speedtest-cli/releases/download/v($version)/librespeed-cli_($version)_linux_amd64.tar.gz'
    extract tar $'librespeed-cli_($version)_linux_amd64.tar.gz' -d librespeed-cli_linux_amd64
    move -d librespeed-cli_linux_amd64 -f librespeed-cli -p $path
  }

  bind file librespeed $path
}

export def nix [ --force(-f) ] {
  if $force or (which nix | is-empty) {
    curl -L 'https://nixos.org/nix/install' | bash -s -- --daemon
  }
}

export def devbox [ --force(-f) ] {
  if $force or (which devbox | is-empty) {
    curl -fsSL https://get.jetify.com/devbox | bash
  }
}

export def tailscale [ --force(-f) ] {
  if $force or (which tailscale | is-empty) {
    curl -fsSL 'https://tailscale.com/install.sh' | sh
  }
}

export def remote-mouse [] {
  https download 'https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip'
  extract zip 'RemoteMouse_x86_64.zip' -d 'RemoteMouse_x86_64'
  move -d 'RemoteMouse_x86_64' -p $env.REMOTE_MOUSE_PATH
  rm ($env.REMOTE_MOUSE_PATH | path join install.sh)
}

export def --env docker [--group] {
  let version = '26.1.3'
  let path = share docker $version

  if ($path | path-not-exists) {
    https download https://download.docker.com/linux/static/stable/x86_64/docker-($version).tgz
    extract tar docker-($version).tgz
    move -f docker -p $path
  }

  if $group {
    sudo groupadd docker
    sudo usermod -aG docker $env.USER
  }

  bind dir $path $env.DOCKER_BIN
  env-path $env.DOCKER_BIN
}

export def --env fvm [] {
  let version = ghub version 'leoafarias/fvm'
  let path = share fvm $version

  if ($path | path-not-exists) {
    https download $'https://github.com/leoafarias/fvm/releases/download/($version)/fvm-($version)-linux-x64.tar.gz'
    extract tar $'fvm-($version)-linux-x64.tar.gz'
    move -d fvm -p $path
  }

  bind dir $path $env.FVM_PATH
  env-path $env.FVM_PATH
}

export def --env volta [--node] {
  let version = ghub version 'volta-cli/volta'
  let path = share volta-cli $version

  if ($path | path-not-exists) {
    https download $'https://github.com/volta-cli/volta/releases/download/v($version)/volta-($version)-linux.tar.gz'
    extract tar $'volta-($version)-linux.tar.gz' -d volta-linux
    move -d volta-linux -p $path
  }

  bind dir $path $env.VOLTA_PATH
  env-path $env.VOLTA_PATH

  if $node {
    ^volta install node@latest
  }
}

export def pnpm [] {
  let version = ghub version 'pnpm/pnpm'
  let path = share pnpm $version

  if ($path | path-not-exists) {
    https download https://github.com/pnpm/pnpm/releases/download/v($version)/pnpm-linux-x64 -o pnpm
    add-execute pnpm
    move -f pnpm -p $path
  }

  bind file pnpm $path
}

def node-versions [] {
  [
    (http get https://nodejs.org/download/release/index.json | get version | first | str trim -c 'v')
    "21.2.0" "20.9.0" "18.18.2"
  ]
}

export def --env node [ --latest ] {
  let versions = node-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = share node $version
  if ($path | path-not-exists) {
    https download wget $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz'
    extract tar $'node-v($version)-linux-x64.tar.gz'
    move -d $'node-v($version)-linux-x64' -p $path
  }

  bind dir $path $env.NODE_PATH
  env-path $env.NODE_BIN
}

export def deno [ --force(-f) ] {
  if $force or (which deno | is-empty) {
    curl -fsSL https://deno.land/install.sh | sh
  }
}

def go-versions [] {
  [
    ...(http get https://go.dev/dl/?mode=json | get version)
  ]
}

export def --env golang [ --latest ] {
  let versions = go-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = share go $version
  if ($path | path-not-exists) {
    https download $'https://go.dev/dl/($version).linux-amd64.tar.gz'
    extract tar $'($version).linux-amd64.tar.gz'
    move -d go -p $path
  }

  bind dir $path $env.GOROOT
  env-path $env.GOBIN
}

export def --env rust [ --latest(-l), --force(-f) ] {
  if $force or (which rustup | is-empty) {
    # curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh -s -- -q -y
    wget -O- --https-only --secure-protocol=auto --quiet --show-progress https://sh.rustup.rs | sh -s -- -q -y
  }
  env-path $env.CARGOBIN
}

export def haskell [ --latest(-l), --force(-f) ] {
  if $force or (which ghcup | is-empty) {
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  }
}

export def --env vlang [] {
  let version = 'latest'
  let path = share vlang $version

  if ($path | path-not-exists) {
    https download $'https://github.com/vlang/v/releases/($version)/download/v_linux.zip'
    extract zip v_linux.zip
    move -d 'v' -p $path
  }

  bind dir $path $env.VLANG_PATH
  env-path $env.VLANG_PATH
}

def java-list [] {
  {
    '11': 'https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz'
    '17': 'https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
    '21': 'https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz'
  }
}

def java-version [] {
  java-list | columns
}

export def --env java [ version: string@java-version = '21' ] {
  let path = share java $version
  let url = (java-list | get $version)

  if ($path | path-not-exists) {
    https download $url
    extract tar $'openjdk-($version)_linux-x64_bin.tar.gz'
    move -d $'jdk-($version)' -p $path
  }

  bind dir $path $env.JAVA_PATH
  env-path $env.JAVA_BIN
}

export def --env jdtls [] {
  let path = share jdtls 'latest'
  if ($path | path-not-exists) {
    https download https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz -o jdt-language-server-latest.tar.gz
    extract tar jdt-language-server-latest.tar.gz -d jdtls
    move -d jdtls -p $path
  }

  bind dir $path $env.JDTLS_PATH
  env-path $env.JDTLS_BIN
}

export def --env kotlin [] {
  let version = ghub version 'JetBrains/kotlin'
  let path = share kotlin $version

  if ($path | path-not-exists) {
    https download $"https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-compiler-($version).zip"
    extract zip $"kotlin-compiler-($version).zip"
    move -d kotlinc -p $path
  }

  bind dir $path $env.KOTLIN_PATH
  env-path $env.KOTLIN_BIN
}

export def --env kotlin-native [] {
  let version = ghub version 'JetBrains/kotlin'
  let path = share kotlin-native $version

  if ($path | path-not-exists) {
    https download $"https://github.com/JetBrains/kotlin/releases/download/v($version)/kotlin-native-prebuilt-linux-x86_64-($version).tar.gz"
    extract tar $'kotlin-native-prebuilt-linux-x86_64-($version).tar.gz'
    move -d $'kotlin-native-prebuilt-linux-x86_64-($version)' -p $path
  }

  bind dir $path $env.KOTLIN_NATIVE_PATH
  env-path $env.KOTLIN_NATIVE_BIN
}

export def --env kotlin-language-server [] {
  let version = ghub version 'fwcd/kotlin-language-server'
  let path = share kotlin-language-server $version

  if ($path | path-not-exists) {
    https download $'https://github.com/fwcd/kotlin-language-server/releases/download/($version)/server.zip'
    extract zip server.zip
    move -d server -p $path
  }

  bind dir $path $env.KOTLIN_LSP_PATH
  env-path $env.KOTLIN_LSP_BIN
}

export def --env lua-language-server [] {
  let version = ghub version 'LuaLS/lua-language-server'
  let path = share lua-language-server $version

  if ($path | path-not-exists) {
    https download $'https://github.com/LuaLS/lua-language-server/releases/download/($version)/lua-language-server-($version)-linux-x64.tar.gz'
    extract tar $'lua-language-server-($version)-linux-x64.tar.gz' -d lua-language-server
    move -d lua-language-server -p $path
  }

  bind dir $path $env.LUA_LSP_PATH
  env-path $env.LUA_LSP_BIN
}

def dart_latest [] {
  http get https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | decode | from json | get version
}

export def --env dart [] {
  let version = (dart_latest)
  let path = share dart $version

  if ($path | path-not-exists) {
    https download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip'
    extract zip 'dartsdk-linux-x64-release.zip'
    move -d 'dart-sdk' -p $path
  }

  bind dir $path $env.DART_PATH
  env-path $env.DART_BIN
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
  if ($path | path-not-exists) {
    https download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz'
    extract tar $'flutter_linux_($version)-stable.tar.xz'
    move -d 'flutter' -p $path
  }

  bind dir $path $env.FLUTTER_PATH
  env-path $env.FLUTTER_BIN
}

export def --env android-studio [ --desktop(-d) ] {
  let version = '2024.2.1.9'
  let path = share android-studio $version

  if ($path | path-not-exists) {
    https download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz'
    extract tar $'android-studio-($version)-linux.tar.gz'
    move -d android-studio -p $path
  }

  bind dir $path $env.ANDORID_STUDIO_PATH
  env-path $env.ANDROID_STUDIO_BIN

  if $desktop {
    let src = ($env.NU_BASE_FILES | path join applications android-studio.desktop)
    cp $src $env.LOCAL_SHARE_APPLICATIONS
  }
}

export def --env android-cmdline-tools [] {
  if not ($env.ANDROID_CMDLINE_TOOLS | path exists) {
    https download https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    extract zip commandlinetools-linux-11076708_latest.zip
    mkdir ($env.ANDROID_CMDLINE_TOOLS | path dirname)
    move -d cmdline-tools -p $env.ANDROID_CMDLINE_TOOLS
  }
  env-path $env.ANDROID_CMDLINE_TOOLS_BIN
}

export def --env android-platform-tools [] {
  if not ($env.ANDROID_PLATFORM_TOOLS | path exists) {
    https download https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    extract zip platform-tools-latest-linux.zip
    move -d platform-tools -p $env.ANDROID_PLATFORM_TOOLS
  }
  env-path $env.ANDROID_PLATFORM_TOOLS
}

export def --env btcd [] {
  let version = ghub version 'btcsuite/btcd'
  let path = share btcd $version

  if ($path | path-not-exists) {
    https download $'https://github.com/btcsuite/btcd/releases/download/v($version)/btcd-linux-amd64-v($version).tar.gz'
    extract tar $'btcd-linux-amd64-v($version).tar.gz'
    move -d $'btcd-linux-amd64-v($version)' -p $path
  }

  bind dir $path $env.BTCD_PATH
  env-path $env.BTCD_PATH
}

export def --env bitcoin [] {
  let version = ghub version 'bitcoin/bitcoin'
  let path = share bitcoin $version

  if ($path | path-not-exists) {
    https download $'https://bitcoincore.org/bin/bitcoin-core-($version)/bitcoin-($version)-x86_64-linux-gnu.tar.gz'
    extract tar $'bitcoin-($version)-x86_64-linux-gnu.tar.gz'
    move -d $'bitcoin-($version)' -p $path
  }

  bind dir $path $env.BITCOIN_PATH
  env-path $env.BITCOIN_BIN
}

export def --env lightning-network [] {
  let version = ghub version 'lightningnetwork/lnd'
  let path = share lightning $version

  if ($path | path-not-exists) {
    https download $'https://github.com/lightningnetwork/lnd/releases/download/v($version)/lnd-linux-amd64-v($version).tar.gz'
    extract tar $'lnd-linux-amd64-v($version).tar.gz'
    move -d $'lnd-linux-amd64-v($version)' -p $path
  }

  bind dir $path $env.LIGHTNING_PATH
  env-path $env.LIGHTNING_PATH
}

export def --env scilab [] {
  let version = '2024.1.0'
  let path = share scilab $version

  if ($path | path-not-exists) {
    https download $'https://www.scilab.org/download/($version)/scilab-($version).bin.x86_64-linux-gnu.tar.xz'
    extract tar $'scilab-($version).bin.x86_64-linux-gnu.tar.xz'
    move -d $'scilab-($version)' -p $path
  }

  bind dir $path $env.SCILAB_PATH
  env-path $env.SCILAB_BIN
}

export def clangd [] {
  let version = ghub version 'clangd/clangd'
  let path = share clangd $version

  if ($path | path-not-exists) {
    https download $'https://github.com/clangd/clangd/releases/download/($version)/clangd-linux-($version).zip'
    extract zip $'clangd-linux-($version).zip'
    move -d $'clangd_($version)' -f bin/clangd -p $path
  }

  bind file -r clangd $path
}

export def marksman [] {
  let version = ghub version 'artempyanykh/marksman'
  let path = share marksman $version

  if ($path | path-not-exists) {
    https download https://github.com/artempyanykh/marksman/releases/download/($version)/marksman-linux-x64 -o marksman
    add-execute marksman
    move -f marksman -p $path
  }

  bind file marksman $path
}

export def v-analyzer [] {
  let version = ghub version 'vlang/v-analyzer'
  let path = share v-analyzer $version

  if ($path | path-not-exists) {
    https download https://github.com/vlang/v-analyzer/releases/download/($version)/v-analyzer-linux-x86_64.zip
    extract zip v-analyzer-linux-x86_64.zip
    move  -f v-analyzer -p $path
  }

  bind file v-analyzer $path
}

export def zls [] {
  let version = ghub version 'zigtools/zls'
  let path = share zls $version

  if ($path | path-not-exists) {
    https download https://github.com/zigtools/zls/releases/download/($version)/zls-x86_64-linux.tar.xz
    extract tar zls-x86_64-linux.tar.xz -d zls-x86_64-linux
    move -d zls-x86_64-linux -f zls -p $path
  }

  bind file zls $path
}

export def presenterm [] {
  let version = ghub version 'mfontanini/presenterm'
  let path = share presenterm $version

  if ($path | path-not-exists) {
    https download $'https://github.com/mfontanini/presenterm/releases/download/v($version)/presenterm-($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'presenterm-($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'presenterm-($version)' -f presenterm -p $path
  }

  bind file presenterm $path
}

export def contour [] {
  let version = ghub version 'contour-terminal/contour'
  let path = share contour $version

  if ($path | path-not-exists) {
    https download $'https://github.com/contour-terminal/contour/releases/download/v($version)/contour-($version)-x86-64.Linux-static.tgz'
    extract tar $'contour-($version)-x86-64.Linux-static.tgz'
    mv $'contour-($version)-x86-64.Linux' contour
    move -f contour -p $path
  }

  bind file contour $path
}

export def viu [] {
  let version = ghub version 'atanunq/viu'
  let path = share viu $version

  if ($path | path-not-exists) {
    https download https://github.com/atanunq/viu/releases/download/v1.5.1/viu-x86_64-unknown-linux-musl -o viu
    add-execute viu
    move -f viu -p $path
  }

  bind file viu $path
}

export def immich-go [] {
  let version = ghub version 'simulot/immich-go'
  let path = share immich-go $version

  if ($path | path-not-exists) {
    https download https://github.com/simulot/immich-go/releases/download/($version)/immich-go_Linux_x86_64.tar.gz
    extract tar immich-go_Linux_x86_64.tar.gz -d immich-go_linux_x86_64
    move -d immich-go_linux_x86_64 -f immich-go -p $path
  }

  bind file immich-go $path
}

export def picocrypt [] {
  let version = ghub version 'Picocrypt/CLI'
  let path = share picocrypt $version

  if ($path | path-not-exists) {
    https download https://github.com/Picocrypt/CLI/releases/download/($version)/picocrypt-linux-amd64 -o picocrypt
    add-execute picocrypt
    move -f picocrypt -p $path
  }

  bind file picocrypt $path
}

export def --env ringboard [] {
  let version = ghub version 'SUPERCILEX/clipboard-history'
  let path = share ringboard $version

  mkdir linux-musl-ringboard

  if ($path | path-not-exists) {
    https download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard' -o linux-musl-ringboard/ringboard
    add-execute linux-musl-ringboard/ringboard

    https download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-egui' -o linux-musl-ringboard/ringboard-egui
    add-execute linux-musl-ringboard/ringboard-egui

    https download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-server' -o linux-musl-ringboard/ringboard-server
    add-execute linux-musl-ringboard/ringboard-server

    https download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-tui' -o linux-musl-ringboard/ringboard-tui
    add-execute linux-musl-ringboard/ringboard-tui
  }

  move -d linux-musl-ringboard -p $path

  bind dir $path $env.RINGBOARD_BIN
  env-path $env.RINGBOARD_BIN
}

export def clipboard [] {
  let version = ghub version 'Slackadays/Clipboard'
  let path = share cb $version

  if ($path | path-not-exists) {
    https download https://github.com/Slackadays/Clipboard/releases/download/($version)/clipboard-linux-amd64.zip -o clipboard-linux-amd64.zip
    extract zip clipboard-linux-amd64.zip -d clipboard-linux-amd64
    move -d clipboard-linux-amd64 -f bin/cb -p $path
  }

  bind file cb $path
}

export def vi-mongo [] {
  let version = ghub version 'kopecmaciej/vi-mongo'
  let path = share vi-mongo $version

  if ($path | path-not-exists) {
    https download https://github.com/kopecmaciej/vi-mongo/releases/download/v0.1.18/vi-mongo_Linux_x86_64.tar.gz
    extract tar vi-mongo_Linux_x86_64.tar.gz -d vi-mongo_Linux_x86_64
    move -d vi-mongo_Linux_x86_64 -f vi-mongo -p $path
  }

  bind file vi-mongo $path
}

export def cloak [] {
  let version = ghub version 'evansmurithi/cloak'
  let path = share cloak $version

  if ($path | path-not-exists) {
    https download $'https://github.com/evansmurithi/cloak/releases/download/v($version)/cloak-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'cloak-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'cloak-v($version)-x86_64-unknown-linux-musl' -f cloak -p $path
  }

  bind file cloak $path
}

export def totp [] {
  let version = ghub version 'Zebradil/rustotpony'
  let path = share totp $version

  if ($path | path-not-exists) {
    https download https://github.com/Zebradil/rustotpony/releases/download/($version)/totp-linux -o totp
    add-execute totp
    move -f totp -p $path
  }

  bind file totp $path
}

export def totp-cli [] {
  let version = ghub version 'yitsushi/totp-cli'
  let path = share totp-cli $version

  if ($path | path-not-exists) {
    https download https://github.com/yitsushi/totp-cli/releases/download/v($version)/totp-cli_Linux_x86_64.tar.gz
    extract tar totp-cli_Linux_x86_64.tar.gz -d totp-cli_Linux_x86_64
    move -d totp-cli_Linux_x86_64 -f totp-cli -p $path
  }

  bind file totp-cli $path
}

export def jnv [] {
  let version = ghub version 'ynqa/jnv'
  let path = share jnv $version

  if ($path | path-not-exists) {
    https download https://github.com/ynqa/jnv/releases/download/v($version)/jnv-x86_64-unknown-linux-musl.tar.xz
    extract tar jnv-x86_64-unknown-linux-musl.tar.xz
    move -d jnv-x86_64-unknown-linux-musl -f jnv -p $path
  }

  bind file jnv $path
}

export def devspace [] {
  let version = ghub version 'devspace-sh/devspace'
  let path = share devspace $version

  if ($path | path-not-exists) {
    https download https://github.com/devspace-sh/devspace/releases/download/v($version)/devspace-linux-amd64 -o devspace
    add-execute devspace
    move -f devspace -p $path
  }

  bind file devspace $path
}

export def atto [] {
  let version = ghub version 'codesoap/atto'
  let path = share atto $version

  if ($path | path-not-exists) {
    https download https://github.com/codesoap/atto/releases/download/v($version)/atto_($version)_Linux_amd64.tar.gz
    extract tar atto_($version)_Linux_amd64.tar.gz
    move -f atto -p $path
  }

  bind file atto $path
}

export def wsget [] {
  let version = ghub version 'ksysoev/wsget'
  let path = share wsget $version

  if ($path | path-not-exists) {
    https download https://github.com/ksysoev/wsget/releases/download/v($version)/wsget_Linux_x86_64.tar.gz
    extract tar wsget_Linux_x86_64.tar.gz -d wsget_Linux_x86_64
    move -d wsget_Linux_x86_64 -f wsget -p $path
  }

  bind file wsget $path
}

export def koji [] {
  let version = ghub version 'cococonscious/koji'
  let path = share koji $version

  if ($path | path-not-exists) {
    https download https://github.com/cococonscious/koji/releases/download/v3.0.0/koji-x86_64-unknown-linux-gnu.tar.gz
    extract tar koji-x86_64-unknown-linux-gnu.tar.gz
    move -f koji -p $path
  }

  bind file koji $path
}

export def smartcat [] {
  let version = ghub version 'efugier/smartcat'
  let path = share sc $version

  if ($path | path-not-exists) {
    https download https://github.com/efugier/smartcat/releases/download/($version)/sc--x86_64-unknown-linux-gnu.tar.gz
    extract tar sc--x86_64-unknown-linux-gnu.tar.gz
    move -d sc--x86_64-unknown-linux-gnu -f sc -p $path
  }

  bind file sc $path
}

export def jwt [] {
  let version = ghub version 'mike-engel/jwt-cli'
  let path = share jwt $version

  if ($path | path-not-exists) {
    https download https://github.com/mike-engel/jwt-cli/releases/download/6.2.0/jwt-linux-musl.tar.gz
    extract tar jwt-linux-musl.tar.gz
    move -f jwt -p $path
  }

  bind file jwt $path
}

export def procs [] {
  let version = ghub version 'dalance/procs'
  let path = share procs $version

  if ($path | path-not-exists) {
    https download $'https://github.com/dalance/procs/releases/download/v($version)/procs-v($version)-x86_64-linux.zip'
    extract zip $'procs-v($version)-x86_64-linux.zip'
    move -f procs -p $path
  }

  bind file procs $path
}

export def oha [] {
  let version = ghub version 'hatoo/oha'
  let path = share oha $version

  if ($path | path-not-exists) {
    https download https://github.com/hatoo/oha/releases/download/v($version)/oha-linux-amd64 -o oha
    add-execute oha
    move -f oha -p $path
  }

  bind file oha $path
}

export def adguardian [] {
  let version = ghub version 'Lissy93/AdGuardian-Term'
  let path = share adguardian $version

  if ($path | path-not-exists) {
    https download https://github.com/Lissy93/AdGuardian-Term/releases/download/($version)/adguardian-x86_64 -o adguardian
    add-execute adguardian
    move -f adguardian -p $path
  }

  bind file adguardian $path
}

export def gix [] {
  let version = ghub version 'GitoxideLabs/gitoxide'
  let path = share gix $version

  if ($path | path-not-exists) {
    https download $'https://github.com/GitoxideLabs/gitoxide/releases/download/v($version)/gitoxide-max-pure-v($version)-x86_64-unknown-linux-musl.tar.gz'
    extract tar $'gitoxide-max-pure-v($version)-x86_64-unknown-linux-musl.tar.gz'
    move -d $'gitoxide-max-pure-v($version)-x86_64-unknown-linux-musl' -f gix -p $path
  }

  bind file gix $path
}

export def kubewall [] {
  let version = ghub version 'kubewall/kubewall'
  let path = share kubewall $version

  if ($path | path-not-exists) {
    https download https://github.com/kubewall/kubewall/releases/download/v($version)/kubewall_Linux_x86_64.tar.gz
    extract tar kubewall_Linux_x86_64.tar.gz -d kubewall_Linux_x86_64
    move -d kubewall_Linux_x86_64 -f kubewall -p $path
  }

  bind file kubewall $path
}

export def f2 [] {
  let version = ghub version 'ayoisaiah/f2'
  let path = share f2 $version

  if ($path | path-not-exists) {
    https download https://github.com/ayoisaiah/f2/releases/download/v2.0.3/f2_2.0.3_linux_amd64.tar.gz
    extract tar f2_2.0.3_linux_amd64.tar.gz -d f2_linux_amd64
    move -d f2_linux_amd64 -f f2 -p $path
  }

  bind file f2 $path
}

export def doggo [] {
  let version = ghub version 'mr-karan/doggo'
  let path = share doggo $version

  if ($path | path-not-exists) {
    https download https://github.com/mr-karan/doggo/releases/download/v($version)/doggo_($version)_Linux_x86_64.tar.gz
    extract tar doggo_($version)_Linux_x86_64.tar.gz
    move -d doggo_($version)_Linux_x86_64 -f doggo -p $path
  }

  bind file doggo $path
}

export def firefox-de [] {
  https download https://download-installer.cdn.mozilla.net/pub/devedition/releases/129.0b6/linux-x86_64/es-ES/firefox-129.0b6.tar.bz2
  extract tar firefox-129.0b6.tar.bz2

  sudo mv firefox /opt
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
}

def choose [versions: list] {
  if not (^which gum | is-empty) {
    (^gum choose ...$versions)
  } else {
    ($versions | input list)
  }
}

def share [name: string, version: string] {
  $env.USR_LOCAL_SHARE | path join ([$name $version] | str join '_')
}

def 'move dir' [src: string, dst: string] {
  mv -p -f $src $dst
}

def 'bind dir' [src: string, dst: string] {
  rm -rf $dst
  ln -sf $src $dst
}

def 'bind file' [name: string, src: string, --root(-r)] {
  if $root {
    let dst = ($env.SYS_LOCAL_BIN | path join $name)
    sudo rm -rf $dst
    sudo ln -sf $src $dst
  }
  let dst = ($env.USR_LOCAL_BIN | path join $name)
  rm -rf $dst
  ln -sf $src $dst
}

def move [
  --dir(-d): string = '',
  --file(-f): string = '',
  --path(-p): string,
] {
  if ($path | path exists) { rm -rf $path }
  mv -f ($dir | path join $file) $path
  if ($dir | path exists) { rm -rf $dir }
}

export def core [] {
  xh
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

  usql
  mongosh
  kubectl
  kubecolor

  uv
  pnpm

  gum
  mods
  glow
  freeze

  gdu
  qrcp
  gitu
  ttyper
  bottom
  amber
  broot
  task
  pueue
  difftastic
  rclone
  qrrs
  taskell
  viddy
  tailscale
  wsget
}
