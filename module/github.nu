
export def update [
  --new(-n)
  --core(-c)
  --extra(-e)
  --other(-o)
] {
  let all = (get_repos | transpose key value | where $it.value.update == true)
  mut repos = []
  if $new {
    $repos = ($repos | append ( $all | where $it.value.category == new ))
  }
  if $core {
    $repos = ($repos | append ( $all | where $it.value.category == core ))
  }
  if $extra {
    $repos = ($repos  | append ( $all | where $it.value.category == extra ))
  }
  if $other {
    $repos = ($repos  | append ( $all | where $it.value.category == other ))
  }
  for repo in $repos {
    try {
      let data = (latest version $repo.key $repo.value.tag_name)
      print_version $data.repository $data.old_tag_name $data.new_tag_name $data.created_at
    } catch {|e|
      print_error $e.msg
      break
    }
  }
}

export def "latest version" [repo_name: string, repo_tag_name: string] {
  let header = [
    "Accept" "application/vnd.github+json"
    "Authorization" "Bearer <YOUR-TOKEN>"
    "X-GitHub-Api-Version" "2022-11-28"
  ]
  let release = http get -f -e https://api.github.com/repos/($repo_name)/releases/latest
  if ($release | get status) == 403 {
    error make {
      msg: "API rate limit exceeded"
    }
  }
  return {
    "repository": ($repo_name)
    "old_tag_name": ($repo_tag_name)
    "new_tag_name": ($release | get body.tag_name)
    "created_at": ($release | get body.created_at | date humanize)
  }
}

export def "latest tag" [owner: string, repo: string] {
  let name = [$owner $repo] | path join
  let url = $"https://api.github.com/repos/($name)/releases/latest"
  return (http get $url | get tag_name)
}

export def "latest url" [owner: string, repo: string, term: string] {
  let name = [$owner $repo] | path join
  let url = $'https://api.github.com/repos/($name)/releases/latest'
  return (http get $url | get assets | get browser_download_url | find $term | first)
}

export def "rate limit" [] {
  let rate = http get https://api.github.com/rate_limit | get rate
  let date = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  $rate | insert date $date
}

def print_version [name: string, old_tag_name: string, new_tag_name: string, created_at: string] {
  if ($new_tag_name | str contains $old_tag_name) {
     print $'($name): (ansi cyan_bold) ($created_at) (ansi reset) (ansi yellow_bold) ($new_tag_name) (ansi reset)'
  } else {
    print $'($name): (ansi cyan_bold) ($created_at) (ansi reset) (ansi red_bold) ($old_tag_name) (ansi reset) (ansi green_bold) ($new_tag_name) (ansi reset)'
  }
}

def print_error [error: string] {
  print $'(ansi red_bold) ($error) (ansi reset)'
}

export def get_version [repo: string] {
  get_repos | get $repo | get tag_name
}

