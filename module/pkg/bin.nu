
def path-not-exists [path: string, force: bool] {
  (not ($path | path exists) or $force)
}

def download [ url: string, filename?: string, --force(-f) ] {
  let path = if ($filename | is-not-empty) {
   $env.DOWNLOAD_PATH_FILE | path join $filename
  } else {
    $env.DOWNLOAD_PATH_FILE | path join ($url | url filename)
  }
  if (path-not-exists $path $force) {
    http download $url --output $path
  }
  return $path
}

def decompress [path: path] {
  if not ($path | path exists) {
    error make {msg: $"Path not exists: ($path)"}
  }

  let dir = mktemp --directory --tmpdir-path $env.DOWNLOAD_PATH_DIR
  mkdir $dir

  if $path =~ ".tar" or $path =~ ".tgz" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract tar...' -- tar -xvf $path -C $dir
    } else {
      tar -xvf $path -C $dir
    }
  } else if $path =~ ".zip" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract tar...' -- unzip $path -d $dir
    } else {
      unzip $path -d $dir
    }
  } else {
      error make {msg: "Unsupported file format"}
  }

  let content = (ls $dir | get name)
  let first_item = ($content | first)

  if ($content | length) == 1 and ($first_item | path type) == "dir" {
    let nested_content = (ls $first_item | get name)
    let second_item = ($nested_content | first)

    if ($nested_content | length) == 1 and ($second_item | path type) == "dir" {
      return $second_item
    }
    return $first_item
  }
  return $dir
}

export def xh [ --force(-f) ] {
  let repository = 'ducaale/xh'
  let tag_name = ghub tag_name $repository
  let path = filepath xh $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name 
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f xh -p $path
  }

  bind file xh $path
  bind root xh $path
}

export def --env helix [ --force(-f) ] {
  let repository = 'helix-editor/helix'
  let tag_name = ghub tag_name $repository
  let path = dirpath helix $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.HELIX_PATH
  env-path $env.HELIX_PATH

  bind file hx ($env.HELIX_PATH | path join hx)
  bind root hx ($env.HELIX_PATH | path join hx)
}

export def --env nushell [ --force(-f) ] {
  let repository = 'nushell/nushell'
  let tag_name = ghub tag_name $repository
  let path = filepath nushell $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.NUSHELL_BIN
  env-path $env.NUSHELL_BIN

  bind root nu ($path | path join nu)
}

export def starship [ --force(-f) ] {
  let repository = 'starship/starship'
  let tag_name = ghub tag_name $repository
  let path = filepath starship $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f starship -p $path
  }

  bind file starship $path
  bind root starship $path
}

export def zoxide [ --force(-f) ] {
  let repository = 'ajeetdsouza/zoxide'
  let tag_name = ghub tag_name $repository
  let path = filepath zoxide $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f zoxide -p $path
  }

  bind file zoxide $path
  bind root zoxide $path
}

export def zellij [--force(-f)] {
  let repository = 'zellij-org/zellij'
  let tag_name = ghub tag_name $repository
  let path = filepath zellij $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f zellij -p $path
  }

  bind file zellij $path
  bind root zellij $path
}

export def rg [ --force(-f) ] {
  let repository = 'BurntSushi/ripgrep'
  let tag_name = ghub tag_name $repository
  let path = filepath rg $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f rg -p $path
  }

  bind file rg $path
  bind root rg $path
}

export def fd [ --force(-f) ] {
  let repository = 'sharkdp/fd'
  let tag_name = ghub tag_name $repository
  let path = filepath fd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f fd -p $path
  }

  bind file fd $path
  bind root fd $path
}

export def fzf [ --force(-f) ] {
  let repository = 'junegunn/fzf'
  let tag_name = ghub tag_name $repository
  let path = filepath fzf $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f fzf -p $path
  }

  bind file fzf $path
  bind root fzf $path
}

export def gum [ --force(-f) ] {
  let repository = 'charmbracelet/gum'
  let tag_name = ghub tag_name $repository
  let path = filepath gum $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gum -p $path
  }

  bind file gum $path
}

export def mods [ --force(-f) ] {
  let repository = 'charmbracelet/mods'
  let tag_name = ghub tag_name $repository
  let path = filepath mods $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f mods -p $path
  }

  bind file mods $path
}

export def glow [ --force(-f) ] {
  let repository = 'charmbracelet/glow'
  let tag_name = ghub tag_name $repository
  let path = filepath glow $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f glow -p $path
  }

  bind file glow $path
}

export def soft [ --force(-f) ] {
  let repository = 'charmbracelet/soft-serve'
  let tag_name = ghub tag_name $repository
  let path = filepath soft $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f soft -p $path
  }

  bind file soft $path
}

export def vhs [ --force(-f) ] {
  let repository = 'charmbracelet/vhs'
  let tag_name = ghub tag_name $repository
  let path = filepath vhs $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f vhs -p $path
  }

  bind file vhs $path
}

export def freeze [ --force(-f) ] {
  let repository = 'charmbracelet/freeze'
  let tag_name = ghub tag_name $repository
  let path = filepath freeze $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f freeze -p $path
  }

  bind file freeze $path
}

export def melt [ --force(-f) ] {
  let repository = 'charmbracelet/melt'
  let tag_name = ghub tag_name $repository
  let path = filepath melt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f melt -p $path
  }

  bind file melt $path
}

export def skate [ --force(-f) ] {
  let repository = 'charmbracelet/skate'
  let tag_name = ghub tag_name $repository
  let path = filepath skate $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f skate -p $path
  }

  bind file skate $path
}

export def --env nvim [ --force(-f) ] {
  let repository = 'neovim/neovim'
  let tag_name = ghub tag_name $repository
  let path = dirpath nvim $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f nvim-linux64 -p $path
  }

  bind dir $path $env.NVIM_PATH
  env-path $env.NVIM_BIN
}

export def broot [ --force(-f) ] {
  let repository = 'Canop/broot'
  let tag_name = ghub tag_name $repository
  let path = filepath broot $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f x86_64-linux/broot -p $path
  }

  bind file broot $path
}

export def mirrord [ --force(-f) ] {
  let repository = 'metalbear-co/mirrord'
  let tag_name = ghub tag_name $repository
  let path = filepath mirrord $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f mirrord -p $path
  }

  bind file mirrord $path
}

export def gitu [ --force(-f) ] {
  let repository = 'altsem/gitu'
  let tag_name = ghub tag_name $repository
  let path = filepath gitu $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gitu -p $path
  }

  bind file gitu $path
}

export def fm [ --force(-f) ] {
  let repository = 'mistakenelf/fm'
  let tag_name = ghub tag_name $repository
  let path = filepath fm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f fm -p $path
  }

  bind file fm $path
}

