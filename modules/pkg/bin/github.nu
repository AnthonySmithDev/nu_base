
def bin-path [name: string, version: string] {
  let dir = ($env.USR_LOCAL_SHARE_BIN | path join $name)
  mkdir $dir
  return ($dir | path join $"($name)_($version)")
}

def lib-path [name: string, version: string] {
  let dir = ($env.USR_LOCAL_SHARE_LIB | path join $name)
  mkdir $dir
  return ($dir | path join $"($name)_($version)")
}

def bind-dir [src: string, dst: string] {
  rm -rfp $dst
  ln -sf $src $dst
}

def bind-file [cmd: string, src: string] {
  let dst = ($env.USR_LOCAL_BIN | path join $cmd)
  rm -rfp $dst
  ln -sf $src $dst
}

def bind-root [cmd: string, src: string] {
  let dst = ($env.SYS_LOCAL_BIN | path join $cmd)
  if not ($dst | path exists) {
    sudo rm -rf $dst
    sudo ln -sf $src $dst
  }
}

def move [
  --dir(-d): string = ""
  --file(-f): string = "",
  --path(-p): string,
] {
  if ($path | path exists) {
    rm -rfp $path
  }
  let src = ($dir | path join $file)
  if ($src | path exists) {
    cp -rf $src $path
  } else {
    error make -u {msg: $"Source not exists \n ($src)"}
  }
  if ($dir | path exists) { rm -rfp $dir }
}

def path-not-exists [path: string, force: bool] {
  (not ($path | path exists) or $force)
}

export def --env helix [ --force(-f) ] {
  let repository = "helix-editor/helix"
  let tag_name = ghub tag_name $repository
  let path = lib-path helix $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
    bind-root hx ($path | path join hx)
  }

  bind-dir $path $env.HELIX_PATH
  env-path $env.HELIX_PATH
}

export def --env nushell [ --force(-f) ] {
  let repository = "nushell/nushell"
  let tag_name = ghub tag_name $repository
  let path = lib-path nushell $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
    bind-root nu ($path | path join nu)
  }

  bind-dir $path $env.NUSHELL_BIN
  env-path $env.NUSHELL_BIN
}

export def --env kitty [--force(-f)] {
  let repository = "kovidgoyal/kitty"
  let tag_name = ghub tag_name $repository
  let path = lib-path kitty $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
    bind-root kitty ($path | path join bin/kitty)
  }

  bind-dir $path $env.KITTY_PATH
  env-path $env.KITTY_BIN
}

export def starship [ --force(-f) ] {
  let repository = "starship/starship"
  let tag_name = ghub tag_name $repository
  let path = bin-path starship $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f starship -p $path
    bind-root starship $path
  }

  bind-file starship $path
}

export def zoxide [ --force(-f) ] {
  let repository = "ajeetdsouza/zoxide"
  let tag_name = ghub tag_name $repository
  let path = bin-path zoxide $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f zoxide -p $path
    bind-root zoxide $path
  }

  bind-file zoxide $path
}

export def zellij [--force(-f)] {
  let repository = "zellij-org/zellij"
  let tag_name = ghub tag_name $repository
  let path = bin-path zellij $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f zellij -p $path
    bind-root zellij $path
  }

  bind-file zellij $path
}

export def rg [ --force(-f) ] {
  let repository = "BurntSushi/ripgrep"
  let tag_name = ghub tag_name $repository
  let path = bin-path rg $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f rg -p $path
    bind-root rg $path
  }

  bind-file rg $path
}

export def fd [ --force(-f) ] {
  let repository = "sharkdp/fd"
  let tag_name = ghub tag_name $repository
  let path = bin-path fd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f fd -p $path
    bind-root fd $path
  }

  bind-file fd $path
}

export def --env yazi [ --force(-f) ] {
  let repository = "sxyazi/yazi"
  let tag_name = ghub tag_name $repository
  let path = lib-path yazi $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
    bind-root ya ($path | path join ya)
    bind-root yazi ($path | path join yazi)
  }

  bind-dir $path $env.YAZI_BIN
  env-path $env.YAZI_BIN

}

export def fzf [ --force(-f) ] {
  let repository = "junegunn/fzf"
  let tag_name = ghub tag_name $repository
  let path = bin-path fzf $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f fzf -p $path
    bind-root fzf $path
  }

  bind-file fzf $path
}

export def lsp-ai [ --force(-f) ] {
  let repository = "SilasMarvin/lsp-ai"
  let tag_name = ghub tag_name $repository
  let path = bin-path lsp-ai $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -f $download_path -p $path
    chmod +x $path
  }

  bind-file lsp-ai $path
}

export def gum [ --force(-f) ] {
  let repository = "charmbracelet/gum"
  let tag_name = ghub tag_name $repository
  let path = bin-path gum $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gum -p $path
  }

  bind-file gum $path
}

export def mods [ --force(-f) ] {
  let repository = "charmbracelet/mods"
  let tag_name = ghub tag_name $repository
  let path = bin-path mods $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f mods -p $path
  }

  bind-file mods $path
}

export def crush [ --force(-f) ] {
  let repository = "charmbracelet/crush"
  let tag_name = ghub tag_name $repository
  let path = bin-path crush $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f crush -p $path
  }

  bind-file crush $path
}

export def glow [ --force(-f) ] {
  let repository = "charmbracelet/glow"
  let tag_name = ghub tag_name $repository
  let path = bin-path glow $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f glow -p $path
  }

  bind-file glow $path
}

export def soft [ --force(-f) ] {
  let repository = "charmbracelet/soft-serve"
  let tag_name = ghub tag_name $repository
  let path = bin-path soft $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f soft -p $path
  }

  bind-file soft $path
}

export def vhs [ --force(-f) ] {
  let repository = "charmbracelet/vhs"
  let tag_name = ghub tag_name $repository
  let path = bin-path vhs $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f vhs -p $path
  }

  bind-file vhs $path
}

export def freeze [ --force(-f) ] {
  let repository = "charmbracelet/freeze"
  let tag_name = ghub tag_name $repository
  let path = bin-path freeze $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f freeze -p $path
  }

  bind-file freeze $path
}

export def melt [ --force(-f) ] {
  let repository = "charmbracelet/melt"
  let tag_name = ghub tag_name $repository
  let path = bin-path melt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f melt -p $path
  }

  bind-file melt $path
}

export def skate [ --force(-f) ] {
  let repository = "charmbracelet/skate"
  let tag_name = ghub tag_name $repository
  let path = bin-path skate $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f skate -p $path
  }

  bind-file skate $path
}

