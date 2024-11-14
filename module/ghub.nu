
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_UPDATE = ($env.HOME | path join .github.update)
}

def latest [repository: string] {
  let release = (http get --full --allow-errors https://api.github.com/repos/($repository)/releases/latest)
  if ($release | get status) == 403 {
    error make -u { msg: "API rate limit exceeded" }
  }
  $release | get body
}

export def names [] {
  open $env.GITHUB_REPOSITORY | get repository
}

export def repository [name: string@names] {
  let repository = (open $env.GITHUB_REPOSITORY | where repository == $name)
  if ($repository | is-empty) {
    error make -u {msg: "the repository does not exist"}
  }
  return ($repository | first)
}

export def version [name: string@names] {
  repository $name | get tag_name
}

export def update [] {
  if not ($env.GITHUB_UPDATE | path exists) {
    '0' | save --force $env.GITHUB_UPDATE
  }
  touch $env.GITHUB_UPDATE
  let rate = (http get https://api.github.com/rate_limit | get rate)
  let reset = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  if $rate.remaining == 0 {
    return { reset: $reset }
  }

  let skip = (open $env.GITHUB_UPDATE | into int)
  mut repos = (open $env.GITHUB_REPOSITORY)
  for $it in ($repos | enumerate | skip $skip) {
    let new = (latest $it.item.repository)
    if ($new.assets | length) <= 2 {
      continue
    }
    if ($new | is-empty) {
      continue
    }

    let tag_name = ($new.tag_name | str trim --char 'v')
    if ($tag_name | str contains $it.item.tag_name) {
      print $"(light $it.item.repository) (white $it.item.tag_name)"
    } else {
      print $"(light $it.item.repository) (red $it.item.tag_name) (green $tag_name)"
    }

    let repository = ($it.item
          | upsert tag_name $tag_name
          | upsert prerelease $new.prerelease
          | upsert created_at $new.created_at)

    $repos = ($repos | upsert $it.index $repository)
    $repos | save --force $env.GITHUB_REPOSITORY

    if ($it.index + 1) == ($repos | length)  {
      '0' | save --force $env.GITHUB_UPDATE
    } else {
      $it.index | save --force $env.GITHUB_UPDATE
    }
  }
}

def light [str: string] {
  return $'(ansi default)($str)(ansi reset)'
}

def white [str: string] {
  return $'(ansi white_bold)($str)(ansi reset)'
}

def red [str: string] {
  return $'(ansi red_bold)($str)(ansi reset)'
}

def green [str: string] {
  return $'(ansi green_bold)($str)(ansi reset)'
}
