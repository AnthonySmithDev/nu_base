
export-env {
  $env.GHUB_REPOSITORY_PATH = ($env.HOME | path join nu/nu_base/data/config/ghub/ghub.json)
  $env.GHUB_TEMP_PATH = ($env.HOME | path join temp/ghub)
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

export def rate_limit [] {
  let rate = (http get --max-time 10sec https://api.github.com/rate_limit | get rate)
  let reset = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  return ($rate | upsert reset $reset)
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
  let version = ($r.tag_name | to-version)
  let created_at = ($r.created_at | to-created-at)
  print $"(tag-url $r.name $r.tag_name) (white $version) (italic $created_at)"
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

  let dir = if $dirpath != null { $dirpath } else {
    mktemp --directory --tmpdir-path ($env.GHUB_TEMP_PATH | path join dir)
  }

  rm -rfp $dir
  mkdir $dir

  let tar_exts = ['.tar', '.txz', '.tbz', '.tar.xz', '.tgz', '.tar.gz', '.tar.bz2']
  if ($tar_exts | any { |ext| $filepath | str ends-with $ext }) {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract tar...' -- tar -xvf $filepath -C $dir
    } else {
      tar -xvf $filepath -C $dir
    }
  } else if $filepath =~ ".zip" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract zip...' -- unzip $filepath -d $dir
    } else {
      unzip $filepath -d $dir
    }
  } else if $filepath =~ ".gz" {
    let basename = ($filepath | path basename | str replace '.gz' '')
    let filepath = ($dir | path join $basename)
    gunzip -c $filepath | save --force $filepath
    return $filepath
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

export def download [url: string] {
  
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
  let dirpath = $path | default ($env.GHUB_TEMP_PATH | path join file)
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

export def index-get [] {
  let index_path = ($env.HOME | path join .github-index)
  if ($index_path | path exists) {
    return (open $index_path | into int)
  }
  return 0
}

export def index-set [index: int] {
  $index | save --force ($env.HOME | path join .github-index)
}

def tag-url [name: string@names, tag: string] {
  let text = ($"https://github.com/($name)/releases/tag/($tag)" | ansi link --text $name)
  return (light $text)
}

def releases-url [name: string@names] {
  let text = ($"https://github.com/($name)/releases" | ansi link --text $name)
  return (light $text)
}

def light [str: string] {
  return $'(ansi default)($str)(ansi reset)'
}

def white [str: string] {
  return $'(ansi white_bold)($str)(ansi reset)'
}

def italic [str: string] {
  return $'(ansi white_italic)($str)(ansi reset)'
}

def red [str: string] {
  return $'(ansi red_bold)($str)(ansi reset)'
}

def green [str: string] {
  return $'(ansi green_bold)($str)(ansi reset)'
}

def purple [str: string] {
  return $'(ansi purple_bold)($str)(ansi reset)'
}

def cyan [str: string] {
  return $'(ansi cyan_bold)($str)(ansi reset)'
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

export def "repo update" [...names: string@names, --changelog(-c), --loop(-l), --debug(-d)] {
  let changelog_dir = ($env.GHUB_TEMP_PATH | path join changelog)

  let save_changelog = $changelog and ($names | is-empty)
  if $save_changelog {
    mkdir $changelog_dir
  }

  let wait = 1min
  mut remaining = true
  while $remaining {
    let rate_limit = rate_limit
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

  let rate_limit = rate_limit
  let last_index = index-get
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

  mut current_index = 0
  loop {
    if $current_index >= ($repos_to_process | length) {
      break
    }

    let index = ($repos_to_process | get $current_index)
    let old = ($repos | get $index)
    let old_version = ($old.tag_name | to-version)
    let old_created_at = ($old.created_at | to-created-at)

    let num = $index + 1

    if $old.skip? == true {
      print $"($num) (releases-url $old.name) (white $old_version) (italic $old_created_at)"
      $current_index = $current_index + 1
      continue
    }

    let new = if $old.prerelease? == true {
      try {
        releases $old.name | where prerelease == true | first
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
        releases-latest $old.name
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

    let new_version = ($new.tag_name | to-version)
    let new_created_at = ($new.created_at | to-created-at)

    if ($names | is-empty) {
      index-set $index
    }

    if $old.tag_name == $new.tag_name {
      print $"($num) (tag-url $old.name $old.tag_name) (white $old_version) (italic $new_created_at)"
      $current_index = $current_index + 1
      continue
    }
    if ($old.assets? | is-not-empty) {
      if ($new.assets | length) < 1 {
        print $"($num) (tag-url $old.name $new.tag_name) (purple $old_version) (cyan $new_version) (italic $new_created_at)"
        $current_index = $current_index + 1
        continue
      }
    }

    print $"($num) (releases-url $old.name) (red $old_version) (green $new_version) (italic $new_created_at)"

    mut repo = ($old
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
      let changelog_file = ($changelog_dir | path join $"($old.name | path basename).md")
      $new.body | save --force $changelog_file
    }

    $current_index = $current_index + 1
  }

  if (ls $changelog_dir | is-not-empty) {
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
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = index-get
  mut repos = open $env.GHUB_REPOSITORY_PATH
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item

    let new = releases-latest $old.name

    if ($it.index + 1) == $length {
      index-set 0
    } else {
      index-set ($it.index + 1 )
    }

    print $"(tag-url $old.name $new.tag_name)"

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