export def --env neovim [ --force(-f) ] {
  let repository = "neovim/neovim"
  let tag_name = ghub tag_name $repository
  let path = lib-path neovim $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.NVIM_PATH
  env-path $env.NVIM_BIN
}

export def --env zed [ --force(-f) ] {
  let repository = "zed-industries/zed"
  let tag_name = ghub tag_name $repository
  let path = lib-path zed $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.ZED_PATH
  env-path $env.ZED_BIN
}

export def broot [ --force(-f) ] {
  let repository = "Canop/broot"
  let tag_name = ghub tag_name $repository
  let path = bin-path broot $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f x86_64-linux/broot -p $path
  }

  bind-file broot $path
}

export def mirrord [ --force(-f) ] {
  let repository = "metalbear-co/mirrord"
  let tag_name = ghub tag_name $repository
  let path = bin-path mirrord $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f mirrord -p $path
    add-execute $path
  }

  bind-file mirrord $path
}

export def gitu [ --force(-f) ] {
  let repository = "altsem/gitu"
  let tag_name = ghub tag_name $repository
  let path = bin-path gitu $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gitu -p $path
    add-execute $path
  }

  bind-file gitu $path
}

export def fm [ --force(-f) ] {
  let repository = "mistakenelf/fm"
  let tag_name = ghub tag_name $repository
  let path = bin-path fm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f fm -p $path
  }

  bind-file fm $path
}

export def superfile [ --force(-f) ] {
  let repository = "yorukot/superfile"
  let tag_name = ghub tag_name $repository
  let path = bin-path spf $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f spf -p $path
  }

  bind-file spf $path
}

export def zk [ --force(-f) ] {
  let repository = "zk-org/zk"
  let tag_name = ghub tag_name $repository
  let path = bin-path zk $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f zk -p $path
  }

  bind-file zk $path
}

export def hostctl [ --force(-f) ] {
  let repository = "guumaster/hostctl"
  let tag_name = ghub tag_name $repository
  let path = bin-path hostctl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f hostctl -p $path
  }

  bind-file hostctl $path
}

export def bat [ --force(-f) ] {
  let repository = "sharkdp/bat"
  let tag_name = ghub tag_name $repository
  let path = bin-path bat $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bat -p $path
    bind-root bat $path
  }

  bind-file bat $path
}

export def gdu [ --force(-f) ] {
  let repository = "dundee/gdu"
  let tag_name = ghub tag_name $repository
  let path = bin-path gdu $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gdu_linux_amd64_static -p $path
    bind-root gdu $path
  }

  bind-file gdu $path
}

export def task [ --force(-f) ] {
  let repository = "go-task/task"
  let tag_name = ghub tag_name $repository
  let path = bin-path task $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f task -p $path
    bind-root task $path
  }

  bind-file task $path
}

export def mouseless [ --force(-f) ] {
  let repository = "jbensmann/mouseless"
  let tag_name = ghub tag_name $repository
  let path = bin-path mouseless $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f mouseless -p $path
    bind-root mouseless $path
  }

  bind-file mouseless $path
}

export def websocat [ --force(-f) ] {
  let repository = "vi/websocat"
  let tag_name = ghub tag_name $repository
  let path = bin-path websocat $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file websocat $path
}

export def --env amber [ --force(-f) ] {
  let repository = "dalance/amber"
  let tag_name = ghub tag_name $repository
  let path = lib-path amber $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.AMBER_BIN
  env-path $env.AMBER_BIN
}

export def obsidian-cli [ --force(-f) ] {
  let repository = "Yakitrak/obsidian-cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path obsidian-cli $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f obsidian-cli -p $path
  }

  bind-file obsidian-cli $path
}

export def lazygit [ --force(-f) ] {
  let repository = "jesseduffield/lazygit"
  let tag_name = ghub tag_name $repository
  let path = bin-path lazygit $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lazygit -p $path
  }

  bind-file lazygit $path
}

export def lazydocker [ --force(-f) ] {
  let repository = "jesseduffield/lazydocker"
  let tag_name = ghub tag_name $repository
  let path = bin-path lazydocker $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lazydocker -p $path
  }

  bind-file lazydocker $path
}

export def oxker [ --force(-f) ] {
  let repository = "mrjackwills/oxker"
  let tag_name = ghub tag_name $repository
  let path = bin-path oxker $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f oxker -p $path
  }

  bind-file oxker $path
}

export def lazycli [ --force(-f) ] {
  let repository = "jesseduffield/lazycli"
  let tag_name = ghub tag_name $repository
  let path = bin-path lazycli $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lazycli -p $path
  }

  bind-file lazycli $path
}

export def horcrux [ --force(-f) ] {
  let repository = "jesseduffield/horcrux"
  let tag_name = ghub tag_name $repository
  let path = bin-path horcrux $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f horcrux -p $path
  }

  bind-file horcrux $path
}

export def tweety [ --force(-f) ] {
  let repository = "pomdtr/tweety"
  let tag_name = ghub tag_name $repository
  let path = bin-path tweety $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f tweety -p $path
  }

  bind-file tweety $path
}

export def podman-tui [ --force(-f) ] {
  let repository = "containers/podman-tui"
  let tag_name = ghub tag_name $repository
  let path = bin-path podman-tui $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f podman-tui -p $path
    bind-root podman-tui $path
  }

  bind-file podman-tui $path
}

export def jless [ --force(-f) ] {
  let repository = "PaulJuliusMartinez/jless"
  let tag_name = ghub tag_name $repository
  let path = bin-path jless $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f jless -p $path
  }

  bind-file jless $path
}

export def silicon [ --force(-f) ] {
  let repository = "Aloxaf/silicon"
  let tag_name = ghub tag_name $repository
  let path = bin-path silicon $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f silicon -p $path
  }

  bind-file silicon $path
}

export def dasel [ --force(-f) ] {
  let repository = "TomWright/dasel"
  let tag_name = ghub tag_name $repository
  let path = bin-path dasel $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file dasel $path
}

export def pueue [ --force(-f) ] {
  let repository = "Nukesor/pueue"
  let tag_name = ghub tag_name $repository

  let path = bin-path pueue $tag_name
  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository -s pueue- --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }
  bind-file pueue $path

  let path = bin-path pueued $tag_name
  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository -s pueued- --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }
  bind-file pueued $path
}

export def xh [ --force(-f) ] {
  let repository = "ducaale/xh"
  let tag_name = ghub tag_name $repository
  let path = bin-path xh $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f xh -p $path
    bind-root xh $path
  }

  bind-file xh $path
}

