
export def update [
  --new(-n)
  --core(-c)
  --extra(-e)
  --other(-o)
  --inactive
] {
  let list = (repos | where $it.active == (not $inactive))
  mut repos = []
  if $new {
    $repos = ($repos | append ($list | where $it.category == new ))
  }
  if $core {
    $repos = ($repos | append ($list | where $it.category == core ))
  }
  if $extra {
    $repos = ($repos  | append ($list | where $it.category == extra ))
  }
  if $other {
    $repos = ($repos  | append ($list | where $it.category == other ))
  }
  for repo in $repos {
    if not $repo.release {
      continue
    }

    try {
      let data = (latest_version $repo.repository $repo.tag_name)
      print_version $data.repository $data.old_tag_name $data.new_tag_name $data.created_at
    } catch {|e|
      print_error $e.msg
      break
    }
  }
}

export def names [] {
  repos | get repository
}

export def name_tag [context: string] {
  let name = ($context | str trim | split row " " | last)
  [ (repos | where repository == $name | first | get tag_name) ]
}

export def get_version [name: string@names] {
  repos | where repository == $name | first | get tag_name
}

export def release_tag [name: string@names, tag: string@name_tag] {
  http get -f -e https://api.github.com/repos/($name)/releases/tags/v($tag)
}

export def release_latest [name: string@names] {
  http get -f -e https://api.github.com/repos/($name)/releases/latest
}

export def release_latest_version [name: string@names] {
  release_latest $name | get body.name | str trim -c v
}

export def tags [name: string@names] {
  http get -f -e https://api.github.com/repos/($name)/tags
}

export def tags_latest [name: string@names] {
  tags $name | get body | first | get name | str trim -c 'v'
}

export def tags_latest_version [name: string@names] {
  tags_latest $name | get name | str trim -c 'v'
}

export def latest_version [repository: string@names, tag_name: string@name_tag] {
  let release = release_latest $repository
  if ($release | get status) == 403 {
    error make {
      msg: "API rate limit exceeded"
    }
  }
  if ($release | get status) == 404 {
    error make {
      msg: "Not found"
    }
  }
  return {
    "repository": ($repository)
    "old_tag_name": ($tag_name)
    "new_tag_name": ($release | get body.tag_name)
    "created_at": ($release | get body.created_at | date humanize)
  }
}

export def latest_tag [repository: string@names] {
  return (release_latest $repository | get tag_name)
}

