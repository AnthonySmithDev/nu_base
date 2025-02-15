
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_REPOSITORY_INDEX = ($env.HOME | path join .github-index)
}

export def list [] {
  open $env.GITHUB_REPOSITORY
}

export def repos [] {
  open $env.GITHUB_REPOSITORY | reject assets
}

export def names [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: (list | get repository)
  }
}

export def latest [repository: string@names] {
  let release = (http get --full --allow-errors https://api.github.com/repos/($repository)/releases/latest)
  if ($release | get status) == 403 {
    error make -u { msg: "API rate limit exceeded" }
  }
  if ($release | get status) != 200 {
    error make -u { msg: $"($repository): ($release | get body.message)" }
  }
  $release | get body
}

export def find_repo [repository: string@names] {
  return (list | where repository =~ $repository)
}

export def view [repository: string@names] {
  let repos = (list | where repository == $repository)
  if ($repos | is-empty) {
    error make -u { msg: $"Repository does not exist: ($repository)" }
  }
  return ($repos | first)
}

export def to-version [] {
  str trim --char 'v' | str trim --char 'V'
}

def to-created-at [] {
  into datetime --offset -5 | date humanize
}

export def download_url [repository: string@names, tag_name: string, asset: string] {
  $'https://github.com/($repository)/releases/download/($tag_name)/($asset)'
}

def print-repository [r: record] {
  let version = ($r.tag_name | to-version)
  let created_at = ($r.created_at | to-created-at)
  print $"(link $r.repository $r.tag_name) (white $version) (italic $created_at)"
}

export def version [name: string@names] {
  let r = view $name
  print-repository $r
  return ($r.tag_name | to-version)
}

export def tag_name [name: string@names] {
  let r = view $name
  print-repository $r
  return $r.tag_name
}

export def assetx [r: record, first?: string] {
  mut assets = $r.assets
  if $first != null {
    $assets = ($assets | filter { |e| str starts-with $first })
  }
  let system = $env.PKG_BIN_SYS?
  if ($system != null) {
    let starts = ($r | get -i $system | get -i starts)
    if $starts != null {
      $assets = ($assets | filter { |e| str starts-with $starts })
    }
    let ends = ($r | get -i $system | get -i ends)
    if $ends != null {
      $assets = ($assets | filter { |e| str ends-with $ends })
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

export def asset [name: string@names, first?: string] {
  let r = view $name
  assetx $r $first
}

export def "asset download" [repository: string@names, first?: string] {
  let r = view $repository
  let asset = assetx $r $first
  let download_url = download_url $repository $r.tag_name $asset
  let output = ($env.DOWNLOAD_PATH_FILE | path join $asset)
  if not ($output | path exists) {
    http download $download_url --output $output
  }
  return $output
}

export def index-get [] {
  if ($env.GITHUB_REPOSITORY_INDEX | path exists) {
    return (open $env.GITHUB_REPOSITORY_INDEX | into int)
  }
  return 0
}

export def index-set [index: int] {
  $index | save --force $env.GITHUB_REPOSITORY_INDEX
}

export def rate_limit [] {
  let rate = (http get https://api.github.com/rate_limit | get rate)
  let reset = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  return ($rate | upsert reset $reset)
}

const exclusion_words = [.sum .sha1 .sha256 .sha512 .sig .sbom .json .txt .yml .yaml .blockmap]

def exclusion [] {
  filter {|line|
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

export def update [] {
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = index-get
  mut repos = list
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item
    let old_version = ($old.tag_name | to-version)

    let new = latest $old.repository
    let new_version = ($new.tag_name | to-version)
    let new_created_at = ($new.created_at | to-created-at)

    if ($it.index + 1) == $length {
      index-set 0
    } else {
      index-set ($it.index + 1 )
    }

    if $old.tag_name == $new.tag_name {
      print $"(link $old.repository $old.tag_name) (white $old_version) (italic $new_created_at)"
      continue
    }
    if ($old.assets | is-not-empty) {
      if ($new.assets | length) < 1 {
        print $"(link $old.repository $new.tag_name) (purple $old_version) (cyan $new_version) (italic $new_created_at)"
        continue
      }
    }

    print $"(link $old.repository $new.tag_name) (red $old_version) (green $new_version) (italic $new_created_at)"

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    if $new.prerelease {
      $repo = ($repo | upsert prerelease $new.prerelease)
    }

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
  }

  print $"($length) -> ($last_index)..($last_index + $rate_limit.remaining)"
}

def link [repository: string@names, tag: string] {
  let text = ($"https://github.com/($repository)/releases/tag/($tag)" | ansi link --text $repository)
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

export def upgrade [] {
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = index-get
  mut repos = list
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item

    let new = latest $old.repository

    if ($it.index + 1) == $length {
      index-set 0
    } else {
      index-set ($it.index + 1 )
    }

    print $"(link $old.repository $new.tag_name)"

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
    # return
  }

  print $"($length) -> ($last_index)..($last_index + $rate_limit.remaining)"
}

export def update-by-name [...names: string@names] {
  mut repos = list

  for $it in ($repos | enumerate) {
    if ($it.item.repository not-in $names) {
      continue
    }
    let old = $it.item
    let new = latest $it.item.repository

    print $"(link $it.item.repository $new.tag_name)"

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
  }
}
