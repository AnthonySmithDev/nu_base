
export-env {
  $env.GITHUB_REPOSITORY = ($env.NU_BASE_PATH | path join files github.json)
  $env.GITHUB_UPDATE = ($env.HOME | path join .github.json)
}

def repositories [] {
  open $env.GITHUB_REPOSITORY | get repository
}

export def latest [repository: string@repositories] {
  let release = (http get -f -e https://api.github.com/repos/($repository)/releases/latest)
  if ($release | get status) == 403 {
    error make {
      msg: "API rate limit exceeded"
    }
  }
  $release | get body
}

export def tag_name [] {
  let rate = rate_limit
  if $rate.remaining == 0 {
    return ($rate.date)
  }
  if not ($env.GITHUB_UPDATE | path exists) {
    touch $env.GITHUB_UPDATE
  }

  mut repository = (open $env.GITHUB_REPOSITORY)
  mut update = open $env.GITHUB_UPDATE

  if ($repository | length) > ($update | length) {
    $update = ($repository
    | upsert updated_at  {|row| $row.created_at}
    | select repository updated_at)
    $update | save -f $env.GITHUB_UPDATE
  }

  let repositories = (
  $repository
    | merge $update
    | update updated_at { into datetime }
    | where updated_at  < (date now) - 6hr
  )
  for $old in $repositories {
    let new = (latest $old.repository)
    if ($new.assets | length) <= 2 {
      continue
    }
    if ($new | is-empty) {
      continue
    }

    print $old.repository

    let new_tag_name = ($new.tag_name | str trim --char 'v')
    # if $old.tag_name != $new_tag_name {
      (update_github_repository $old.repository $new_tag_name $new.prerelease $new.created_at)
      (update_github_updated_at $old.repository (date now | date to-timezone UTC))
      # print -n $old.tag_name " " $new.tag_name " " $new_tag_name "\n"
    # }
  }
}

def update_github_repository [repository: string, tag_name: string, prerelease: bool, created_at: string] {
  open $env.GITHUB_REPOSITORY | each {|e|
    if $e.repository == $repository {
      ($e | upsert tag_name $tag_name
          | upsert prerelease $prerelease
          | upsert created_at $created_at)
    } else {
      $e
    }
  } | collect { save -f $env.GITHUB_REPOSITORY }
}

def update_github_updated_at [repository: string, updated_at: datetime] {
  open $env.GITHUB_UPDATE | each {|e|
    if $e.repository == $repository {
      ($e | upsert updated_at $updated_at)
    } else {
      $e
    }
  } | collect { save -f $env.GITHUB_UPDATE }
}

export def rate_limit [] {
  let rate = (http get https://api.github.com/rate_limit | get rate)
  let date = ($rate | get reset | $in * 1_000_000_000 | into datetime --offset -5)
  $rate | insert date $date
}
