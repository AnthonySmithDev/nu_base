
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_REPOSITORY_INDEX = ($env.HOME | path join .github-index)
}

export def names [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: (open $env.GITHUB_REPOSITORY | get name)
  }
}

export def rate_limit [] {
  let rate = (http get https://api.github.com/rate_limit | get rate)
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
  open $env.GITHUB_REPOSITORY | select category name tag_name created_at
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
  print $"(link $r.name $r.tag_name) (white $version) (italic $created_at)"
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

export def "asset apk download_url" [name: string@names, first?: string] {
  $env.PKG_BIN_SYS = "android"

  let r = repo view $name
  let asset = assetx $r $first
  download_url $name $r.tag_name $asset
}

export def asset [name: string@names, first?: string] {
  let r = repo view $name
  assetx $r $first
}

export def "asset download" [name: string@names, first?: string] {
  let r = repo view $name
  let asset = assetx $r $first
  let download_url = download_url $name $r.tag_name $asset

  let basename = ($name | path basename)
  let dirname = ($env.TMP_PATH_FILE | path join $basename)
  mkdir $dirname

  let output = ($dirname | path join $asset)
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

def link [name: string@names, tag: string] {
  let text = ($"https://github.com/($name)/releases/tag/($tag)" | ansi link --text $name)
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

export def "repos update" [] {
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = index-get
  mut repos = open $env.GITHUB_REPOSITORY
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item
    let old_version = ($old.tag_name | to-version)

    let new = if $old.prerelease? == true {
      releases $old.name | where prerelease == true | first
    } else {
      releases-latest $old.name
    }

    let new_version = ($new.tag_name | to-version)
    let new_created_at = ($new.created_at | to-created-at)

    if ($it.index + 1) == $length {
      index-set 0
    } else {
      index-set ($it.index + 1 )
    }

    if $old.tag_name == $new.tag_name {
      print $"(link $old.name $old.tag_name) (white $old_version) (italic $new_created_at)"
      continue
    }
    if ($old.assets | is-not-empty) {
      if ($new.assets | length) < 1 {
        print $"(link $old.name $new.tag_name) (purple $old_version) (cyan $new_version) (italic $new_created_at)"
        continue
      }
    }

    print $"(link $old.name $new.tag_name) (red $old_version) (green $new_version) (italic $new_created_at)"

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

export def "repos upgrade" [] {
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = index-get
  mut repos = open $env.GITHUB_REPOSITORY
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item

    let new = releases-latest $old.name

    if ($it.index + 1) == $length {
      index-set 0
    } else {
      index-set ($it.index + 1 )
    }

    print $"(link $old.name $new.tag_name)"

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
  }

  print $"($length) -> ($last_index)..($last_index + $rate_limit.remaining)"
}

export def "repo view" [name: string@names] {
  let filter = (open $env.GITHUB_REPOSITORY | where name == $name)
  if ($filter | is-empty) {
    error make -u { msg: $"Repository does not exist: ($name)" }
  }
  return ($filter | first)
}

export def "repo update" [...names: string@names] {
  mut repos = open $env.GITHUB_REPOSITORY

  for $it in ($repos | enumerate) {
    if ($it.item.name not-in $names) {
      continue
    }
    let old = $it.item
    let new = if $old.prerelease? == true {
      releases $old.name | where prerelease == true | first
    } else {
      releases-latest $old.name
    }

    print $"(link $it.item.name $new.tag_name)"

    mut repo = ($old
      | upsert tag_name $new.tag_name
      | upsert created_at $new.created_at
      | upsert assets ($new.assets | get name | exclusion)
    )

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
  }
}
