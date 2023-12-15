
export def list [
  --new(-n)
  --core(-c)
  --extra(-e)
  --other(-o)
] {
  mut list = []
  if $new {
    $list = ($list | append [
    ])
  }
  if $core {
    $list = ($list | append [
      { name: "ducaale/xh", tag_name: "0.20.1", update: true }
      { name: "charmbracelet/gum", tag_name: "0.13.0", update: true }
      { name: "charmbracelet/mods", tag_name: "1.1.0", update: true }
      { name: "helix-editor/helix", tag_name: "23.10", update: true }
      { name: "nushell/nushell", tag_name: "0.88.1", update: true }
      { name: "starship/starship", tag_name: "1.16.0", update: true }
      { name: "ajeetdsouza/zoxide", tag_name: "0.9.2", update: true }
      { name: "zellij-org/zellij", tag_name: "0.39.2", update: true }
      { name: "BurntSushi/ripgrep", tag_name: "14.0.3", update: true }
      { name: "sharkdp/fd", tag_name: "8.7.1", update: true }
      { name: "junegunn/fzf", tag_name: "0.44.1", update: true }
      { name: "sharkdp/bat", tag_name: "0.24.0", update: true }
      { name: "jesseduffield/lazygit", tag_name: "0.40.2", update: true }
      { name: "jesseduffield/lazydocker", tag_name: "0.23.1", update: true }
      { name: "PaulJuliusMartinez/jless", tag_name: "0.9.0", update: true }
      { name: "dundee/gdu", tag_name: "5.25.0", update: true }
      { name: "Nukesor/pueue", tag_name: "3.3.2", update: true }
      { name: "dandavison/delta", tag_name: "0.16.5", update: true }
      { name: "sigoden/dufs", tag_name: "0.38.0", update: true }
      { name: "claudiodangelis/qrcp", tag_name: "0.11.0", update: true }
      { name: "ClementTsang/bottom", tag_name: "0.9.6", update: true }
      { name: "max-niederman/ttyper", tag_name: "1.4.0", update: true }
      { name: "Aloxaf/silicon", tag_name: "0.5.2", update: true }
      { name: "dalance/amber", tag_name: "0.5.9", update: false }
      { name: "Canop/broot", tag_name: "1.30.0", update: true }
      { name: "xo/usql", tag_name: "0.17.0", update: true }
      { name: "xo/usql", tag_name: "0.17.0", update: true }
      { name: "smallhadroncollider/taskell", tag_name: "1.11.4", update: false }
    ])
  }
  if $extra {
    $list = ($list  | append [
      { name: "bettercap/bettercap", tag_name: "1.31.1", update: false }
      { name: "iawia002/lux", tag_name: "0.22.0", update: true }
      { name: "mdp/qrterminal", tag_name: "3.2.0", update: true }
      { name: "codesenberg/bombardier", tag_name: "1.2.6", update: true }
      { name: "svenstaro/genact", tag_name: "1.3.0", update: true }
      { name: "rclone/rclone", tag_name: "1.65.0", update: true }
      { name: "charmbracelet/glow", tag_name: "1.5.1", update: true }
      { name: "charmbracelet/vhs", tag_name: "0.7.1", update: true }
      { name: "maaslalani/nap", tag_name: "0.1.1", update: false }
      { name: "chmln/sd", tag_name: "1.0.0", update: true }
      { name: "ms-jpq/sad", tag_name: "0.4.23", update: true }
      { name: "yudai/gotty", tag_name: "1.0.1", update: false }
      { name: "tsl0922/ttyd", tag_name: "1.7.4", update: true }
      { name: "elisescu/tty-share", tag_name: "2.4.0", update: false }
      { name: "owenthereal/upterm", tag_name: "0.13.0", update: true }
      { name: "msoap/shell2http", tag_name: "1.16.0", update: true }
      { name: "lsd-rs/lsd", tag_name: "1.0.0", update: true }
      { name: "orf/gping", tag_name: "1.16.0", update: true }
    ])
  }
  if $other {
    $list = ($list  | append [
      { name: "sachaos/viddy", tag_name: "0.4.0", update: true }
      { name: "sxyazi/yazi", tag_name: "0.1.5", update: false }
      { name: "orhun/kmon", tag_name: "1.6.4", update: true }
      { name: "clangd/clangd", tag_name: "17.0.3", update: true }
      { name: "pvolok/mprocs", tag_name: "0.6.4", update: false }
      { name: "Byron/dua-cli", tag_name: "2.23.0", update: true }
      { name: "pemistahl/grex", tag_name: "1.4.4", update: true }
      { name: "denisidoro/navi", tag_name: "2.23.0", update: true }
      { name: "timvisee/ffsend", tag_name: "0.2.76", update: false }
      { name: "muesli/duf", tag_name: "0.8.1", update: false }
      { name: "swsnr/mdcat", tag_name: "2.1.0", update: true }
      { name: "j178/chatgpt", tag_name: "1.3", update: true }
      { name: "uutils/coreutils", tag_name: "0.0.23", update: true }
      { name: "rsteube/carapace-bin", tag_name: "0.28.5", update: true }
      { name: "antonmedv/walk", tag_name: "1.7.0", update: true }
      { name: "mgunyho/tere", tag_name: "1.5.1", update: true }
      { name: "antonmedv/fx", tag_name: "31.0.0", update: true }
      { name: "ouch-org/ouch", tag_name: "0.5.1", update: true }
      { name: "cli/cli", tag_name: "2.40.1", update: true }
      { name: "astral-sh/ruff", tag_name: "0.1.8", update: true }
      { name: "zyedidia/micro", tag_name: "2.0.13", update: true }
      { name: "svenstaro/miniserve", tag_name: "0.24.0", update: true }
      { name: "o2sh/onefetch", tag_name: "2.19.0", update: true }
      { name: "wagoodman/dive", tag_name: "0.11.0", update: true }
      { name: "sharkdp/hyperfine", tag_name: "1.18.0", update: true }
    ])
  }
  ($list)
}

export def update [
  --new(-n)
  --core(-c)
  --extra(-e)
  --other(-o)
] {
  mut repos = []
  if $new {
    $repos = ($repos | append (list --new))
  }
  if $core {
    $repos = ($repos | append (list --core))
  }
  if $extra {
    $repos = ($repos  | append (list --extra))
  }
  if $other {
    $repos = ($repos  | append (list --other))
  }
  for repo in ($repos | where update == true) {
    try {
        latest version $repo.name $repo.tag_name
    } catch {|e|
        print $e.msg
        break
    }
  }
}

def print_version [repo_name: string, repo_tag_name: string, tag_name: string, created_at: string] {
  if ($tag_name | str contains $repo_tag_name) {
     print $'($repo_name): (ansi cyan_bold) ($created_at) (ansi reset) (ansi yellow_bold) ($tag_name) (ansi reset)'
  } else {
    print $'($repo_name): (ansi cyan_bold) ($created_at) (ansi reset) (ansi red_bold) ($repo_tag_name) (ansi reset) (ansi green_bold) ($tag_name) (ansi reset)'
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
  let tag_name = ($release | get body.tag_name)
  let created_at = ($release | get body.created_at | date humanize)
  print_version $repo_name $repo_tag_name $tag_name $created_at
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