export def delta [ --force(-f) ] {
  let repository = "dandavison/delta"
  let tag_name = ghub tag_name $repository
  let path = bin-path delta $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f delta -p $path
  }

  bind-file delta $path
}

export def difftastic [ --force(-f) ] {
  let repository = "Wilfred/difftastic"
  let tag_name = ghub tag_name $repository
  let path = bin-path difft $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f difft -p $path
  }

  bind-file difft $path
}

export def riff [ --force(-f) ] {
  let repository = "walles/riff"
  let tag_name = ghub tag_name $repository
  let path = bin-path riff $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    move -f $download_path -p $path
    add-execute $path
  }

  bind-file riff $path
}

export def bottom [ --force(-f) ] {
  let repository = "ClementTsang/bottom"
  let tag_name = ghub tag_name $repository
  let path = bin-path btm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f btm -p $path
    bind-root btm $path
  }

  bind-file btm $path
}

export def btop [ --force(-f) ] {
  let repository = "aristocratos/btop"
  let tag_name = ghub tag_name $repository
  let path = bin-path btop $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/btop -p $path
  }

  bind-file btop $path
}

export def ttyper [ --force(-f) ] {
  let repository = "max-niederman/ttyper"
  let tag_name = ghub tag_name $repository
  let path = bin-path ttyper $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f ttyper -p $path
  }

  bind-file ttyper $path
}

export def ezshare [ --force(-f) ] {
  let repository = "mifi/ezshare"
  let tag_name = ghub tag_name $repository
  let path = bin-path ezshare $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f ezshare -p $path
  }

  bind-file ezshare $path
}

export def qrcp [ --force(-f) ] {
  let repository = "claudiodangelis/qrcp"
  let tag_name = ghub tag_name $repository
  let path = bin-path qrcp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f qrcp -p $path
  }

  bind-file qrcp $path
}

export def qrsync [ --force(-f) ] {
  let repository = "crisidev/qrsync"
  let tag_name = ghub tag_name $repository
  let path = bin-path qrsync $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f qrsync -p $path
  }

  bind-file qrsync $path
}

export def binsider [ --force(-f) ] {
  let repository = "orhun/binsider"
  let tag_name = ghub tag_name $repository
  let path = bin-path binsider $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f binsider -p $path
  }

  bind-file binsider $path
}

export def usql [ --force(-f) ] {
  let repository = "xo/usql"
  let tag_name = ghub tag_name $repository
  let path = bin-path usql $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f usql_static -p $path
  }

  bind-file usql $path
}

export def gotty [ --force(-f) ] {
  let repository = "yudai/gotty"
  let tag_name = ghub tag_name $repository
  let path = bin-path atlas $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gotty -p $path
  }

  bind-file gotty $path
}

export def ttyd [ --force(-f) ] {
  let repository = "tsl0922/ttyd"
  let tag_name = ghub tag_name $repository
  let path = bin-path ttyd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file ttyd $path
}

export def tty-share [ --force(-f) ] {
  let repository = "elisescu/tty-share"
  let tag_name = ghub tag_name $repository
  let path = bin-path tty-share $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file tty-share $path
}

export def upterm [ --force(-f) ] {
  let repository = "owenthereal/upterm"
  let tag_name = ghub tag_name $repository
  let path = bin-path upterm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f upterm -p $path
  }

  bind-file upterm $path
}

export def --env sftpgo [ --force(-f) ] {
  let repository = "drakkan/sftpgo"
  let tag_name = ghub tag_name $repository
  let path = lib-path sftpgo $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.SFTPGO_PATH
  env-path $env.SFTPGO_PATH
}

export def telegram [ --force(-f) ] {
  let repository = "telegramdesktop/tdesktop"
  let tag_name = ghub tag_name $repository
  let path = bin-path telegram $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f Telegram -p $path
  }

  bind-file telegram $path
}

export def tdl [ --force(-f) ] {
  let repository = "iyear/tdl"
  let tag_name = ghub tag_name $repository
  let path = bin-path tdl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f tdl -p $path
  }

  bind-file tdl $path
}

export def kanata [ --force(-f) ] {
  let repository = "jtroo/kanata"
  let tag_name = ghub tag_name $repository
  let path = bin-path kanata $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
    bind-root kanata $path
  }

  bind-file kanata $path
}

export def --env mongosh [ --force(-f) ] {
  let repository = "mongodb-js/mongosh"
  let tag_name = ghub tag_name $repository
  let path = lib-path mongosh $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.MONGOSH_PATH
  env-path $env.MONGOSH_BIN
}

export def shell2http [ --force(-f) ] {
  let repository = "msoap/shell2http"
  let tag_name = ghub tag_name $repository
  let path = bin-path shell2http $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f shell2http -p $path
  }

  bind-file shell2http $path
}

export def mprocs [ --force(-f) ] {
  let repository = "pvolok/mprocs"
  let tag_name = ghub tag_name $repository
  let path = bin-path mprocs $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f mprocs -p $path
  }

  bind-file mprocs $path
}

export def dua [ --force(-f) ] {
  let repository = "Byron/dua-cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path dua $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f dua -p $path
  }

  bind-file dua $path
}

export def grex [ --force(-f) ] {
  let repository = "pemistahl/grex"
  let tag_name = ghub tag_name $repository
  let path = bin-path grex $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f grex -p $path
  }

  bind-file grex $path
}

export def navi [ --force(-f) ] {
  let repository = "denisidoro/navi"
  let tag_name = ghub tag_name $repository
  let path = bin-path navi $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f navi -p $path
  }

  bind-file navi $path
}

export def bore [ --force(-f) ] {
  let repository = "ekzhang/bore"
  let tag_name = ghub tag_name $repository
  let path = bin-path bore $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bore -p $path
  }

  bind-file bore $path
}

export def rclone [ --force(-f) ] {
  let repository = "rclone/rclone"
  let tag_name = ghub tag_name $repository
  let path = bin-path rclone $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f rclone -p $path
    bind-root rclone $path
  }

  bind-file rclone $path
}

export def ffsend [ --force(-f) ] {
  let repository = "timvisee/ffsend"
  let tag_name = ghub tag_name $repository
  let path = bin-path ffsend $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file ffsend $path
}

export def walk [ --force(-f) ] {
  let repository = "antonmedv/walk"
  let tag_name = ghub tag_name $repository
  let path = bin-path walk $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file walk $path
}

export def tere [ --force(-f) ] {
  let repository = "mgunyho/tere"
  let tag_name = ghub tag_name $repository
  let path = bin-path tere $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f tere -p $path
  }

  bind-file tere $path
}

