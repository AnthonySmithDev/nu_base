
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

export def main [name?: string@list] {
  if ($name != null) {
    new $name
  } else {
    list
  }
}

export def list [] {
  board_path
  ls -s $env.BOARD_PATH | where type == file | get name
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
  --commit(-c)
] {
  if ($env.BOARD_PATH | path exists) {
    if ($env.BOARD_PATH | path join .git | path exists) {
      git -C $env.BOARD_PATH pull
    } else {
      git clone git@github.com:AnthonySmithDev/board.git $env.BOARD_PATH
    }
  } else {
    git clone git@github.com:AnthonySmithDev/board.git $env.BOARD_PATH
  }

  if $commit {
    git -C $env.BOARD_PATH add '.'
    git -C $env.BOARD_PATH commit -m (msg)
    git -C $env.BOARD_PATH push
  }
}

export def msg [] {
  let gitmojis = (http get https://gitmoji.dev/api/gitmojis | get gitmojis)
  let max = ($gitmojis | length) - 1
  let index = (random int 0..$max)
  let gitmoji = ($gitmojis | get $index)
  $'($gitmoji.emoji) ($gitmoji.description)'
}
