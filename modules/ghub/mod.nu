
export-env {
  $env.GHUB_REPOSITORY_PATH = ($env.NU_BASE_PATH | path join data/config/ghub/ghub.json)
  $env.GHUB_CACHE_PATH = ($env.HOME | path join .cache/ghub)
}

export def names [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: (open $env.GHUB_REPOSITORY_PATH | get name)
  }
}

export def rate-limit [] {
  let rate = (http get --max-time 10sec https://api.github.com/rate_limit | get rate)
  let reset = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  return ($rate | upsert reset $reset)
}

export def rate-limit-v2 [] {
  curl -s -L https://api.github.com/rate_limit | from json | get rate
}

export def releases [name: string@names] {
  let response = (http get --full --allow-errors https://api.github.com/repos/($name)/releases)
  if ($response | get status) == 403 {
    error make -u { msg: "API rate limit exceeded" }
  }
  if ($response | get status) != 200 {
    error make -u { msg: $"($name): ($response | get body.message)" }
  }
  $response | get body
}

export def releases-latest [name: string@names] {
  let response = (http get --full --allow-errors https://api.github.com/repos/($name)/releases/latest)
  if ($response | get status) == 403 {
    error make -u { msg: "API rate limit exceeded" }
  }
  if ($response | get status) != 200 {
    error make -u { msg: $"($name): ($response | get body.message)" }
  }
  $response | get body
}

export def releases-latest-v2 [name: string@names] {
  curl -s -L https://api.github.com/repos/($name)/releases/latest | from json
}

export def list [] {
  open $env.GHUB_REPOSITORY_PATH | select category name tag_name created_at
}

export def to-version [] {
  str trim --char 'v' | str trim --char 'V'
}

def to-created-at [] {
  into datetime --offset -5 | date humanize
}

export def download_url [name: string@names, tag_name: string, asset: string] {
  $'https://github.com/($name)/releases/download/($tag_name)/($asset)'
}

def print-repository [r: record] {
  print-release 0 $r.name $r.created_at -v $r.tag_name
}

export def version [name: string@names] {
  let r = repo view $name
  print-repository $r
  return ($r.tag_name | to-version)
}

export def tag_name [name: string@names] {
  let r = repo view $name
  print-repository $r
  return $r.tag_name
}

export def assetx [r: record, start?: string] {
  mut assets = $r.assets
  if $start != null {
    $assets = ($assets | where { |e| str starts-with $start })
  }
  let system = $env.PKG_BIN_SYS?
  if ($system != null) {
    let starts = ($r | get -o $system | get -o starts)
    if $starts != null {
      let filter = ($assets | where { |e| str starts-with $starts })
      if ($filter | is-not-empty) { $assets = $filter }
    }
    let ends = ($r | get -o $system | get -o ends)
    if $ends != null {
      let filter = ($assets | where { |e| str ends-with $ends })
      if ($filter | is-not-empty) { $assets = $filter }
    }
  }
  if ($assets | length) == 0 {
    return
  }
  if ($assets | length) > 1 {
    return (gum filter ...$assets)
  }
  return ($assets | first)
  
}

export def "asset apk download_url" [name: string@names, start?: string] {
  $env.PKG_BIN_SYS = "android"

  let r = repo view $name
  let asset = assetx $r $start
  download_url $name $r.tag_name $asset
}

export def asset [name: string@names, start?: string] {
  let r = repo view $name
  assetx $r $start
}

export def decompress [filepath: path, --dirpath(-d): string] {
  if not ($filepath | path exists) {
    error make {msg: $"Path not exists: ($filepath)"}
  }

  rm -rfp $dirpath
  mkdir $dirpath

  let tar_exts = ['.tar', '.txz', '.tbz', '.tar.xz', '.tgz', '.tar.gz', '.tar.bz2']
  if ($tar_exts | any { |ext| $filepath | str ends-with $ext }) {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract tar...' -- tar -xvf $filepath -C $dirpath
    } else {
      tar -xvf $filepath -C $dirpath
    }
  } else if $filepath =~ ".zip" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract zip...' -- unzip $filepath -d $dirpath
    } else {
      unzip $filepath -d $dirpath
    }
  } else if $filepath =~ ".gz" {
    let basename = ($filepath | path basename | str replace '.gz' '')
    let filepath = ($dirpath | path join $basename)
    gunzip -c $filepath | save --force $filepath
    return $filepath
  } else {
    error make {msg: "Unsupported file format"}
  }

  let content = (ls $dirpath | get name)
  let first_item = ($content | first)

  if ($content | length) == 1 and ($first_item | path type) == "dir" {
    let nested_content = (ls $first_item | get name)
    let second_item = ($nested_content | first)

    if ($nested_content | length) == 1 and ($second_item | path type) == "dir" {
      return $second_item
    }
    return $first_item
  }
  return $dirpath
}