export def superfile [ --force(-f) ] {
  let repository = 'yorukot/superfile'
  let tag_name = ghub tag_name $repository
  let path = filepath spf $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f spf -p $path
  }

  bind file spf $path
}

export def zk [ --force(-f) ] {
  let repository = 'zk-org/zk'
  let tag_name = ghub tag_name $repository
  let path = filepath zk $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f zk -p $path
  }

  bind file zk $path
}

export def hostctl [ --force(-f) ] {
  let repository = 'guumaster/hostctl'
  let tag_name = ghub tag_name $repository
  let path = filepath hostctl $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f hostctl -p $path
  }

  bind file hostctl $path
}

export def bat [ --force(-f) ] {
  let repository = 'sharkdp/bat'
  let tag_name = ghub tag_name $repository
  let path = filepath bat $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bat -p $path
  }

  bind file bat $path
}

export def gdu [ --force(-f) ] {
  let repository = 'dundee/gdu'
  let tag_name = ghub tag_name $repository
  let path = filepath gdu $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gdu_linux_amd64_static -p $path
  }

  bind file gdu $path
  bind root gdu $path
}

export def task [ --force(-f) ] {
  let repository = 'go-task/task'
  let tag_name = ghub tag_name $repository
  let path = filepath task $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f task -p $path
  }

  bind file task $path
  bind root task $path
}

export def mouseless [ --force(-f) ] {
  let repository = 'jbensmann/mouseless'
  let tag_name = ghub tag_name $repository
  let path = filepath mouseless $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f mouseless -p $path
  }

  bind file mouseless $path
  bind root mouseless $path
}

export def websocat [ --force(-f) ] {
  let repository = 'vi/websocat'
  let tag_name = ghub tag_name $repository
  let path = filepath websocat $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file websocat $path
}

export def --env amber [ --force(-f) ] {
  let repository = 'dalance/amber'
  let tag_name = ghub tag_name $repository
  let path = dirpath amber $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.AMBER_BIN
  env-path $env.AMBER_BIN
}

export def obsidian-cli [ --force(-f) ] {
  let repository = 'Yakitrak/obsidian-cli'
  let tag_name = ghub tag_name $repository
  let path = filepath obsidian-cli $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f obsidian-cli -p $path
  }

  bind file obsidian-cli $path
}

export def lazygit [ --force(-f) ] {
  let repository = 'jesseduffield/lazygit'
  let tag_name = ghub tag_name $repository
  let path = filepath lazygit $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lazygit -p $path
  }

  bind file lazygit $path
}

export def lazydocker [ --force(-f) ] {
  let repository = 'jesseduffield/lazydocker'
  let tag_name = ghub tag_name $repository
  let path = filepath lazydocker $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lazydocker -p $path
  }

  bind file lazydocker $path
}

export def oxker [ --force(-f) ] {
  let repository = 'mrjackwills/oxker'
  let tag_name = ghub tag_name $repository
  let path = filepath oxker $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f oxker -p $path
  }

  bind file oxker $path
}

export def lazycli [ --force(-f) ] {
  let repository = 'jesseduffield/lazycli'
  let tag_name = ghub tag_name $repository
  let path = filepath lazycli $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lazycli -p $path
  }

  bind file lazycli $path
}

export def horcrux [ --force(-f) ] {
  let repository = 'jesseduffield/horcrux'
  let tag_name = ghub tag_name $repository
  let path = filepath horcrux $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f horcrux -p $path
  }

  bind file horcrux $path
}

export def tweety [ --force(-f) ] {
  let repository = 'pomdtr/tweety'
  let tag_name = ghub tag_name $repository
  let path = filepath tweety $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f tweety -p $path
  }

  bind file tweety $path
}

export def podman-tui [ --force(-f) ] {
  let repository = 'containers/podman-tui'
  let tag_name = ghub tag_name $repository
  let path = filepath podman-tui $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f podman-tui -p $path
  }

  bind file podman-tui $path
  bind root podman-tui $path
}

export def jless [ --force(-f) ] {
  let repository = 'PaulJuliusMartinez/jless'
  let tag_name = ghub tag_name $repository
  let path = filepath jless $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f jless -p $path
  }

  bind file jless $path
}

export def silicon [ --force(-f) ] {
  let repository = 'Aloxaf/silicon'
  let tag_name = ghub tag_name $repository
  let path = filepath silicon $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f silicon -p $path
  }

  bind file silicon $path
}

export def dasel [ --force(-f) ] {
  let repository = 'TomWright/dasel'
  let tag_name = ghub tag_name $repository
  let path = filepath dasel $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file dasel $path
}

export def pueue [ --force(-f) ] {
  let repository = 'Nukesor/pueue'
  let tag_name = ghub tag_name $repository

  let path = filepath pueue $tag_name
  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name pueue-
    print $asset
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }
  bind file pueue $path

  let path = filepath pueued $tag_name
  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name pueued-
    print $asset
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }
  bind file pueued $path
}

export def delta [ --force(-f) ] {
  let repository = 'dandavison/delta'
  let tag_name = ghub tag_name $repository
  let path = filepath delta $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f delta -p $path
  }

  bind file delta $path
}

export def difftastic [ --force(-f) ] {
  let repository = 'Wilfred/difftastic'
  let tag_name = ghub tag_name $repository
  let path = filepath difft $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f difft -p $path
  }

  bind file difft $path
}

export def bottom [ --force(-f) ] {
  let repository = 'ClementTsang/bottom'
  let tag_name = ghub tag_name $repository
  let path = filepath btm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f btm -p $path
  }

  bind file btm $path
}

export def ttyper [ --force(-f) ] {
  let repository = 'max-niederman/ttyper'
  let tag_name = ghub tag_name $repository
  let path = filepath ttyper $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f ttyper -p $path
  }

  bind file ttyper $path
}

export def qrcp [ --force(-f) ] {
  let repository = 'claudiodangelis/qrcp'
  let tag_name = ghub tag_name $repository
  let path = filepath qrcp $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f qrcp -p $path
  }

  bind file qrcp $path
}

export def qrsync [ --force(-f) ] {
  let repository = 'crisidev/qrsync'
  let tag_name = ghub tag_name $repository
  let path = filepath qrsync $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f qrsync -p $path
  }

  bind file qrsync $path
}

export def binsider [ --force(-f) ] {
  let repository = 'orhun/binsider'
  let tag_name = ghub tag_name $repository
  let path = filepath binsider $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f binsider -p $path
  }

  bind file binsider $path
}

export def usql [ --force(-f) ] {
  let repository = 'xo/usql'
  let tag_name = ghub tag_name $repository
  let path = filepath usql $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name usql_static
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f usql_static -p $path
  }

  bind file usql $path
}