export def sd [ --force(-f) ] {
  let repository = "chmln/sd"
  let tag_name = ghub tag_name $repository
  let path = bin-path sd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f sd -p $path
  }

  bind-file sd $path
}

export def sad [ --force(-f) ] {
  let repository = "ms-jpq/sad"
  let tag_name = ghub tag_name $repository
  let path = bin-path sad $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f sad -p $path
  }

  bind-file sad $path
}

export def fx [ --force(-f) ] {
  let repository = "antonmedv/fx"
  let tag_name = ghub tag_name $repository
  let path = bin-path fx $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file fx $path
}

export def jqp [ --force(-f) ] {
  let repository = "noahgorstein/jqp"
  let tag_name = ghub tag_name $repository
  let path = bin-path jqp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f jqp -p $path
  }

  bind-file jqp $path
}

export def lux [ --force(-f) ] {
  let repository = "iawia002/lux"
  let tag_name = ghub tag_name $repository
  let path = bin-path lux $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lux -p $path
  }

  bind-file lux $path
}

export def qrterminal [ --force(-f) ] {
  let repository = "mdp/qrterminal"
  let tag_name = ghub tag_name $repository
  let path = bin-path qrterminal $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f qrterminal -p $path
  }

  bind-file qrterminal $path
}

export def qrrs [ --force(-f) ] {
  let repository = "Lenivaya/qrrs"
  let tag_name = ghub tag_name $repository
  let path = bin-path qrrs $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f qrrs -p $path
  }

  bind-file qrrs $path
}

export def genact [ --force(-f) ] {
  let repository = "svenstaro/genact"
  let tag_name = ghub tag_name $repository
  let path = bin-path genact $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file genact $path
}

export def ouch [ --force(-f) ] {
  let repository = "ouch-org/ouch"
  let tag_name = ghub tag_name $repository
  let path = bin-path ouch $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f ouch -p $path
  }

  bind-file ouch $path
}

export def lsd [ --force(-f) ] {
  let repository = "lsd-rs/lsd"
  let tag_name = ghub tag_name $repository
  let path = bin-path lsd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lsd -p $path
  }

  bind-file lsd $path
}

export def eza [ --force(-f) ] {
  let repository = "eza-community/eza"
  let tag_name = ghub tag_name $repository
  let path = bin-path eza $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f eza -p $path
  }

  bind-file eza $path
}

export def ast-grep [ --force(-f) ] {
  let repository = "ast-grep/ast-grep"
  let tag_name = ghub tag_name $repository
  let path = lib-path ast-grep $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.AST_GREP_BIN
  env-path $env.AST_GREP_BIN
}

export def d2 [ --force(-f) ] {
  let repository = "terrastruct/d2"
  let tag_name = ghub tag_name $repository
  let path = bin-path d2 $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/d2 -p $path
  }

  bind-file d2 $path
}

export def mdcat [ --force(-f) ] {
  let repository = "swsnr/mdcat"
  let tag_name = ghub tag_name $repository
  let path = bin-path mdcat $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f mdcat -p $path
  }

  bind-file mdcat $path
}

export def chatgpt [ --force(-f) ] {
  let repository = "j178/chatgpt"
  let tag_name = ghub tag_name $repository
  let path = bin-path chatgpt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f chatgpt -p $path
  }

  bind-file chatgpt $path
}

export def aichat [ --force(-f) ] {
  let repository = "sigoden/aichat"
  let tag_name = ghub tag_name $repository
  let path = bin-path aichat $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f aichat -p $path
  }

  bind-file aichat $path
}

export def tgpt [ --force(-f) ] {
  let repository = "aandrew-me/tgpt"
  let tag_name = ghub tag_name $repository
  let path = bin-path tgpt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file tgpt $path
}

export def slices [ --force(-f) ] {
  let repository = "maaslalani/slides"
  let tag_name = ghub tag_name $repository
  let path = bin-path slices $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f slides -p $path
  }

  bind-file slices $path
}

export def nap [ --force(-f) ] {
  let repository = "maaslalani/nap"
  let tag_name = ghub tag_name $repository
  let path = bin-path nap $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f nap -p $path
  }

  bind-file nap $path
}

export def invoice [ --force(-f) ] {
  let repository = "maaslalani/invoice"
  let tag_name = ghub tag_name $repository
  let path = bin-path invoice $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f invoice -p $path
  }

  bind-file invoice $path
}

export def coreutils [ --force(-f) ] {
  let repository = "uutils/coreutils"
  let tag_name = ghub tag_name $repository
  let path = bin-path coreutils $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f coreutils -p $path
  }

  bind-file coreutils $path
}

export def carapace [ --force(-f) ] {

  let repository = "carapace-sh/carapace-bin"
  let tag_name = ghub tag_name $repository
  let path = bin-path carapace $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f carapace -p $path
  }

  bind-file carapace $path
}

export def bombardier [ --force(-f) ] {
  let repository = "codesenberg/bombardier"
  let tag_name = ghub tag_name $repository
  let path = bin-path bombardier $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file bombardier $path
}

export def ruff [ --force(-f) ] {
  let repository = "astral-sh/ruff"
  let tag_name = ghub tag_name $repository
  let path = bin-path ruff $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f ruff -p $path
  }

  bind-file ruff $path
}

export def --env uv [ --force(-f) ] {
  let repository = "astral-sh/uv"
  let tag_name = ghub tag_name $repository
  let path = lib-path uv $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.UV_BIN
  env-path $env.UV_BIN
}

export def --env cargo-binstall [ --force(-f) ] {
  let repository = "cargo-bins/cargo-binstall"
  let tag_name = ghub tag_name $repository
  let path = lib-path cargo-binstall $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.CARGO_BINSTALL_BIN
  env-path $env.CARGO_BINSTALL_BIN
}

export def --env carbonyl [ --force(-f) ] {
  let repository = "fathyb/carbonyl"
  let tag_name = ghub tag_name $repository
  let path = lib-path carbonyl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.CARGO_BINSTALL_BIN
  env-path $env.CARGO_BINSTALL_BIN
}

export def micro [ --force(-f) ] {
  let repository = "zyedidia/micro"
  let tag_name = ghub tag_name $repository
  let path = bin-path micro $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f micro -p $path
  }

  bind-file micro $path
}

export def dufs [ --force(-f) ] {
  let repository = "sigoden/dufs"
  let tag_name = ghub tag_name $repository
  let path = bin-path dufs $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f dufs -p $path
  }

  bind-file dufs $path
}

export def miniserve [ --force(-f) ] {
  let repository = "svenstaro/miniserve"
  let tag_name = ghub tag_name $repository
  let path = bin-path miniserve $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file miniserve $path
}