export def "asset download" [
  name: string@names
  --start(-s): string
  --end(-e): string
  --path(-p): string
  --extract(-x)
  --force(-f)
] {
  let repo = repo view $name
  let asset = assetx $repo $start
  let download_url = download_url $name $repo.tag_name $asset

  let basename = ($name | path basename)
  let dirpath = $path | default ($env.GHUB_CACHE_PATH)
  let dirname = ($dirpath | path join $basename $repo.tag_name) 
  let download_dir = ($dirname | path join "download")
  mkdir $download_dir

  let filepath = ($download_dir | path join $asset)
  if not ($filepath | path exists) or ($force) {
    http download $download_url --output $filepath
  }

  if $extract {
    let extract_dir = ($dirname | path join "extract")
    return (decompress $filepath --dirpath $extract_dir)
  }

  return $filepath
}

const exclusion_words = [.sum .sha1 .sha256 .sha512 .sig .sbom .json .txt .yml .yaml .blockmap, .whl LICENSE]

def exclusion [] {
  where {|line|
    mut $excluded = false
    for exclusion in $exclusion_words {
      if ($line | str contains $exclusion) {
        $excluded = true
        break
      }
    }
    not $excluded
  }
}

def gen-index [
  max_length: int,
  start: int,
  count: int,
] {
  if $count <= 0 {
    return []
  }
  0..($count - 1) | each {|i|
    ($start + $i) mod ($max_length)
  }
}

def config [key: any, value?: any] {
  let path = ($env.HOME | path join .ghub.json)
  mut config = try { open $path } catch {
    { "index": 0, "date": ""}
  }
  if ($value != null) {
    $config | upsert $key $value | save --force $path
  } else {
    $config | get -o $key
  }
}

def get-index-by-date [] {
  let today = (date now | format date '%Y-%m-%d')
  let last_date = config date
  if ($last_date == $today) {
    return (config index)
  } else {
    config date $today
    return 0
  }
}

def url-release [repository: string, tag?: string, --releases(-r)] {
  mut paths = [$repository]
  if $releases {
    $paths = ($paths | append [releases])
  }
  if $tag != null {
    $paths = ($paths | append [releases tag $tag])
  }
  { scheme: "https" host: "github.com" path: ($paths | path join) } | url join
}

def print-release [
  index: int,
  repository: string
  created_at: string
  --curr-version(-v): string
  --next-version(-n): string
  --prev-version(-p): string
  --soft(-s)
] {
  let repository_link = url-release $repository | ansi link --text $repository

  let index_ansi = $"(ansi default_dimmed)($index)(ansi reset)"
  let repository_ansi = $'(ansi default)($repository_link)(ansi reset)'
  let created_at_ansi = $'(ansi white_italic)($created_at | to-created-at)(ansi reset)'

  mut lines = if $index != 0 {
    [$index_ansi $repository_ansi]
  } else {
    [$repository_ansi]
  }

  let curr_version_ansi = if ($curr_version != null) {
    let link = url-release $repository -r | ansi link --text $curr_version
    $lines = ($lines | append $'(ansi white_bold)($link)(ansi reset)')
  }
  let prev_version_ansi = if ($prev_version != null) {
    let link = url-release $repository $prev_version | ansi link --text $prev_version
    let color = if $soft { "purple_bold" } else { "red_bold" }
    $lines = ($lines | append $'(ansi $color)($link)(ansi reset)')
  }
  let next_version_ansi = if ($next_version != null) {
    let link = url-release $repository $next_version | ansi link --text $next_version
    let color = if $soft { "cyan_bold" } else { "green_bold" }
    $lines = ($lines | append $'(ansi $color)($link)(ansi reset)')
  }

  print ($lines | append $created_at_ansi | str join " ")
}

