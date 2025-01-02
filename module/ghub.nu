
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_UPDATE = ($env.HOME | path join .github.update)
}

export def names [] {
  open $env.GITHUB_REPOSITORY | get repository
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

export def view [repository: string@names] {
  let repos = (open $env.GITHUB_REPOSITORY | where repository == $repository)
  if ($repos | is-empty) {
    error make -u {msg: "the repository does not exist"}
  }
  return ($repos | first)
}

export def version [repository: string@names] {
  view $repository | get version
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
  let rate = rate_limit
  if $rate.remaining == 0 {
    return ($rate | select reset remaining)
  }

  let last_index = get-last-index
  mut repos = (open $env.GITHUB_REPOSITORY)
  for $it in ($repos | enumerate | skip $last_index | first $rate.remaining) {
    let new = (latest $it.item.repository)
    let version = ($new.tag_name | str trim --char 'v' | str trim --char 'V')
    let created_at = ($new.created_at | into datetime --offset -5 | date humanize)

    if ($new.assets | length) < 1 {
      print $"(link $it.item.repository $new.tag_name) (purple $it.item.version) (cyan $version) (italic $created_at)"
      continue
    }
    if ($new | is-empty) {
      continue
    }

    if $it.item.tag_name == $new.tag_name {
      print $"(link $it.item.repository $it.item.tag_name) (white $it.item.version) (italic $created_at)"
    } else {
      print $"(link $it.item.repository $new.tag_name) (red $it.item.version) (green $version) (italic $created_at)"
    }

    let repository = ($it.item
          | upsert version $version
          | upsert tag_name $new.tag_name
          | upsert prerelease $new.prerelease
          | upsert created_at $new.created_at)

    $repos = ($repos | upsert $it.index $repository)
    $repos | save --force $env.GITHUB_REPOSITORY

    if ($it.index + 1) == ($repos | length) {
      set-last-index 0
    } else {
      set-last-index ($it.index + 1 )
    }
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