export def atlas [ --eula, --force(-f) ] {
  let repository = 'ariga/atlas'
  let tag_name = ghub tag_name $repository
  let path = filepath atlas $tag_name

  if (path-not-exists $path $force) {
    let filename = if $eula {
      'atlas-linux-amd64-latest'
    } else {
      'atlas-community-linux-amd64-latest'
    }
      let asset = ghub asset $repository $tag_name
      let download_url = ghub download_url $repository $tag_name $asset
    let file = download $'https://release.ariga.io/atlas/($filename)'
    add-execute $file
    move -f $file -p $path
  }

  bind file atlas $path
}

export def gotty [ --force(-f) ] {
  let repository = 'yudai/gotty'
  let tag_name = ghub tag_name $repository
  let path = filepath atlas $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gotty -p $path
  }

  bind file gotty $path
}

export def ttyd [ --force(-f) ] {
  let repository = 'tsl0922/ttyd'
  let tag_name = ghub tag_name $repository
  let path = filepath ttyd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file ttyd $path
}

export def tty-share [ --force(-f) ] {
  let repository = 'elisescu/tty-share'
  let tag_name = ghub tag_name $repository
  let path = filepath tty-share $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file tty-share $path
}

export def upterm [ --force(-f) ] {
  let repository = 'owenthereal/upterm'
  let tag_name = ghub tag_name $repository
  let path = filepath upterm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f upterm -p $path
  }

  bind file upterm $path
}

export def --env sftpgo [ --force(-f) ] {
  let repository = 'drakkan/sftpgo'
  let tag_name = ghub tag_name $repository
  let path = dirpath sftpgo $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.SFTPGO_PATH
  env-path $env.SFTPGO_PATH
}

export def telegram [ --force(-f) ] {
  let repository = 'telegramdesktop/tdesktop'
  let tag_name = ghub tag_name $repository
  let path = filepath telegram $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f Telegram -p $path
  }

  bind file telegram $path
}

export def tdl [ --force(-f) ] {
  let repository = 'iyear/tdl'
  let tag_name = ghub tag_name $repository
  let path = filepath tdl $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f tdl -p $path
  }

  bind file tdl $path
}

export def kanata [ --force(-f) ] {
  let repository = 'jtroo/kanata'
  let tag_name = ghub tag_name $repository
  let path = filepath kanata $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file kanata $path
  bind root kanata $path
}

export def --env mongosh [ --force(-f) ] {
  let repository = 'mongodb-js/mongosh'
  let tag_name = ghub tag_name $repository
  let path = dirpath mongosh $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.MONGOSH_PATH
  env-path $env.MONGOSH_BIN
}

export def shell2http [ --force(-f) ] {
  let repository = 'msoap/shell2http'
  let tag_name = ghub tag_name $repository
  let path = filepath shell2http $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f shell2http -p $path
  }

  bind file shell2http $path
}

export def mprocs [ --force(-f) ] {
  let repository = 'pvolok/mprocs'
  let tag_name = ghub tag_name $repository
  let path = filepath mprocs $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f mprocs -p $path
  }

  bind file mprocs $path
}

export def dua [ --force(-f) ] {
  let repository = 'Byron/dua-cli'
  let tag_name = ghub tag_name $repository
  let path = filepath dua $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f dua -p $path
  }

  bind file dua $path
}

export def grex [ --force(-f) ] {
  let repository = 'pemistahl/grex'
  let tag_name = ghub tag_name $repository
  let path = filepath grex $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f grex -p $path
  }

  bind file grex $path
}

export def navi [ --force(-f) ] {
  let repository = 'denisidoro/navi'
  let tag_name = ghub tag_name $repository
  let path = filepath navi $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f navi -p $path
  }

  bind file navi $path
}

export def bore [ --force(-f) ] {
  let repository = 'ekzhang/bore'
  let tag_name = ghub tag_name $repository
  let path = filepath bore $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bore -p $path
  }

  bind file bore $path
}

export def rclone [ --force(-f) ] {
  let repository = 'rclone/rclone'
  let tag_name = ghub tag_name $repository
  let path = filepath rclone $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f rclone -p $path
  }

  bind file rclone $path
  bind root rclone $path
}

export def ffsend [ --force(-f) ] {
  let repository = 'timvisee/ffsend'
  let tag_name = ghub tag_name $repository
  let path = filepath ffsend $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file ffsend $path
}

export def walk [ --force(-f) ] {
  let repository = 'antonmedv/walk'
  let tag_name = ghub tag_name $repository
  let path = filepath walk $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file walk $path
}

export def tere [ --force(-f) ] {
  let repository = 'mgunyho/tere'
  let tag_name = ghub tag_name $repository
  let path = filepath tere $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f tere -p $path
  }

  bind file tere $path
}

export def sd [ --force(-f) ] {
  let repository = 'chmln/sd'
  let tag_name = ghub tag_name $repository
  let path = filepath sd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f sd -p $path
  }

  bind file sd $path
}

export def sad [ --force(-f) ] {
  let repository = 'ms-jpq/sad'
  let tag_name = ghub tag_name $repository
  let path = filepath sad $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f sad -p $path
  }

  bind file sad $path
}

export def fx [ --force(-f) ] {
  let repository = 'antonmedv/fx'
  let tag_name = ghub tag_name $repository
  let path = filepath fx $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file fx $path
}

export def jqp [ --force(-f) ] {
  let repository = 'noahgorstein/jqp'
  let tag_name = ghub tag_name $repository
  let path = filepath jqp $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f jqp -p $path
  }

  bind file jqp $path
}

export def lux [ --force(-f) ] {
  let repository = 'iawia002/lux'
  let tag_name = ghub tag_name $repository
  let path = filepath lux $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lux -p $path
  }

  bind file lux $path
}

export def qrterminal [ --force(-f) ] {
  let repository = 'mdp/qrterminal'
  let tag_name = ghub tag_name $repository
  let path = filepath qrterminal $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f qrterminal -p $path
  }

  bind file qrterminal $path
}

export def qrrs [ --force(-f) ] {
  let repository = 'Lenivaya/qrrs'
  let tag_name = ghub tag_name $repository
  let path = filepath qrrs $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f qrrs -p $path
  }

  bind file qrrs $path
}

export def genact [ --force(-f) ] {
  let repository = 'svenstaro/genact'
  let tag_name = ghub tag_name $repository
  let path = filepath genact $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file genact $path
}

export def ouch [ --force(-f) ] {
  let repository = 'ouch-org/ouch'
  let tag_name = ghub tag_name $repository
  let path = filepath ouch $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f ouch -p $path
  }

  bind file ouch $path
}

export def lsd [ --force(-f) ] {
  let repository = 'lsd-rs/lsd'
  let tag_name = ghub tag_name $repository
  let path = filepath lsd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lsd -p $path
  }

  bind file lsd $path
}

export def eza [ --force(-f) ] {
  let repository = 'eza-community/eza'
  let tag_name = ghub tag_name $repository
  let path = filepath eza $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f eza -p $path
  }

  bind file eza $path
}

