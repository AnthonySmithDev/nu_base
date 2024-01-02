
export-env {
  $env.BOARD_PATH = ($env.HOME | path join '.board')
}

def default [] {
  "## To Do\n\n## Doing\n\n## Done\n\n"
}

def board_path [] {
  if not ($env.BOARD_PATH | path exists) {
    mkdir $env.BOARD_PATH
  }
}

export def main [name?: string] {
  if ($name != null) {
    new $name
  } else {
    list
  }
}

export def list [] {
  board_path
  ls -s $env.BOARD_PATH | get name
}

export def add [name: string] {
  board_path
  let file = ($env.BOARD_PATH | path join $name)
  if not ($file | path exists) {
    default | save $file
  }
}

export def edit [name: string@list] {
  board_path
  let file = ($env.BOARD_PATH | path join $name)
  if ($file | path exists) {
    ^taskell $file
  }
}

export def new [name: string] {
  add $name
  edit $name
}

export def view [name: string@list] {
  board_path
  let file = ($env.BOARD_PATH | path join $name)
  if ($file | path exists) {
    ^glow $file
  }
}

export def remove [name: string@list] {
  board_path
  let file = ($env.BOARD_PATH | path join $name)
  if ($file | path exists) {
    rm $file
  }
}

export def sync [
  --pull(-p)
  --commit(-c): string
  --init(-i): string
] {
  if ($env.BOARD_PATH | path join '.git' | path exists) {
    if $pull {
      git -C $env.BOARD_PATH pull origin main
    }
    if not ($commit | is-empty) {
      git -C $env.BOARD_PATH add '.'
      git -C $env.BOARD_PATH commit -m $commit
      git -C $env.BOARD_PATH push -u origin main
    }
  } else {
    if ($init | is-empty) {
      git -C $env.BOARD_PATH init
      git -C $env.BOARD_PATH branch -M main
      git -C $env.BOARD_PATH remote add origin $init
    }
  }
}