export def simple-http-server [ --force(-f) ] {
  let repository = "TheWaWaR/simple-http-server"
  let tag_name = ghub tag_name $repository
  let path = bin-path simple-http-server $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file simple-http-server $path
}

export def ftpserver [ --force(-f) ] {
  let repository = "fclairamb/ftpserver"
  let tag_name = ghub tag_name $repository
  let path = bin-path ftpserver $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f ftpserver -p $path
  }

  bind-file ftpserver $path
}

export def onefetch [ --force(-f) ] {
  let repository = "o2sh/onefetch"
  let tag_name = ghub tag_name $repository
  let path = bin-path onefetch $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f onefetch -p $path
  }

  bind-file onefetch $path
}

export def gping [ --force(-f) ] {
  let repository = "orf/gping"
  let tag_name = ghub tag_name $repository
  let path = bin-path gping $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gping -p $path
  }

  bind-file gping $path
}

export def duf [ --force(-f) ] {
  let repository = "muesli/duf"
  let tag_name = ghub tag_name $repository
  let path = bin-path duf $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f duf -p $path
  }

  bind-file duf $path
}

export def github-cli [ --force(-f) ] {
  let repository = "cli/cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path gh $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/gh -p $path
  }

  bind-file gh $path
}

export def dive [ --force(-f) ] {
  let repository = "wagoodman/dive"
  let tag_name = ghub tag_name $repository
  let path = bin-path dive $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f dive -p $path
  }

  bind-file dive $path
}

export def hyperfine [ --force(-f) ] {
  let repository = "sharkdp/hyperfine"
  let tag_name = ghub tag_name $repository
  let path = bin-path hyperfine $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f hyperfine -p $path
  }

  bind-file hyperfine $path
}

export def taskell [ --force(-f) ] {
  let repository = "smallhadroncollider/taskell"
  let tag_name = ghub tag_name $repository
  let path = bin-path taskell $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f taskell -p $path
  }

  bind-file taskell $path
}

export def tasklite [ --force(-f) ] {
  let repository = "ad-si/TaskLite"
  let tag_name = ghub tag_name $repository
  let path = bin-path tasklite $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -f $download_path -p $path
    add-execute $path
  }

  bind-file tasklite $path
}

export def doctl [ --force(-f) ] {
  let repository = "digitalocean/doctl"
  let tag_name = ghub tag_name $repository
  let path = bin-path doctl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f doctl -p $path
  }

  bind-file doctl $path
}

export def hcloud [ --force(-f) ] {
  let repository = "hetznercloud/cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path hcloud $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f hcloud -p $path
  }

  bind-file hcloud $path
}

export def kubecolor [ --force(-f) ] {
  let repository = "kubecolor/kubecolor"
  let tag_name = ghub tag_name $repository
  let path = bin-path kubecolor $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kubecolor -p $path
  }

  bind-file kubecolor $path
}

export def kubetui [ --force(-f) ] {
  let repository = "sarub0b0/kubetui"
  let tag_name = ghub tag_name $repository
  let path = bin-path kubetui $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file kubetui $path
}

export def kube-prompt [ --force(-f) ] {
  let repository = "c-bata/kube-prompt"
  let tag_name = ghub tag_name $repository
  let path = bin-path kube-prompt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kube-prompt -p $path
  }

  bind-file kube-prompt $path
}

export def k9s [ --force(-f) ] {
  let repository = "derailed/k9s"
  let tag_name = ghub tag_name $repository
  let path = bin-path k9s $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f k9s -p $path
  }

  bind-file k9s $path
}

export def kdash [ --force(-f) ] {
  let repository = "kdash-rs/kdash"
  let tag_name = ghub tag_name $repository
  let path = bin-path kdash $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kdash -p $path
  }

  bind-file kdash $path
}

export def bettercap [ --force(-f) ] {
  let repository = "bettercap/bettercap"
  let tag_name = ghub tag_name $repository
  let path = bin-path bettercap $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bettercap -p $path
    bind-root bettercap $path
  }

  bind-file bettercap $path
}

export def viddy [ --force(-f) ] {
  let repository = "sachaos/viddy"
  let tag_name = ghub tag_name $repository
  let path = bin-path viddy $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f viddy -p $path
  }

  bind-file viddy $path
}

export def hwatch [ --force(-f) ] {
  let repository = "blacknon/hwatch"
  let tag_name = ghub tag_name $repository
  let path = bin-path hwatch $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/hwatch -p $path
  }

  bind-file hwatch $path
}

export def kmon [ --force(-f) ] {
  let repository = "orhun/kmon"
  let tag_name = ghub tag_name $repository
  let path = bin-path kmon $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kmon -p $path
  }

  bind-file kmon $path
}

export def --env ollama [ --force(-f) ] {
  let repository = "ollama/ollama"
  let tag_name = ghub tag_name $repository
  let path = lib-path ollama $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.OLLAMA_PATH
  env-path $env.OLLAMA_BIN
}

export def plandex [ --force(-f) ] {
  let repository = "plandex-ai/plandex"
  let tag_name = ghub tag_name $repository
  let path = bin-path plandex $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f plandex -p $path
  }

  bind-file plandex $path
}

export def local-ai [ --force(-f) ] {
  let repository = "mudler/LocalAI"
  let tag_name = ghub tag_name $repository
  let path = bin-path local-ai $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file local-ai $path
}

export def lan-mouse [ --force(-f) ] {
  let repository = "feschber/lan-mouse"
  let tag_name = ghub tag_name $repository
  let path = bin-path lan-mouse $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
    bind-root lan-mouse $path
  }

  bind-file lan-mouse $path
}

export def lapce [ --force(-f) ] {
  let repository = "lapce/lapce"
  let tag_name = ghub tag_name $repository
  let path = bin-path lapce $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lapce -p $path
  }

  bind-file lapce $path
}

export def --env vscodium [ --force(-f) ] {
  let repository = "VSCodium/vscodium"
  let tag_name = ghub tag_name $repository
  let path = lib-path vscodium $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.VSCODIUM_PATH
  env-path $env.VSCODIUM_BIN
}

export def --env code-server [ --force(-f) ] {
  let repository = "coder/code-server"
  let tag_name = ghub tag_name $repository
  let path = lib-path code-server $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.CODE_SERVER_PATH
  env-path $env.CODE_SERVER_BIN
}

export def termshark [ --force(-f) ] {
  let repository = "gcla/termshark"
  let tag_name = ghub tag_name $repository
  let path = bin-path termshark $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f termshark -p $path
  }

  bind-file termshark $path
}