export def ast-grep [ --force(-f) ] {
  let repository = 'ast-grep/ast-grep'
  let tag_name = ghub tag_name $repository
  let path = filepath sg $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f sg -p $path
  }

  bind file sg $path
}

export def d2 [ --force(-f) ] {
  let repository = 'terrastruct/d2'
  let tag_name = ghub tag_name $repository
  let path = filepath d2 $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bin/d2 -p $path
  }

  bind file d2 $path
}

export def mdcat [ --force(-f) ] {
  let repository = 'swsnr/mdcat'
  let tag_name = ghub tag_name $repository
  let path = filepath mdcat $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f mdcat -p $path
  }

  bind file mdcat $path
}

export def chatgpt [ --force(-f) ] {
  let repository = 'j178/chatgpt'
  let tag_name = ghub tag_name $repository
  let path = filepath chatgpt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f chatgpt -p $path
  }

  bind file chatgpt $path
}

export def aichat [ --force(-f) ] {
  let repository = 'sigoden/aichat'
  let tag_name = ghub tag_name $repository
  let path = filepath aichat $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f aichat -p $path
  }

  bind file aichat $path
}

export def tgpt [ --force(-f) ] {
  let repository = 'aandrew-me/tgpt'
  let tag_name = ghub tag_name $repository
  let path = filepath tgpt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file tgpt $path
}

export def slices [ --force(-f) ] {
  let repository = 'maaslalani/slides'
  let tag_name = ghub tag_name $repository
  let path = filepath slices $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f slides -p $path
  }

  bind file slices $path
}

export def nap [ --force(-f) ] {
  let repository = 'maaslalani/nap'
  let tag_name = ghub tag_name $repository
  let path = filepath nap $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f nap -p $path
  }

  bind file nap $path
}

export def invoice [ --force(-f) ] {
  let repository = 'maaslalani/invoice'
  let tag_name = ghub tag_name $repository
  let path = filepath invoice $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f invoice -p $path
  }

  bind file invoice $path
}

export def coreutils [ --force(-f) ] {
  let repository = 'uutils/coreutils'
  let tag_name = ghub tag_name $repository
  let path = filepath coreutils $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f coreutils -p $path
  }

  bind file coreutils $path
}

export def carapace [ --force(-f) ] {

  let repository = 'carapace-sh/carapace-bin'
  let tag_name = ghub tag_name $repository
  let path = filepath carapace $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f carapace -p $path
  }

  bind file carapace $path
}

export def bombardier [ --force(-f) ] {
  let repository = 'codesenberg/bombardier'
  let tag_name = ghub tag_name $repository
  let path = filepath bombardier $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file bombardier $path
}

export def ruff [ --force(-f) ] {
  let repository = 'astral-sh/ruff'
  let tag_name = ghub tag_name $repository
  let path = filepath ruff $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f ruff -p $path
  }

  bind file ruff $path
}

export def --env uv [ --force(-f) ] {
  let repository = 'astral-sh/uv'
  let tag_name = ghub tag_name $repository
  let path = dirpath uv $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.UV_BIN
  env-path $env.UV_BIN
}

export def micro [ --force(-f) ] {
  let repository = 'zyedidia/micro'
  let tag_name = ghub tag_name $repository
  let path = filepath micro $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f micro -p $path
  }

  bind file micro $path
}

export def dufs [ --force(-f) ] {
  let repository = 'sigoden/dufs'
  let tag_name = ghub tag_name $repository
  let path = filepath dufs $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f dufs -p $path
  }

  bind file dufs $path
}

export def miniserve [ --force(-f) ] {
  let repository = 'svenstaro/miniserve'
  let tag_name = ghub tag_name $repository
  let path = filepath miniserve $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file miniserve $path
}

export def simple-http-server [ --force(-f) ] {
  let repository = 'TheWaWaR/simple-http-server'
  let tag_name = ghub tag_name $repository
  let path = filepath simple-http-server $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file simple-http-server $path
}

export def ftpserver [ --force(-f) ] {
  let repository = 'fclairamb/ftpserver'
  let tag_name = ghub tag_name $repository
  let path = filepath ftpserver $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f ftpserver -p $path
  }

  bind file ftpserver $path
}

export def onefetch [ --force(-f) ] {
  let repository = 'o2sh/onefetch'
  let tag_name = ghub tag_name $repository
  let path = filepath onefetch $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f onefetch -p $path
  }

  bind file onefetch $path
}

export def gping [ --force(-f) ] {
  let repository = 'orf/gping'
  let tag_name = ghub tag_name $repository
  let path = filepath gping $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gping -p $path
  }

  bind file gping $path
}

export def duf [ --force(-f) ] {
  let repository = 'muesli/duf'
  let tag_name = ghub tag_name $repository
  let path = filepath duf $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f duf -p $path
  }

  bind file duf $path
}

export def github [ --force(-f) ] {
  let repository = 'cli/cli'
  let tag_name = ghub tag_name $repository
  let path = filepath gh $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gh -p $path
  }

  bind file gh $path
}

export def gitlab [ --force(-f) ] {
  let version = '1.52.0'
  let path = filepath glab $version

  if (path-not-exists $path $force) {
    let file = download https://gitlab.com/gitlab-org/cli/-/releases/v($version)/downloads/glab_($version)_linux_amd64.tar.gz
    let dir = decompress $file
    move -d $dir -f bin/glab -p $path
  }

  bind file glab $path
}

export def gitlab-runner [ --force(-f) ] {
  sudo curl -L --output /usr/local/bin/gitlab-runner 'https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64'
  sudo chmod 777 /usr/local/bin/gitlab-runner
  sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
  sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
  sudo gitlab-runner start
}

export def dive [ --force(-f) ] {
  let repository = 'wagoodman/dive'
  let tag_name = ghub tag_name $repository
  let path = filepath dive $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f dive -p $path
  }

  bind file dive $path
}

export def hyperfine [ --force(-f) ] {
  let repository = 'sharkdp/hyperfine'
  let tag_name = ghub tag_name $repository
  let path = filepath hyperfine $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f hyperfine -p $path
  }

  bind file hyperfine $path
}

export def taskell [ --force(-f) ] {
  let repository = 'smallhadroncollider/taskell'
  let tag_name = ghub tag_name $repository
  let path = filepath taskell $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f taskell -p $path
  }

  bind file taskell $path
}

export def tasklite [ --force(-f) ] {
  let repository = 'ad-si/TaskLite'
  let tag_name = ghub tag_name $repository
  let path = filepath tasklite $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    add-execute $file
    move -f $file -p $path
  }

  bind file tasklite $path
}

export def doctl [ --force(-f) ] {
  let repository = 'digitalocean/doctl'
  let tag_name = ghub tag_name $repository
  let path = filepath doctl $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f doctl -p $path
  }

  bind file doctl $path
}

