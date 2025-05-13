#!/usr/bin/env -S nu --stdin

def main [] {
  print "Context Manager"
}

def path-chunck [] {
  $env.PWD | path join ctx chunck
}

def open-chunks [] {
  let path = path-chunck
  if ($path | path exists) {
    return (ls $path | get name)
  }
  return []
}

def show-files [
  ...files: path,
  --style(-s): string = "plain",
  --lang(-l): string = "txt",
] {
  bat --color=always --paging=never --language=($lang) --style=($style) ...$files
}

def filter-files [lang: string = "txt"] {
  let preview = $"bat --language=($lang) --color=always --style=numbers {}"
  $in | fzf --multi --style full --layout reverse --preview $preview | lines
}

export def "add chunck" [] {
  let input = $in
  if ($input | is-empty) {
    return
  }

  let path = path-chunck
  mkdir $path

  let trim = ($input | str trim)
  let hash = ($trim | hash md5)

  $trim | save --force ($path | path join $hash)
}

export def "show chunck" [--lang(-l): string = "txt"] {
  let chunks = open-chunks
  if ($chunks | is-empty) {
    return
  }
  show-files ...$chunks -l $lang
}

export def "open chunck" [] {
  let chunks = open-chunks
  cat ...$chunks
}

export def "edit chunck" [] {
  if (open-chunks | is-empty) {
    return
  }
  hx (path-chunck)
}

export def "remove chunck" [--lang(-l): string = "txt"] {
  let chunks = open-chunks
  if ($chunks | is-empty) {
    return
  }
  let select = ($chunks | to text | filter-files $lang)
  if ($select | is-empty) {
    return
  }
  rm ...$select
  print "OK"
}

export def "clear chunck" [] {
  let chunks = open-chunks
  if ($chunks | is-empty) {
    return
  }
  rm ...$chunks
  print "OK"
}

def path-files [] {
  $env.PWD | path join ctx files.txt
}

def open-files [] {
  let path = path-files
  if ($path | path exists) {
    return (open $path | lines)
  }
  return []
}

export def "add file" [] {
  let select = (fd --type file | filter-files | lines)
  if ($select | is-empty) {
    return
  }
  $select | save --append --force (path-files)
  print $select
}

export def "show file" [] {
  let files = open-files
  if ($files | is-empty) {
    return
  }
  show-files ...$files
}

export def "path file" [] {
  let files = open-files
  if ($files | is-empty) {
    return
  }
  return $files
}

export def "edit file" [] {
  hx (path-files)
}

export def "remove file" [] {
  let saved = open-files
  if ($saved | is-empty) {
    return
  }

  let to_rm = ($saved | filter-files)
  if ($to_rm | is-empty) {
    return
  }

  let updated = ($saved | where {|f| $f not-in $to_rm})
  $updated | save --force (path-files)
}

export def "clear file" [] {
  let saved = open-files
  if ($saved | is-empty) {
    return
  }
  "" | save --force (path-files)
  print $saved
}

# export def "add dir" [dir: path] {
#   let dirs = (fd --type dir | lines)
#   if ($dirs | is-empty) { return }
#   show-dirs ...$dirs
# }

def "main add chunck" [] {
  add chunck
}

def "main show chunck" [--lang(-l): string = "txt"] {
  show chunck -l $lang
}

def "main open chunck" [] {
  open chunck
}

def "main edit chunck" [] {
  edit chunck
}

def "main remove chunck" [--lang(-l): string = "txt"] {
  remove chunck -l $lang
}

def "main clear chunck" [] {
  clear chunck
}

def "main add file" [] {
  add file
}

def "main show file" [] {
  show file
}

def "main path file" [] {
  path file
}

def "main edit file" [] {
  edit file
}

def "main remove file" [] {
  remove file
}

def "main clear file" [] {
  clear file
}