export def get_repos [] {
  {
    "ducaale/xh": {
      "category": "core",
      "tag_name": "0.20.1",
      "update": true
    },
    "charmbracelet/gum": {
      "category": "core",
      "tag_name": "0.13.0",
      "update": true
    },
    "charmbracelet/mods": {
      "category": "core",
      "tag_name": "1.1.0",
      "update": true
    },
    "helix-editor/helix": {
      "category": "core",
      "tag_name": "23.10",
      "update": true
    },
    "nushell/nushell": {
      "category": "core",
      "tag_name": "0.88.1",
      "update": true
    },
    "starship/starship": {
      "category": "core",
      "tag_name": "1.17.0",
      "update": true
    },
    "ajeetdsouza/zoxide": {
      "category": "core",
      "tag_name": "0.9.2",
      "update": true
    },
    "zellij-org/zellij": {
      "category": "core",
      "tag_name": "0.39.2",
      "update": true
    },
    "BurntSushi/ripgrep": {
      "category": "core",
      "tag_name": "14.0.3",
      "update": true
    },
    "sharkdp/fd": {
      "category": "core",
      "tag_name": "9.0.0",
      "update": true
    },
    "junegunn/fzf": {
      "category": "core",
      "tag_name": "0.44.1",
      "update": true
    },
    "sharkdp/bat": {
      "category": "core",
      "tag_name": "0.24.0",
      "update": true
    },
    "jesseduffield/lazygit": {
      "category": "core",
      "tag_name": "0.40.2",
      "update": true
    },
    "jesseduffield/lazydocker": {
      "category": "core",
      "tag_name": "0.23.1",
      "update": true
    },
    "PaulJuliusMartinez/jless": {
      "category": "core",
      "tag_name": "0.9.0",
      "update": true
    },
    "smallhadroncollider/taskell": {
      "category": "core",
      "tag_name": "1.11.4",
      "update": false
    },
    "dundee/gdu": {
      "category": "core",
      "tag_name": "5.25.0",
      "update": true
    },
    "Nukesor/pueue": {
      "category": "core",
      "tag_name": "3.3.2",
      "update": true
    },
    "dandavison/delta": {
      "category": "core",
      "tag_name": "0.16.5",
      "update": true
    },
    "sigoden/dufs": {
      "category": "core",
      "tag_name": "0.38.0",
      "update": true
    },
    "claudiodangelis/qrcp": {
      "category": "core",
      "tag_name": "0.11.1",
      "update": true
    },
    "ClementTsang/bottom": {
      "category": "core",
      "tag_name": "0.9.6",
      "update": true
    },
    "max-niederman/ttyper": {
      "category": "core",
      "tag_name": "1.4.0",
      "update": true
    },
    "Aloxaf/silicon": {
      "category": "core",
      "tag_name": "0.5.2",
      "update": true
    },
    "dalance/amber": {
      "category": "core",
      "tag_name": "0.5.9",
      "update": false
    },
    "Canop/broot": {
      "category": "core",
      "tag_name": "1.30.2",
      "update": true
    },
    "xo/usql": {
      "category": "core",
      "tag_name": "0.17.2",
      "update": true
    },
    "bettercap/bettercap": {
      "category": "extra",
      "tag_name": "2.31.1",
      "update": false
    },
    "iawia002/lux": {
      "category": "extra",
      "tag_name": "0.22.0",
      "update": true
    },
    "mdp/qrterminal": {
      "category": "extra",
      "tag_name": "3.2.0",
      "update": true
    },
    "codesenberg/bombardier": {
      "category": "extra",
      "tag_name": "1.2.6",
      "update": true
    },
    "svenstaro/genact": {
      "category": "extra",
      "tag_name": "1.3.0",
      "update": true
    },
    "rclone/rclone": {
      "category": "extra",
      "tag_name": "1.65.0",
      "update": true
    },
    "charmbracelet/glow": {
      "category": "extra",
      "tag_name": "1.5.1",
      "update": true
    },
    "charmbracelet/vhs": {
      "category": "extra",
      "tag_name": "0.7.1",
      "update": true
    },
    "charmbracelet/soft-serve": {
      "category": "extra",
      "tag_name": "0.7.4",
      "update": true
    },
    "maaslalani/nap": {
      "category": "extra",
      "tag_name": "0.1.1",
      "update": false
    },
    "chmln/sd": {
      "category": "extra",
      "tag_name": "1.0.0",
      "update": true
    },
    "ms-jpq/sad": {
      "category": "extra",
      "tag_name": "0.4.23",
      "update": true
    },
    "yudai/gotty": {
      "category": "extra",
      "tag_name": "1.0.1",
      "update": false
    },
    "tsl0922/ttyd": {
      "category": "extra",
      "tag_name": "1.7.4",
      "update": true
    },
    "elisescu/tty-share": {
      "category": "extra",
      "tag_name": "2.4.0",
      "update": false
    },
    "owenthereal/upterm": {
      "category": "extra",
      "tag_name": "0.13.0",
      "update": true
    },
    "msoap/shell2http": {
      "category": "extra",
      "tag_name": "1.16.0",
      "update": true
    },
    "lsd-rs/lsd": {
      "category": "extra",
      "tag_name": "1.0.0",
      "update": true
    },
    "orf/gping": {
      "category": "extra",
      "tag_name": "1.16.0",
      "update": true
    },
    "jmorganca/ollama": {
      "category": "other",
      "tag_name": "0.1.17",
      "update": true
    },
    "mudler/LocalAI": {
      "category": "other",
      "tag_name": "2.2.0",
      "update": true
    },
    "leoafarias/fvm": {
      "category": "other",
      "tag_name": "3.0.0-beta.5",
      "update": true
    },
    "VSCodium/vscodium": {
      "category": "other",
      "tag_name": "1.85.1.23348",
      "update": true
    },
    "gcla/termshark": {
      "category": "other",
      "tag_name": "2.4.0",
      "update": true
    },
    "veeso/termscp": {
      "category": "other",
      "tag_name": "0.12.3",
      "update": true
    },
    "bloznelis/kbt": {
      "category": "other",
      "tag_name": "2.0.6",
      "update": true
    },
    "fujiapple852/trippy": {
      "category": "other",
      "tag_name": "0.9.0",
      "update": true
    },
    "extrawurst/gitui": {
      "category": "other",
      "tag_name": "0.24.3",
      "update": true
    },
    "Y2Z/monolith": {
      "category": "other",
      "tag_name": "2.7.0",
      "update": true
    },
    "nerdypepper/dijo": {
      "category": "other",
      "tag_name": "0.2.7",
      "update": true
    },
    "sachaos/viddy": {
      "category": "other",
      "tag_name": "0.4.0",
      "update": true
    },
    "sxyazi/yazi": {
      "category": "other",
      "tag_name": "0.1.5",
      "update": false
    },
    "orhun/kmon": {
      "category": "other",
      "tag_name": "1.6.4",
      "update": true
    },
    "clangd/clangd": {
      "category": "other",
      "tag_name": "17.0.3",
      "update": true
    },
    "pvolok/mprocs": {
      "category": "other",
      "tag_name": "0.6.4",
      "update": false
    },
    "Byron/dua-cli": {
      "category": "other",
      "tag_name": "2.24.2",
      "update": true
    },
    "pemistahl/grex": {
      "category": "other",
      "tag_name": "1.4.4",
      "update": true
    },
    "denisidoro/navi": {
      "category": "other",
      "tag_name": "2.23.0",
      "update": true
    },
    "timvisee/ffsend": {
      "category": "other",
      "tag_name": "0.2.76",
      "update": false
    },
    "muesli/duf": {
      "category": "other",
      "tag_name": "0.8.1",
      "update": false
    },
    "swsnr/mdcat": {
      "category": "other",
      "tag_name": "2.1.0",
      "update": true
    },
    "j178/chatgpt": {
      "category": "other",
      "tag_name": "1.3",
      "update": true
    },
    "uutils/coreutils": {
      "category": "other",
      "tag_name": "0.0.23",
      "update": true
    },
    "rsteube/carapace-bin": {
      "category": "other",
      "tag_name": "0.28.5",
      "update": true
    },
    "antonmedv/walk": {
      "category": "other",
      "tag_name": "1.7.0",
      "update": true
    },
    "mgunyho/tere": {
      "category": "other",
      "tag_name": "1.5.1",
      "update": true
    },
    "antonmedv/fx": {
      "category": "other",
      "tag_name": "31.0.0",
      "update": true
    },
    "ouch-org/ouch": {
      "category": "other",
      "tag_name": "0.5.1",
      "update": true
    },
    "cli/cli": {
      "category": "other",
      "tag_name": "2.40.1",
      "update": true
    },
    "astral-sh/ruff": {
      "category": "other",
      "tag_name": "0.1.9",
      "update": true
    },
    "zyedidia/micro": {
      "category": "other",
      "tag_name": "2.0.13",
      "update": true
    },
    "svenstaro/miniserve": {
      "category": "other",
      "tag_name": "0.24.0",
      "update": true
    },
    "o2sh/onefetch": {
      "category": "other",
      "tag_name": "2.19.0",
      "update": true
    },
    "wagoodman/dive": {
      "category": "other",
      "tag_name": "0.11.0",
      "update": true
    },
    "sharkdp/hyperfine": {
      "category": "other",
      "tag_name": "1.18.0",
      "update": true
    }
  }
}