export def hcloud [ --force(-f) ] {
  let repository = 'hetznercloud/cli'
  let tag_name = ghub tag_name $repository
  let path = filepath hcloud $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f hcloud -p $path
  }

  bind file hcloud $path
}

export def kubectl [ --force(-f) ] {
  let version = http get https://dl.k8s.io/release/stable.txt
  let path = filepath kubectl $version

  if (path-not-exists $path $force) {
    let file = download https://dl.k8s.io/release/($version)/bin/linux/amd64/kubectl
    add-execute $file
    move -f $file -p $path
  }

  bind file kubectl $path
  bind root kubectl $path
}

export def kubecolor [ --force(-f) ] {
  let repository = 'kubecolor/kubecolor'
  let tag_name = ghub tag_name $repository
  let path = filepath kubecolor $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kubecolor -p $path
  }

  bind file kubecolor $path
}

export def kubetui [ --force(-f) ] {
  let repository = 'sarub0b0/kubetui'
  let tag_name = ghub tag_name $repository
  let path = filepath kubetui $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file kubetui $path
}

export def kube-prompt [ --force(-f) ] {
  let repository = 'c-bata/kube-prompt'
  let tag_name = ghub tag_name $repository
  let path = filepath kube-prompt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kube-prompt -p $path
  }

  bind file kube-prompt $path
}

export def k9s [ --force(-f) ] {
  let repository = 'derailed/k9s'
  let tag_name = ghub tag_name $repository
  let path = filepath k9s $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f k9s -p $path
  }

  bind file k9s $path
}

export def kdash [ --force(-f) ] {
  let repository = 'kdash-rs/kdash'
  let tag_name = ghub tag_name $repository
  let path = filepath kdash $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kdash -p $path
  }

  bind file kdash $path
}

export def bettercap [ --force(-f) ] {
  let repository = 'bettercap/bettercap'
  let tag_name = ghub tag_name $repository
  let path = filepath bettercap $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bettercap -p $path
  }

  bind file bettercap $path
  bind root bettercap $path
}

export def viddy [ --force(-f) ] {
  let repository = 'sachaos/viddy'
  let tag_name = ghub tag_name $repository
  let path = filepath viddy $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f viddy -p $path
  }

  bind file viddy $path
}

export def hwatch [ --force(-f) ] {
  let repository = 'blacknon/hwatch'
  let tag_name = ghub tag_name $repository
  let path = filepath hwatch $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bin/hwatch -p $path
  }

  bind file hwatch $path
}

export def yazi [ --force(-f) ] {
  let repository = 'sxyazi/yazi'
  let tag_name = ghub tag_name $repository
  let path = filepath yazi $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f yazi -p $path
  }

  bind file yazi $path
}

export def kmon [ --force(-f) ] {
  let repository = 'orhun/kmon'
  let tag_name = ghub tag_name $repository
  let path = filepath kmon $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kmon -p $path
  }

  bind file kmon $path
}

export def --env ollama [ --force(-f) ] {
  let repository = 'ollama/ollama'
  let tag_name = ghub tag_name $repository
  let path = dirpath ollama $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.OLLAMA_PATH
  env-path $env.OLLAMA_BIN
}

export def plandex [ --force(-f) ] {
  let repository = 'plandex-ai/plandex'
  let tag_name = ghub tag_name $repository
  let path = filepath plandex $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f plandex -p $path
  }

  bind file plandex $path
}

export def local-ai [ --force(-f) ] {
  let repository = 'mudler/LocalAI'
  let tag_name = ghub tag_name $repository
  let path = filepath local-ai $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file local-ai $path
}

export def lan-mouse [ --desktop(-d), --service(-s), --force(-f) ] {
  let repository = 'feschber/lan-mouse'
  let tag_name = ghub tag_name $repository
  let path = filepath lan-mouse $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
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

export def lapce [ --force(-f) ] {
  let repository = 'lapce/lapce'
  let tag_name = ghub tag_name $repository
  let path = filepath lapce $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f lapce -p $path
  }

  bind file lapce $path
}

export def --env vscodium [ --force(-f) ] {
  let repository = 'VSCodium/vscodium'
  let tag_name = ghub tag_name $repository
  let path = dirpath vscodium $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.VSCODIUM_PATH
  env-path $env.VSCODIUM_BIN
}

export def --env code-server [ --force(-f) ] {
  let repository = 'coder/code-server'
  let tag_name = ghub tag_name $repository
  let path = dirpath code-server $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.CODE_SERVER_PATH
  env-path $env.CODE_SERVER_BIN
}

export def termshark [ --force(-f) ] {
  let repository = 'gcla/termshark'
  let tag_name = ghub tag_name $repository
  let path = filepath termshark $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f termshark -p $path
  }

  bind file termshark $path
}

export def termscp [ --force(-f) ] {
  let repository = 'veeso/termscp'
  let tag_name = ghub tag_name $repository
  let path = filepath termscp $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f termscp -p $path
  }

  bind file termscp $path
}

export def kbt [ --force(-f) ] {
  let repository = 'bloznelis/kbt'
  let tag_name = ghub tag_name $repository
  let path = filepath kbt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kbt -p $path
  }

  bind file kbt $path
}

export def trippy [ --force(-f) ] {
  let repository = 'fujiapple852/trippy'
  let tag_name = ghub tag_name $repository
  let path = filepath trippy $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f trip -p $path
  }

  bind file trippy $path
  bind root trippy $path
}

export def gitui [ --force(-f) ] {
  let repository = 'extrawurst/gitui'
  let tag_name = ghub tag_name $repository
  let path = filepath gitui $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f gitui -p $path
  }

  bind file gitui $path
}

export def monolith [ --force(-f) ] {
  let repository = 'Y2Z/monolith'
  let tag_name = ghub tag_name $repository
  let path = filepath monolith $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file monolith $path
}

export def dijo [ --force(-f) ] {
  let repository = 'nerdypepper/dijo'
  let tag_name = ghub tag_name $repository
  let path = filepath dijo $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file dijo $path
}

export def ventoy [ --force(-f) ] {
  let repository = 'ventoy/Ventoy'
  let tag_name = ghub tag_name $repository
  let path = filepath ventoy $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.VENTOY_PATH
}

export def stash [ --force(-f) ] {
  let repository = 'stashapp/stash'
  let tag_name = ghub tag_name $repository
  let path = filepath stash $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file stash $path
}

export def AdGuardHome [ --force(-f) ] {
  let repository = 'AdguardTeam/AdGuardHome'
  let tag_name = ghub tag_name $repository
  let path = filepath AdGuardHome $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f AdGuardHome -p $path
  }

  bind file AdGuardHome $path
  bind root AdGuardHome $path
}