export def termscp [ --force(-f) ] {
  let repository = "veeso/termscp"
  let tag_name = ghub tag_name $repository
  let path = bin-path termscp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f termscp -p $path
  }

  bind-file termscp $path
}

export def kbt [ --force(-f) ] {
  let repository = "bloznelis/kbt"
  let tag_name = ghub tag_name $repository
  let path = bin-path kbt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kbt -p $path
  }

  bind-file kbt $path
}

export def trippy [ --force(-f) ] {
  let repository = "fujiapple852/trippy"
  let tag_name = ghub tag_name $repository
  let path = bin-path trippy $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f trip -p $path
    bind-root trippy $path
  }

  bind-file trippy $path
}

export def gitui [ --force(-f) ] {
  let repository = "extrawurst/gitui"
  let tag_name = ghub tag_name $repository
  let path = bin-path gitui $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f gitui -p $path
  }

  bind-file gitui $path
}

export def monolith [ --force(-f) ] {
  let repository = "Y2Z/monolith"
  let tag_name = ghub tag_name $repository
  let path = bin-path monolith $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file monolith $path
}

export def dijo [ --force(-f) ] {
  let repository = "nerdypepper/dijo"
  let tag_name = ghub tag_name $repository
  let path = bin-path dijo $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file dijo $path
}

export def ventoy [ --force(-f) ] {
  let repository = "ventoy/Ventoy"
  let tag_name = ghub tag_name $repository
  let path = bin-path ventoy $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.VENTOY_PATH
}

export def stash [ --force(-f) ] {
  let repository = "stashapp/stash"
  let tag_name = ghub tag_name $repository
  let path = bin-path stash $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file stash $path
}

export def AdGuardHome [ --force(-f) ] {
  let repository = "AdguardTeam/AdGuardHome"
  let tag_name = ghub tag_name $repository
  let path = bin-path AdGuardHome $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f AdGuardHome -p $path
    bind-root adguardhome $path
  }

  bind-file adguardhome $path
}

export def zen [ --force(-f) ] {
  let repository = "anfragment/zen"
  let tag_name = ghub tag_name $repository
  let path = bin-path zen $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f Zen -p $path
    bind-root zen $path
  }

  bind-file zen $path
}

export def superhtml [ --force(-f) ] {
  let repository = "kristoff-it/superhtml"
  let tag_name = ghub tag_name $repository
  let path = bin-path superhtml $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f superhtml -p $path
  }

  bind-file superhtml $path
}

export def proxyfor [ --force(-f) ] {
  let repository = "sigoden/proxyfor"
  let tag_name = ghub tag_name $repository
  let path = bin-path proxyfor $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f proxyfor -p $path
  }

  bind-file proxyfor $path
}

export def hetty [ --force(-f) ] {
  let repository = "dstotijn/hetty"
  let tag_name = ghub tag_name $repository
  let path = bin-path hetty $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f hetty -p $path
  }

  bind-file hetty $path
}

export def fclones [ --force(-f) ] {
  let repository = "pkolaczk/fclones"
  let tag_name = ghub tag_name $repository
  let path = bin-path fclones $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f release/fclones -p $path
    rm -rf target
  }

  bind-file fclones $path
}

export def nano-work-server [ --force(-f) ] {
  let repository = "nanocurrency/nano-work-server"
  let tag_name = ghub tag_name $repository
  let path = bin-path nano-work-server $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file nano-work-server $path
}

export def mkcert [ --force(-f) ] {
  deps mkcert

  let repository = "FiloSottile/mkcert"
  let tag_name = ghub tag_name $repository
  let path = bin-path mkcert $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file mkcert $path
}

export def cloudflared [ --force(-f) ] {
  let repository = "cloudflare/cloudflared"
  let tag_name = ghub tag_name $repository
  let path = bin-path cloudflared $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file cloudflared $path
}

export def librespeed [ --force(-f) ] {
  let repository = "librespeed/speedtest-cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path librespeed $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f librespeed-cli -p $path
  }

  bind-file librespeed $path
}

export def devbox [ --force(-f) ] {
  let repository = "jetify-com/devbox"
  let tag_name = ghub tag_name $repository
  let path = bin-path devbox $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f devbox -p $path
  }

  bind-file devbox $path
}

export def bun [ --force(-f) ] {
  let repository = "oven-sh/bun"
  let tag_name = ghub tag_name $repository
  let path = bin-path bun $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bun -p $path
  }

  bind-file bun $path
}

export def --env fvm [ --force(-f) ] {
  let repository = "leoafarias/fvm"
  let tag_name = ghub tag_name $repository
  let path = lib-path fvm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.FVM_PATH
  env-path $env.FVM_PATH
}

export def pnpm [ --force(-f) ] {
  let repository = "pnpm/pnpm"
  let tag_name = ghub tag_name $repository
  let path = bin-path pnpm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file pnpm $path
}

export def --env kotlin [ --force(-f) ] {
  let repository = "JetBrains/kotlin"
  let tag_name = ghub tag_name $repository
  let path = lib-path kotlin $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.KOTLIN_PATH
  env-path $env.KOTLIN_BIN
}

export def --env kotlin-native [ --force(-f) ] {
  let repository = "JetBrains/kotlin"
  let tag_name = ghub tag_name $repository
  let path = lib-path kotlin-native $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.KOTLIN_NATIVE_PATH
  env-path $env.KOTLIN_NATIVE_BIN
}

export def --env kotlin-language-server [ --force(-f) ] {
  let repository = "fwcd/kotlin-language-server"
  let tag_name = ghub tag_name $repository
  let path = lib-path kotlin-language-server $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.KOTLIN_LSP_PATH
  env-path $env.KOTLIN_LSP_BIN
}

export def --env lua-language-server [ --force(-f) ] {
  let repository = "LuaLS/lua-language-server"
  let tag_name = ghub tag_name $repository
  let path = lib-path lua-language-server $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.LUA_LSP_PATH
  env-path $env.LUA_LSP_BIN
}

export def --env btcd [ --force(-f) ] {
  let repository = "btcsuite/btcd"
  let tag_name = ghub tag_name $repository
  let path = lib-path btcd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.BTCD_PATH
  env-path $env.BTCD_PATH
}

export def --env bitcoin [ --force(-f) ] {
  let repository = "bitcoin/bitcoin"
  let tag_name = ghub tag_name $repository
  let path = lib-path bitcoin $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.BITCOIN_PATH
  env-path $env.BITCOIN_BIN
}