export def rate_limit [] {
  let rate = (http get https://api.github.com/rate_limit | get rate)
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

export def repos [] {
  [
    {
      "category": "core",
      "repository": "ducaale/xh",
      "tag_name": "0.20.1",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "charmbracelet/gum",
      "tag_name": "0.13.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "charmbracelet/mods",
      "tag_name": "1.1.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "helix-editor/helix",
      "tag_name": "23.10",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "nushell/nushell",
      "tag_name": "0.89.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "starship/starship",
      "tag_name": "1.17.1",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "ajeetdsouza/zoxide",
      "tag_name": "0.9.2",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "zellij-org/zellij",
      "tag_name": "0.39.2",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "alacritty/alacritty",
      "tag_name": "0.13.1",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "BurntSushi/ripgrep",
      "tag_name": "14.1.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "sharkdp/fd",
      "tag_name": "9.0.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "junegunn/fzf",
      "tag_name": "0.45.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "sharkdp/bat",
      "tag_name": "0.24.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "jesseduffield/lazygit",
      "tag_name": "0.40.2",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "jesseduffield/lazydocker",
      "tag_name": "0.23.1",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "PaulJuliusMartinez/jless",
      "tag_name": "0.9.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "smallhadroncollider/taskell",
      "tag_name": "1.11.4",
      "active": false,
      "release": true,
    },
    {
      "category": "core",
      "repository": "dundee/gdu",
      "tag_name": "5.25.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "Nukesor/pueue",
      "tag_name": "3.3.3",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "dandavison/delta",
      "tag_name": "0.16.5",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "sigoden/dufs",
      "tag_name": "0.38.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "claudiodangelis/qrcp",
      "tag_name": "0.11.1",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "ClementTsang/bottom",
      "tag_name": "0.9.6",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "max-niederman/ttyper",
      "tag_name": "1.4.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "Aloxaf/silicon",
      "tag_name": "0.5.2",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "dalance/amber",
      "tag_name": "0.6.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "Canop/broot",
      "tag_name": "1.32.0",
      "active": true,
      "release": true,
    },
    {
      "category": "core",
      "repository": "xo/usql",
      "tag_name": "0.17.5",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "sezanzeb/input-remapper",
      "tag_name": "2.0.1",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "Jelmerro/Vieb",
      "tag_name": "11.0.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "bettercap/bettercap",
      "tag_name": "2.31.1",
      "active": false,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "iawia002/lux",
      "tag_name": "0.22.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "mdp/qrterminal",
      "tag_name": "3.2.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "codesenberg/bombardier",
      "tag_name": "1.2.6",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "svenstaro/genact",
      "tag_name": "1.3.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "rclone/rclone",
      "tag_name": "1.65.1",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "charmbracelet/glow",
      "tag_name": "1.5.1",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "charmbracelet/vhs",
      "tag_name": "0.7.1",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "charmbracelet/soft-serve",
      "tag_name": "0.7.4",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "maaslalani/nap",
      "tag_name": "0.1.1",
      "active": false,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "chmln/sd",
      "tag_name": "1.0.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "ms-jpq/sad",
      "tag_name": "0.4.23",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "yudai/gotty",
      "tag_name": "1.0.1",
      "active": false,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "tsl0922/ttyd",
      "tag_name": "1.7.4",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "elisescu/tty-share",
      "tag_name": "2.4.0",
      "active": false,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "owenthereal/upterm",
      "tag_name": "0.13.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "msoap/shell2http",
      "tag_name": "1.16.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "lsd-rs/lsd",
      "tag_name": "1.0.0",
      "active": true,
      "release": true,
    },
    {
      "category": "extra",
      "repository": "orf/gping",
      "tag_name": "1.16.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "jmorganca/ollama",
      "tag_name": "0.1.19",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "mudler/LocalAI",
      "tag_name": "2.5.1",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "leoafarias/fvm",
      "tag_name": "2.4.1",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "VSCodium/vscodium",
      "tag_name": "1.85.1.23348",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "gcla/termshark",
      "tag_name": "2.4.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "veeso/termscp",
      "tag_name": "0.12.3",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "bloznelis/kbt",
      "tag_name": "2.1.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "fujiapple852/trippy",
      "tag_name": "0.9.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "extrawurst/gitui",
      "tag_name": "0.24.3",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "Y2Z/monolith",
      "tag_name": "2.7.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "nerdypepper/dijo",
      "tag_name": "0.2.7",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "sachaos/viddy",
      "tag_name": "0.4.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "sxyazi/yazi",
      "tag_name": "0.1.5",
      "active": false,
      "release": false,
    },
    {
      "category": "other",
      "repository": "orhun/kmon",
      "tag_name": "1.6.4",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "clangd/clangd",
      "tag_name": "17.0.3",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "pvolok/mprocs",
      "tag_name": "0.6.4",
      "active": false,
      "release": true,
    },
    {
      "category": "other",
      "repository": "Byron/dua-cli",
      "tag_name": "2.26.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "pemistahl/grex",
      "tag_name": "1.4.4",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "denisidoro/navi",
      "tag_name": "2.23.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "timvisee/ffsend",
      "tag_name": "0.2.76",
      "active": false,
      "release": true,
    },
    {
      "category": "other",
      "repository": "muesli/duf",
      "tag_name": "0.8.1",
      "active": false,
      "release": true,
    },
    {
      "category": "other",
      "repository": "swsnr/mdcat",
      "tag_name": "2.1.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "j178/chatgpt",
      "tag_name": "1.3",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "uutils/coreutils",
      "tag_name": "0.0.23",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "rsteube/carapace-bin",
      "tag_name": "0.29.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "antonmedv/walk",
      "tag_name": "1.7.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "mgunyho/tere",
      "tag_name": "1.5.1",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "antonmedv/fx",
      "tag_name": "31.0.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "ouch-org/ouch",
      "tag_name": "0.5.1",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "cli/cli",
      "tag_name": "2.41.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "astral-sh/ruff",
      "tag_name": "0.1.11",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "zyedidia/micro",
      "tag_name": "2.0.13",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "svenstaro/miniserve",
      "tag_name": "0.25.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "o2sh/onefetch",
      "tag_name": "2.19.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "wagoodman/dive",
      "tag_name": "0.11.0",
      "active": true,
      "release": true,
    },
    {
      "category": "other",
      "repository": "sharkdp/hyperfine",
      "tag_name": "1.18.0",
      "active": true,
      "release": true,
    }
    {
      "category": "other",
      "repository": "balena-io/etcher",
      "tag_name": "1.18.11",
      "active": true,
      "release": true,
    },
  ]
}