export def zen [ --force(-f) ] {
  let repository = 'anfragment/zen'
  let tag_name = ghub tag_name $repository
  let path = filepath zen $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f Zen -p $path
  }

  bind file Zen $path
  bind root Zen $path
}

export def superhtml [ --force(-f) ] {
  let repository = 'kristoff-it/superhtml'
  let tag_name = ghub tag_name $repository
  let path = filepath superhtml $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f superhtml -p $path
  }

  bind file superhtml $path
}

export def --env mitmproxy [ --force(-f) ] {
  let repository = 'mitmproxy/mitmproxy'
  let tag_name = ghub tag_name $repository
  let path = dirpath mitmproxy $tag_name

  if (path-not-exists $path $force) {
    let version = ($tag_name | ghub to-version)
    let download_url = $'https://downloads.mitmproxy.org/($version)/mitmproxy-($version)-linux-x86_64.tar.gz'
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.MITMPROXY_BIN
  env-path $env.MITMPROXY_BIN
}

export def proxyfor [ --force(-f) ] {
  let repository = 'sigoden/proxyfor'
  let tag_name = ghub tag_name $repository
  let path = filepath proxyfor $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f proxyfor -p $path
  }

  bind file proxyfor $path
}

export def hetty [ --force(-f) ] {
  let repository = 'dstotijn/hetty'
  let tag_name = ghub tag_name $repository
  let path = filepath hetty $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f hetty -p $path
  }

  bind file hetty $path
}

export def fclones [ --force(-f) ] {
  let repository = 'pkolaczk/fclones'
  let tag_name = ghub tag_name $repository
  let path = filepath fclones $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f x86_64-unknown-linux-musl/release/fclones -p $path
    rm -rf target
  }

  bind file fclones $path
}

export def nano-work-server [ --force(-f) ] {
  let repository = 'nanocurrency/nano-work-server'
  let tag_name = ghub tag_name $repository
  let path = filepath nano-work-server $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file nano-work-server $path
}

export def mkcert [ --force(-f) ] {
  deps mkcert

  let repository = 'FiloSottile/mkcert'
  let tag_name = ghub tag_name $repository
  let path = filepath mkcert $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file mkcert $path
}

export def devtunnel [ --force(-f) ] {
  let path = filepath devtunnel latest

  if (path-not-exists $path $force) {
    let file = download https://aka.ms/TunnelsCliDownload/linux-x64
    add-execute $file
    move -f $file -p $path
  }

  bind file devtunnel $path
}

export def cloudflared [ --force(-f) ] {
  let repository = 'cloudflare/cloudflared'
  let tag_name = ghub tag_name $repository
  let path = filepath cloudflared $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file cloudflared $path
}

export def pinggy [ --force(-f) ] {
  let path = filepath pinggy latest

  if (path-not-exists $path $force) {
    let file = download https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/v0.1.0-beta.1/linux/amd64/pinggy
    add-execute $file
    move -f $file -p $path
  }

  bind file pinggy $path
}

export def speedtest [ --force(-f) ] {
  let version = '1.2.0'
  let path = filepath speedtest $version

  if (path-not-exists $path $force) {
    let file = download $'https://install.speedtest.net/app/cli/ookla-speedtest-($version)-linux-x86_64.tgz'
    let dir = decompress $file
    move -d $dir -f speedtest -p $path
  }

  bind file speedtest $path
}

export def librespeed [ --force(-f) ] {
  let repository = 'librespeed/speedtest-cli'
  let tag_name = ghub tag_name $repository
  let path = filepath librespeed $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f librespeed-cli -p $path
  }

  bind file librespeed $path
}

export def devbox [ --force(-f) ] {
  let repository = 'jetify-com/devbox'
  let tag_name = ghub tag_name $repository
  let path = filepath devbox $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f devbox -p $path
  }

  bind file devbox $path
}

export def remote-mouse [ --force(-f) ] {
  let version = 'latest'
  let path = filepath remotemouse $version

  if (path-not-exists $path $force) {
    let file = download 'https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.REMOTE_MOUSE_PATH
  env-path $env.REMOTE_MOUSE_PATH
}

export def --env docker [ --group(-g), --force(-f) ] {
  let version = '27.5.1'
  let path = dirpath docker $version

  if (path-not-exists $path $force) {
    let file = download $'https://download.docker.com/linux/static/stable/x86_64/docker-($version).tgz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  if not (exists-group docker) {
    sudo groupadd docker
    sudo usermod -aG docker $env.USER
  }

  bind dir $path $env.DOCKER_BIN
  env-path $env.DOCKER_BIN
}

export def bun [ --force(-f) ] {
  let repository = 'oven-sh/bun'
  let tag_name = ghub tag_name $repository
  let path = filepath bun $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bun -p $path
  }

  bind file bun $path
}

export def --env fvm [ --force(-f) ] {
  let repository = 'leoafarias/fvm'
  let tag_name = ghub tag_name $repository
  let path = dirpath fvm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.FVM_PATH
  env-path $env.FVM_PATH
}

export def --env volta [ --node, --force(-f) ] {
  let repository = 'volta-cli/volta'
  let tag_name = ghub tag_name $repository
  let path = dirpath volta-cli $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.VOLTA_PATH
  env-path $env.VOLTA_PATH

  if $node {
    ^volta install node@latest
  }
}

export def pnpm [ --force(-f) ] {
  let repository = 'pnpm/pnpm'
  let tag_name = ghub tag_name $repository
  let path = filepath pnpm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file pnpm $path
}