export def --env lightning-network [ --force(-f) ] {
  let repository = "lightningnetwork/lnd"
  let tag_name = ghub tag_name $repository
  let path = lib-path lightning $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.LIGHTNING_PATH
  env-path $env.LIGHTNING_PATH
}

export def clangd [ --force(-f) ] {
  let repository = "clangd/clangd"
  let tag_name = ghub tag_name $repository
  let path = bin-path clangd $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/clangd -p $path
    bind-root clangd $path
  }

  bind-file clangd $path
}

export def marksman [ --force(-f) ] {
  let repository = "artempyanykh/marksman"
  let tag_name = ghub tag_name $repository
  let path = bin-path marksman $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file marksman $path
}

export def v-analyzer [ --force(-f) ] {
  let repository = "vlang/v-analyzer"
  let tag_name = ghub tag_name $repository
  let path = bin-path v-analyzer $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f v-analyzer -p $path
  }

  bind-file v-analyzer $path
}

export def zls [ --force(-f) ] {
  let repository = "zigtools/zls"
  let tag_name = ghub tag_name $repository
  let path = bin-path zls $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f zls -p $path
  }

  bind-file zls $path
}

export def presenterm [ --force(-f) ] {
  let repository = "mfontanini/presenterm"
  let tag_name = ghub tag_name $repository
  let path = bin-path presenterm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f presenterm -p $path
  }

  bind-file presenterm $path
}

export def contour [ --force(-f) ] {
  let repository = "contour-terminal/contour"
  let tag_name = ghub tag_name $repository
  let path = bin-path contour $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f contour -p $path
  }

  bind-file contour $path
}

export def viu [ --force(-f) ] {
  let repository = "atanunq/viu"
  let tag_name = ghub tag_name $repository
  let path = bin-path viu $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file viu $path
}

export def immich-go [ --force(-f) ] {
  let repository = "simulot/immich-go"
  let tag_name = ghub tag_name $repository
  let path = bin-path immich-go $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f immich-go -p $path
  }

  bind-file immich-go $path
}

export def picocrypt [ --force(-f) ] {
  let repository = "Picocrypt/CLI"
  let tag_name = ghub tag_name $repository
  let path = bin-path picocrypt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file picocrypt $path
}

export def clipboard [ --force(-f) ] {
  let repository = "Slackadays/Clipboard"
  let tag_name = ghub tag_name $repository
  let path = bin-path cb $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bin/cb -p $path
  }

  bind-file cb $path
}

export def vi-mongo [ --force(-f) ] {
  let repository = "kopecmaciej/vi-mongo"
  let tag_name = ghub tag_name $repository
  let path = bin-path vi-mongo $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f vi-mongo -p $path
  }

  bind-file vi-mongo $path
}

export def cloak [ --force(-f) ] {
  let repository = "evansmurithi/cloak"
  let tag_name = ghub tag_name $repository
  let path = bin-path cloak $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f cloak -p $path
  }

  bind-file cloak $path
}

export def totp [ --force(-f) ] {
  let repository = "Zebradil/rustotpony"
  let tag_name = ghub tag_name $repository
  let path = bin-path totp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file totp $path
}

export def totp-cli [ --force(-f) ] {
  let repository = "yitsushi/totp-cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path totp-cli $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f totp-cli -p $path
  }

  bind-file totp-cli $path
}

export def jnv [ --force(-f) ] {
  let repository = "ynqa/jnv"
  let tag_name = ghub tag_name $repository
  let path = bin-path jnv $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f jnv -p $path
  }

  bind-file jnv $path
}

export def devspace [ --force(-f) ] {
  let repository = "devspace-sh/devspace"
  let tag_name = ghub tag_name $repository
  let path = bin-path devspace $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file devspace $path
}

export def atto [ --force(-f) ] {
  let repository = "codesoap/atto"
  let tag_name = ghub tag_name $repository
  let path = bin-path atto $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f atto -p $path
  }

  bind-file atto $path
}

export def wsget [ --force(-f) ] {
  let repository = "ksysoev/wsget"
  let tag_name = ghub tag_name $repository
  let path = bin-path wsget $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f wsget -p $path
  }

  bind-file wsget $path
}

export def koji [ --force(-f) ] {
  let repository = "cococonscious/koji"
  let tag_name = ghub tag_name $repository
  let path = bin-path koji $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f koji -p $path
  }

  bind-file koji $path
}

export def smartcat [ --force(-f) ] {
  let repository = "efugier/smartcat"
  let tag_name = ghub tag_name $repository
  let path = bin-path sc $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f sc -p $path
  }

  bind-file sc $path
}

export def jwt [ --force(-f) ] {
  let repository = "mike-engel/jwt-cli"
  let tag_name = ghub tag_name $repository
  let path = bin-path jwt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f jwt -p $path
  }

  bind-file jwt $path
}

export def procs [ --force(-f) ] {
  let repository = "dalance/procs"
  let tag_name = ghub tag_name $repository
  let path = bin-path procs $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f procs -p $path
  }

  bind-file procs $path
}

export def oha [ --force(-f) ] {
  let repository = "hatoo/oha"
  let tag_name = ghub tag_name $repository
  let path = bin-path oha $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file oha $path
}

export def adguardian [ --force(-f) ] {
  let repository = "Lissy93/AdGuardian-Term"
  let tag_name = ghub tag_name $repository
  let path = bin-path adguardian $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file adguardian $path
}

export def --env gix [ --force(-f) ] {
  let repository = "GitoxideLabs/gitoxide"
  let tag_name = ghub tag_name $repository
  let path = bin-path gix $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.GITOXIDE_BIN
  env-path $env.GITOXIDE_BIN
}

export def kubewall [ --force(-f) ] {
  let repository = "kubewall/kubewall"
  let tag_name = ghub tag_name $repository
  let path = bin-path kubewall $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f kubewall -p $path
  }

  bind-file kubewall $path
}

export def f2 [ --force(-f) ] {
  let repository = "ayoisaiah/f2"
  let tag_name = ghub tag_name $repository
  let path = bin-path f2 $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f f2 -p $path
  }

  bind-file f2 $path
}

export def doggo [ --force(-f) ] {
  let repository = "mr-karan/doggo"
  let tag_name = ghub tag_name $repository
  let path = bin-path doggo $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f doggo -p $path
  }

  bind-file doggo $path
}

export def lnav [ --force(-f) ] {
  let repository = "tstack/lnav"
  let tag_name = ghub tag_name $repository
  let path = bin-path lnav $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lnav -p $path
  }

  bind-file lnav $path
}