export def "repo update" [...names: string@names, --changelog(-c), --loop(-l), --debug(-d)] {
  let changelog_dir = ($env.GHUB_CACHE_PATH | path join changelog)

  let save_changelog = $changelog and ($names | is-empty)
  if $save_changelog {
    mkdir $changelog_dir
  }

  let wait = 1min
  mut remaining = true
  while $remaining {
    let rate_limit = rate-limit
    if $loop {
      if $rate_limit.remaining == 0 {
        print $"wait ($wait)"
        sleep $wait
        continue
      } else {
        $remaining = false
      }
    } else {
      if $rate_limit.remaining == 0 {
        return ($rate_limit | select reset remaining)
      } else {
        $remaining = false
      }
    }
  }

  let rate_limit = rate-limit
  let last_index = get-index-by-date
  mut repos = open $env.GHUB_REPOSITORY_PATH
  let length = ($repos | length)
  
  let repos_to_process = if ($names | is-empty) {
    gen-index $length $last_index $rate_limit.remaining
  } else {
    $repos | enumerate | where {|it| $it.item.name in $names} | get index
  }

  if $debug {
    print $rate_limit
    print $repos_to_process
  }

  mut curr_index = 0
  loop {
    if $curr_index >= ($repos_to_process | length) {
      break
    }

    let index = ($repos_to_process | get $curr_index)
    let curr = ($repos | get $index)
    let num = $index + 1

    if $curr.skip? == true {
      print-release $num $curr.name $curr.created_at -v $curr.tag_name
      $curr_index = $curr_index + 1
      continue
    }

    let new = if $curr.prerelease? == true {
      try {
        releases $curr.name | where prerelease == true | first
      } catch {|err|
        print $"(ansi red_bold) error prerelease (ansi reset)"
        if $loop {
          let wait = 3sec
          print $"wait ($wait)"
          sleep $wait
          continue
        } else {
          break
        }
      }
    } else {
      try {
        releases-latest $curr.name
      } catch {|err|
        print $"(ansi red_bold) error release latest (ansi reset)"
        if $loop {
          let wait = 3sec
          print $"wait ($wait)"
          sleep $wait
          continue
        } else {
          break
        }
      }
    }

    if ($names | is-empty) {
      config index ($index + 1)
    }

    if $curr.tag_name == $new.tag_name {
      print-release $num $curr.name $new.created_at -v $curr.tag_name
      $curr_index = $curr_index + 1
      continue
    }
    if ($curr.assets? | is-not-empty) {
      if ($new.assets | length) < 1 {
        print-release $num $curr.name $new.created_at -p $curr.tag_name -n $new.tag_name -s
        $curr_index = $curr_index + 1
        continue
      }
    }

    print-release $num $curr.name $new.created_at -p $curr.tag_name -n $new.tag_name

    mut repo = ($curr
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    if $new.prerelease {
      $repo = ($repo | upsert prerelease $new.prerelease)
    }

    $repos = ($repos | upsert $index $repo)
    $repos | save --force $env.GHUB_REPOSITORY_PATH

    if $save_changelog {
      let changelog_file = ($changelog_dir | path join $"($curr.name | path basename).md")
      $new.body | save --force $changelog_file
    }

    $curr_index = $curr_index + 1
  }

  if $save_changelog and (ls $changelog_dir | is-not-empty) {
    if (confirm "see changelog...?") {
      glow $changelog_dir
      rm -rfp $changelog_dir
    }
  }

  if ($names | is-empty) {
    print $"($length) -> ($last_index)..($last_index + ($repos_to_process | length))"
  }
}

def confirm [prompt: string] {
  try {
    gum confirm $prompt
    return true
  } catch {
    return false
  }
}

export def "repo upgrade" [] {
  let rate_limit = rate-limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = config index
  mut repos = open $env.GHUB_REPOSITORY_PATH
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item

    let new = releases-latest $old.name

    if ($it.index + 1) == $length {
      config index 0
    } else {
      config index ($it.index + 1 )
    }

    print-release 0 $old.name $new.created_at -v $new.tag_name

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GHUB_REPOSITORY_PATH
  }

  print $"($length) -> ($last_index)..($last_index + $rate_limit.remaining)"
}

export def "repo view" [name: string@names] {
  let filter = (open $env.GHUB_REPOSITORY_PATH | where name == $name)
  if ($filter | is-empty) {
    error make -u { msg: $"Repository does not exist: ($name)" }
  }
  return ($filter | first)
}