def node-versions [ --force(-f) ] {
  [
    (http get https://nodejs.org/download/release/index.json | get version | first | str trim -c 'v')
    '21.2.0' '20.9.0' '18.18.2'
  ]
}

export def --env node [ --latest(-l), --force(-f) ] {
  let versions = node-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = dirpath node $version
  if (path-not-exists $path $force) {
    let file = download $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.NODE_PATH
  env-path $env.NODE_BIN
}

def go-versions [ --force(-f) ] {
  [
    ...(http get https://go.dev/dl/?mode=json | get version)
  ]
}

export def --env golang [ --latest(-l), --force(-f) ] {
  let versions = go-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = dirpath go $version
  if (path-not-exists $path $force) {
    let file = download $'https://go.dev/dl/($version).linux-amd64.tar.gz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.GOROOT
  env-path $env.GOBIN
}

export def --env vlang [ --force(-f) ] {
  let version = 'latest'
  let path = dirpath vlang $version

  if (path-not-exists $path $force) {
    let file = $'https://github.com/vlang/v/releases/($version)/download/v_linux.zip'
    let dir = decompress $file
    move -d $dir -p $path
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

export def --env java [ version: string@java-version = '21', --force(-f) ] {
  let path = dirpath java $version
  let url = (java-list | get $version)

  if (path-not-exists $path $force) {
    http download $url
    extract tar $'openjdk-($version)_linux-x64_bin.tar.gz'
    move -d $'jdk-($version)' -p $path
  }

  bind dir $path $env.JAVA_PATH
  env-path $env.JAVA_BIN
}

export def --env jdtls [ --force(-f) ] {
  let path = dirpath jdtls 'latest'

  if (path-not-exists $path $force) {
    let file = download https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz jdt-language-server-latest.tar.gz
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.JDTLS_PATH
  env-path $env.JDTLS_BIN
}

export def --env kotlin [ --force(-f) ] {
  let repository = 'JetBrains/kotlin'
  let tag_name = ghub tag_name $repository
  let path = dirpath kotlin $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.KOTLIN_PATH
  env-path $env.KOTLIN_BIN
}

export def --env kotlin-native [ --force(-f) ] {
  let repository = 'JetBrains/kotlin'
  let tag_name = ghub tag_name $repository
  let path = dirpath kotlin-native $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.KOTLIN_NATIVE_PATH
  env-path $env.KOTLIN_NATIVE_BIN
}

export def --env kotlin-language-server [ --force(-f) ] {
  let repository = 'fwcd/kotlin-language-server'
  let tag_name = ghub tag_name $repository
  let path = dirpath kotlin-language-server $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.KOTLIN_LSP_PATH
  env-path $env.KOTLIN_LSP_BIN
}

export def --env lua-language-server [ --force(-f) ] {
  let repository = 'LuaLS/lua-language-server'
  let tag_name = ghub tag_name $repository
  let path = dirpath lua-language-server $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.LUA_LSP_PATH
  env-path $env.LUA_LSP_BIN
}

def dart_latest [ --force(-f) ] {
  http get https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | decode | from json | get version
}

export def --env dart [ --force(-f) ] {
  let version = (dart_latest)
  let path = dirpath dart $version

  if (path-not-exists $path $force) {
    let file = download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.DART_PATH
  env-path $env.DART_BIN
}

def flutter_latest [ --force(-f) ] {
  http get https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | get releases | where channel == stable | get version | first
}

export def --env flutter [ --latest(-l), --force(-f) ] {
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

  let path = dirpath flutter $version
  if (path-not-exists $path $force) {
    let file = download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.FLUTTER_PATH
  env-path $env.FLUTTER_BIN
}

export def --env android-studio [ --desktop(-d), --force(-f) ] {
  let version = '2024.2.1.9'
  let path = dirpath android-studio $version

  if (path-not-exists $path $force) {
    let file = download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.ANDORID_STUDIO_PATH
  env-path $env.ANDROID_STUDIO_BIN

  if $desktop {
    let src = ($env.NU_BASE_FILES | path join applications android-studio.desktop)
    cp $src $env.LOCAL_SHARE_APPLICATIONS
  }
}

export def --env android-cmdline-tools [ --force(-f) ] {
  if (path-not-exists $env.ANDROID_CMDLINE_TOOLS $force) {
    let file = download https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    let dir = decompress $file
    mkdir ($env.ANDROID_CMDLINE_TOOLS | path dirname)
    move -d $dir -p $env.ANDROID_CMDLINE_TOOLS
  }
  env-path $env.ANDROID_CMDLINE_TOOLS_BIN
}

export def --env android-platform-tools [ --force(-f) ] {
  if (path-not-exists $env.ANDROID_PLATFORM_TOOLS $force) {
    let file = download https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    let dir = decompress $file
    move -d $dir -p $env.ANDROID_PLATFORM_TOOLS
  }
  env-path $env.ANDROID_PLATFORM_TOOLS
}

export def --env btcd [ --force(-f) ] {
  let repository = 'btcsuite/btcd'
  let tag_name = ghub tag_name $repository
  let path = dirpath btcd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.BTCD_PATH
  env-path $env.BTCD_PATH
}

export def --env bitcoin [ --force(-f) ] {
  let repository = 'bitcoin/bitcoin'
  let tag_name = ghub tag_name $repository
  let path = dirpath bitcoin $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.BITCOIN_PATH
  env-path $env.BITCOIN_BIN
}

export def --env lightning-network [ --force(-f) ] {
  let repository = 'lightningnetwork/lnd'
  let tag_name = ghub tag_name $repository
  let path = dirpath lightning $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.LIGHTNING_PATH
  env-path $env.LIGHTNING_PATH
}

export def --env scilab [ --force(-f) ] {
  let version = '2024.1.0'
  let path = dirpath scilab $version

  if (path-not-exists $path $force) {
    let file = download $'https://www.scilab.org/download/($version)/scilab-($version).bin.x86_64-linux-gnu.tar.xz'
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.SCILAB_PATH
  env-path $env.SCILAB_BIN
}

export def clangd [ --force(-f) ] {
  let repository = 'clangd/clangd'
  let tag_name = ghub tag_name $repository
  let path = filepath clangd $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bin/clangd -p $path
  }

  bind file clangd $path
  bind root clangd $path
}

export def marksman [ --force(-f) ] {
  let repository = 'artempyanykh/marksman'
  let tag_name = ghub tag_name $repository
  let path = filepath marksman $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file marksman $path
}

export def v-analyzer [ --force(-f) ] {
  let repository = 'vlang/v-analyzer'
  let tag_name = ghub tag_name $repository
  let path = filepath v-analyzer $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f v-analyzer -p $path
  }

  bind file v-analyzer $path
}

export def zls [ --force(-f) ] {
  let repository = 'zigtools/zls'
  let tag_name = ghub tag_name $repository
  let path = filepath zls $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f zls -p $path
  }

  bind file zls $path
}

export def presenterm [ --force(-f) ] {
  let repository = 'mfontanini/presenterm'
  let tag_name = ghub tag_name $repository
  let path = filepath presenterm $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f presenterm -p $path
  }

  bind file presenterm $path
}

export def contour [ --force(-f) ] {
  let repository = 'contour-terminal/contour'
  let tag_name = ghub tag_name $repository
  let path = filepath contour $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f contour -p $path
  }

  bind file contour $path
}

export def viu [ --force(-f) ] {
  let repository = 'atanunq/viu'
  let tag_name = ghub tag_name $repository
  let path = filepath viu $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file viu $path
}

export def immich-go [ --force(-f) ] {
  let repository = 'simulot/immich-go'
  let tag_name = ghub tag_name $repository
  let path = filepath immich-go $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f immich-go -p $path
  }

  bind file immich-go $path
}

export def picocrypt [ --force(-f) ] {
  let repository = 'Picocrypt/CLI'
  let tag_name = ghub tag_name $repository
  let path = filepath picocrypt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file picocrypt $path
}

export def --env ringboard [ --force(-f) ] {
  let repository = 'SUPERCILEX/clipboard-history'
  let version = ghub version $repository
  let path = dirpath ringboard $version

  mkdir linux-musl-ringboard

  if (path-not-exists $path $force) {
    http download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard' -o linux-musl-ringboard/ringboard
    add-execute $file

    http download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-egui' -o linux-musl-ringboard/ringboard-egui
    add-execute $file

    http download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-server' -o linux-musl-ringboard/ringboard-server
    add-execute $file

    http download $'https://github.com/SUPERCILEX/clipboard-history/releases/download/($version)/x86_64-unknown-linux-musl-ringboard-tui' -o linux-musl-ringboard/ringboard-tui
    add-execute $file
  }

  move -d linux-musl-ringboard -p $path

  bind dir $path $env.RINGBOARD_BIN
  env-path $env.RINGBOARD_BIN
}

export def clipboard [ --force(-f) ] {
  let repository = 'Slackadays/Clipboard'
  let tag_name = ghub tag_name $repository
  let path = filepath cb $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f bin/cb -p $path
  }

  bind file cb $path
}

export def vi-mongo [ --force(-f) ] {
  let repository = 'kopecmaciej/vi-mongo'
  let tag_name = ghub tag_name $repository
  let path = filepath vi-mongo $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f vi-mongo -p $path
  }

  bind file vi-mongo $path
}

export def cloak [ --force(-f) ] {
  let repository = 'evansmurithi/cloak'
  let tag_name = ghub tag_name $repository
  let path = filepath cloak $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f cloak -p $path
  }

  bind file cloak $path
}

export def totp [ --force(-f) ] {
  let repository = 'Zebradil/rustotpony'
  let tag_name = ghub tag_name $repository
  let path = filepath totp $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file totp $path
}

export def totp-cli [ --force(-f) ] {
  let repository = 'yitsushi/totp-cli'
  let tag_name = ghub tag_name $repository
  let path = filepath totp-cli $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f totp-cli -p $path
  }

  bind file totp-cli $path
}

export def jnv [ --force(-f) ] {
  let repository = 'ynqa/jnv'
  let tag_name = ghub tag_name $repository
  let path = filepath jnv $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f jnv -p $path
  }

  bind file jnv $path
}

