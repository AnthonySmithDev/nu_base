
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_UPDATE = ($env.HOME | path join .github.update)
}

export def list [] {
  open $env.GITHUB_REPOSITORY
}

export def names [] {
  list | get repository
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

export def find [repository: string@names] {
  return (list | where repository =~ $repository)
}

export def view [repository: string@names] {
  let repos = (list | where repository == $repository)
  if ($repos | is-empty) {
    error make -u { msg: "Repository does not exist" }
  }
  return ($repos | first)
}

def to-version [] {
  str trim --char 'v' | str trim --char 'V'
}

def to-created-at [] {
  into datetime --offset -5 | date humanize
}

export def version [repository: string@names] {
  let repo = view $repository
  let version = ($repo.tag_name | to-version)
  let created_at = ($repo.created_at | to-created-at)
  print $"(link $repository $repo.tag_name) (white $version) (italic $created_at)"
  return $version
}

def get-last-index [] {
  if ($env.GITHUB_UPDATE | path exists) {
    return (open $env.GITHUB_UPDATE | into int)
  }
  return 0
}

def set-last-index [index: int] {
  $index | save --force $env.GITHUB_UPDATE
}

export def rate_limit [] {
  let rate = (http get https://api.github.com/rate_limit | get rate)
  let reset = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  return ($rate | upsert reset $reset)
}

export def update [] {
  let rate_limit = rate_limit
  if $rate_limit.remaining == 0 {
    return ($rate_limit | select reset remaining)
  }

  let last_index = get-last-index
  mut repos = list
  let length = ($repos | length)
  for $it in ($repos | enumerate | skip $last_index | first $rate_limit.remaining) {
    let old = $it.item
    let old_version = ($old.tag_name | to-version)

    let new = latest $old.repository
    let new_version = ($new.tag_name | to-version)
    let new_created_at = ($new.created_at | to-created-at)

    if ($it.index + 1) == $length {
      set-last-index 0
    } else {
      set-last-index ($it.index + 1 )
    }

    if $old.tag_name == $new.tag_name {
      print $"(link $old.repository $old.tag_name) (white $old_version) (italic $new_created_at)"
      continue
    }
    if ($new.assets | length) < 1 {
      print $"(link $old.repository $new.tag_name) (purple $old_version) (cyan $new_version) (italic $new_created_at)"
      continue
    }

    print $"(link $old.repository $new.tag_name) (red $old_version) (green $new_version) (italic $new_created_at)"

    mut repo = ($old | upsert tag_name $new.tag_name | upsert created_at $new.created_at)
    if $new.prerelease {
      $repo = ($repo | upsert prerelease $new.prerelease)
    }

    $repos = ($repos | upsert $it.index $repo)
    $repos | save --force $env.GITHUB_REPOSITORY
  }
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
