
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

export def get_repository [name: string@names] {
  let repo = (repos | where repository == $name)
  if ($repo | is-empty) {
    error make -u {msg: "the repository does not exist"}
  }
  return ($repo | first)
}

export def name_tag [context: string] {
  let name = ($context | str trim | split row " " | last)
  [ (get_repository $name | get tag_name) ]
}

export def get_version [name: string@names] {
  get_repository $name | get tag_name
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
  open ($env.REPO_PATH | path join files github.json)
}