export def devspace [ --force(-f) ] {
  let repository = 'devspace-sh/devspace'
  let tag_name = ghub tag_name $repository
  let path = filepath devspace $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file devspace $path
}

export def atto [ --force(-f) ] {
  let repository = 'codesoap/atto'
  let tag_name = ghub tag_name $repository
  let path = filepath atto $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f atto -p $path
  }

  bind file atto $path
}

export def wsget [ --force(-f) ] {
  let repository = 'ksysoev/wsget'
  let tag_name = ghub tag_name $repository
  let path = filepath wsget $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f wsget -p $path
  }

  bind file wsget $path
}

export def koji [ --force(-f) ] {
  let repository = 'cococonscious/koji'
  let tag_name = ghub tag_name $repository
  let path = filepath koji $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f koji -p $path
  }

  bind file koji $path
}

export def smartcat [ --force(-f) ] {
  let repository = 'efugier/smartcat'
  let tag_name = ghub tag_name $repository
  let path = filepath sc $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f sc -p $path
  }

  bind file sc $path
}

export def jwt [ --force(-f) ] {
  let repository = 'mike-engel/jwt-cli'
  let tag_name = ghub tag_name $repository
  let path = filepath jwt $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f jwt -p $path
  }

  bind file jwt $path
}

export def procs [ --force(-f) ] {
  let repository = 'dalance/procs'
  let tag_name = ghub tag_name $repository
  let path = filepath procs $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f procs -p $path
  }

  bind file procs $path
}

export def oha [ --force(-f) ] {
  let repository = 'hatoo/oha'
  let tag_name = ghub tag_name $repository
  let path = filepath oha $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file oha $path
}

export def adguardian [ --force(-f) ] {
  let repository = 'Lissy93/AdGuardian-Term'
  let tag_name = ghub tag_name $repository
  let path = filepath adguardian $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    add-execute $file
    move -f $file -p $path
  }

  bind file adguardian $path
}

export def --env gix [ --force(-f) ] {
  let repository = 'GitoxideLabs/gitoxide'
  let tag_name = ghub tag_name $repository
  let path = filepath gix $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.GITOXIDE_BIN
  env-path $env.GITOXIDE_BIN
}

export def kubewall [ --force(-f) ] {
  let repository = 'kubewall/kubewall'
  let tag_name = ghub tag_name $repository
  let path = filepath kubewall $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f kubewall -p $path
  }

  bind file kubewall $path
}

export def f2 [ --force(-f) ] {
  let repository = 'ayoisaiah/f2'
  let tag_name = ghub tag_name $repository
  let path = filepath f2 $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f f2 -p $path
  }

  bind file f2 $path
}

export def doggo [ --force(-f) ] {
  let repository = 'mr-karan/doggo'
  let tag_name = ghub tag_name $repository
  let path = filepath doggo $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -f doggo -p $path
  }

  bind file doggo $path
}

export def --env scrcpy [ --force(-f) ] {
  let repository = 'Genymobile/scrcpy'
  let tag_name = ghub tag_name $repository
  let path = dirpath scrcpy $tag_name

  if (path-not-exists $path $force) {
    let asset = ghub asset $repository $tag_name
    let download_url = ghub download_url $repository $tag_name $asset
    let file = download $download_url
    let dir = decompress $file
    move -d $dir -p $path
  }

  bind dir $path $env.SCRCPY_BIN
  env-path $env.SCRCPY_BIN
}

export def firefox-de [ --force(-f) ] {
  http download https://download-installer.cdn.mozilla.net/pub/devedition/releases/129.0b6/linux-x86_64/es-ES/firefox-129.0b6.tar.bz2
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

def filepath [name: string, version: string] {
  $env.USR_LOCAL_SHARE_BIN | path join $"($name)_($version)"
}

def dirpath [name: string, version: string] {
  $env.USR_LOCAL_SHARE_LIB | path join $"($name)_($version)"
}

def 'bind dir' [src: string, dst: string] {
  rm -rf $dst
  ln -sf $src $dst
}

def 'bind file' [cmd: string, src: string] {
  let dst = ($env.USR_LOCAL_BIN | path join $cmd)
  rm -rf $dst
  ln -sf $src $dst
}

def 'bind root' [cmd: string, src: string] {
  let dst = ($env.SYS_LOCAL_BIN | path join $cmd)
  sudo rm -rf $dst
  sudo ln -sf $src $dst
}

def move [
  --dir(-d): string = ''
  --file(-f): string = '',
  --path(-p): string,
] {
  if ($path | path exists) { rm -rf $path }
  mv -f ($dir | path join $file) $path
  if ($dir | path exists) { rm -rf $dir }
}

export def core [ --force(-f) ] {
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
  carapace
  eza

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
  melt
  soft

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