export def --env scrcpy [ --force(-f) ] {
  let repository = "Genymobile/scrcpy"
  let tag_name = ghub tag_name $repository
  let path = lib-path scrcpy $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -p $path
  }

  bind-dir $path $env.SCRCPY_BIN
  env-path $env.SCRCPY_BIN
}

export def apkeep [ --force(-f) ] {
  let repository = "EFForg/apkeep"
  let tag_name = ghub tag_name $repository
  let path = bin-path apkeep $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file apkeep $path
}

export def lf [ --force(-f) ] {
  let repository = "gokcehan/lf"
  let tag_name = ghub tag_name $repository
  let path = bin-path lf $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lf -p $path
  }

  bind-file lf $path
}

export def wdcrypt [ --force(-f) ] {
  let repository = "stefins/wdcrypt"
  let tag_name = ghub tag_name $repository
  let path = bin-path wdcrypt $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file wdcrypt $path
}

export def upscayl-bin [ --force(-f) ] {
  let repository = "upscayl/upscayl-ncnn"
  let tag_name = ghub tag_name $repository
  let path = bin-path upscayl-bin $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f upscayl-bin -p $path
  }

  bind-file upscayl-bin $path
}

export def resvg [ --force(-f) ] {
  let repository = "linebender/resvg"
  let tag_name = ghub tag_name $repository
  let path = bin-path resvg $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f resvg -p $path
  }

  bind-file resvg $path
}

export def yt-dlp [ --force(-f) ] {
  let repository = "yt-dlp/yt-dlp"
  let tag_name = ghub tag_name $repository
  let path = bin-path yt-dlp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file yt-dlp $path
}

export def go2tv [ --force(-f) ] {
  let repository = "alexballas/go2tv"
  let tag_name = ghub tag_name $repository
  let path = bin-path go2tv $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f go2tv -p $path
  }

  bind-file go2tv $path
}

export def tv [ --force(-f) ] {
  let repository = "alexpasmantier/television"
  let tag_name = ghub tag_name $repository
  let path = bin-path tv $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f tv -p $path
  }

  bind-file tv $path
}

export def cyme [ --force(-f) ] {
  let repository = "tuna-f1sh/cyme"
  let tag_name = ghub tag_name $repository
  let path = bin-path cyme $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f cyme -p $path
  }

  bind-file cyme $path
}

export def omm [ --force(-f) ] {
  let repository = "dhth/omm"
  let tag_name = ghub tag_name $repository
  let path = bin-path omm $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f omm -p $path
  }

  bind-file omm $path
}

export def cotp [ --force(-f) ] {
  let repository = "replydev/cotp"
  let tag_name = ghub tag_name $repository
  let path = bin-path cotp $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f cotp -p $path
  }

  bind-file cotp $path
}

export def openapi-tui [ --force(-f) ] {
  let repository = "zaghaghi/openapi-tui"
  let tag_name = ghub tag_name $repository
  let path = bin-path openapi-tui $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f openapi-tui -p $path
  }

  bind-file openapi-tui $path
}

export def eget [ --force(-f) ] {
  let repository = "zyedidia/eget"
  let tag_name = ghub tag_name $repository
  let path = bin-path eget $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f eget -p $path
  }

  bind-file eget $path
}

export def oryx [ --force(-f) ] {
  let repository = "pythops/oryx"
  let tag_name = ghub tag_name $repository
  let path = bin-path oryx $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file oryx $path
}

export def impala [ --force(-f) ] {
  let repository = "pythops/impala"
  let tag_name = ghub tag_name $repository
  let path = bin-path impala $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file impala $path
}

export def bluetui [ --force(-f) ] {
  let repository = "pythops/bluetui"
  let tag_name = ghub tag_name $repository
  let path = bin-path bluetui $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file bluetui $path
}

export def tenere [ --force(-f) ] {
  let repository = "pythops/tenere"
  let tag_name = ghub tag_name $repository
  let path = bin-path tenere $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind-file tenere $path
}

export def bluetuith [ --force(-f) ] {
  let repository = "bluetuith-org/bluetuith"
  let tag_name = ghub tag_name $repository
  let path = bin-path bluetuith $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f bluetuith -p $path
  }

  bind-file bluetuith $path
}

export def serpl [ --force(-f) ] {
  let repository = "yassinebridi/serpl"
  let tag_name = ghub tag_name $repository
  let path = bin-path serpl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f serpl -p $path
  }

  bind-file serpl $path
}

export def rgr [ --force(-f) ] {
  let repository = "acheronfail/repgrep"
  let tag_name = ghub tag_name $repository
  let path = bin-path repgrep $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f rgr -p $path
  }

  bind-file rgr $path
}

export def rain [ --force(-f) ] {
  let repository = "cenkalti/rain"
  let tag_name = ghub tag_name $repository
  let path = bin-path rain $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f rain -p $path
    bind-root rain $path
  }

  bind-file rain $path
}

export def tabiew [ --force(-f) ] {
  let repository = "shshemi/tabiew"
  let tag_name = ghub tag_name $repository
  let path = bin-path tabiew $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    move -f $download_path -p $path
    add-execute $path
  }

  bind-file tabiew $path
}

export def csvlens [ --force(-f) ] {
  let repository = "YS-L/csvlens"
  let tag_name = ghub tag_name $repository
  let path = bin-path csvlens $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f csvlens -p $path
  }

  bind-file csvlens $path
}

export def lumen [ --force(-f) ] {
  let repository = "jnsahaj/lumen"
  let tag_name = ghub tag_name $repository
  let path = bin-path lumen $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f lumen -p $path
  }

  bind-file lumen $path
}

export def gfold [ --force(-f) ] {
  let repository = "nickgerace/gfold"
  let tag_name = ghub tag_name $repository
  let path = bin-path gfold $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    move -f $download_path -p $path
    add-execute $path
  }

  bind-file gfold $path
}

export def andcli [ --force(-f) ] {
  let repository = "tjblackheart/andcli"
  let tag_name = ghub tag_name $repository
  let path = bin-path andcli $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download $repository --force=($force)
    move -f $download_path -p $path
    add-execute $path
  }

  bind-file andcli $path
}

export def hexyl [ --force(-f) ] {
  let repository = "sharkdp/hexyl"
  let tag_name = ghub tag_name $repository
  let path = bin-path hexyl $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f hexyl -p $path
  }

  bind-file hexyl $path
}

export def opencode [ --force(-f) ] {
  let repository = "sst/opencode"
  let tag_name = ghub tag_name $repository
  let path = bin-path opencode $tag_name

  if (path-not-exists $path $force) {
    let download_path = ghub asset download -x $repository --force=($force)
    move -d $download_path -f opencode -p $path
  }

  bind-file opencode $path
}
