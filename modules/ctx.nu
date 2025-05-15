#!/usr/bin/env -S nu --stdin

def main [] {
  print "Context Manager"
}

def path-ctx [...paths: string] {
  $env.PWD | path join ctx ...$paths
}

def path-chunck [] {
  path-ctx chunck
}

def open-chunks [] {
  let path = path-chunck
  if ($path | path exists) {
    return (ls $path | get name)
  }
  return []
}

def filter [preview: string, query: string = ""] {
  fzf --multi --style=full --layout=reverse --preview=($preview) --query=($query) | lines
}

def filter-chunck [lang: string] {
  filter $"bat --language=($lang) --color=always --style=numbers {}" ""
}

export def "add chunck" [] {
  let input = $in
  if ($input | is-empty) {
    return
  }

  let trim = ($input | str trim)
  let hash = ($trim | hash md5)

  let path = path-chunck
  mkdir $path

  $trim | save --force ($path | path join $hash)
}

export def "show chunck" [--lang(-l): string = "txt"] {
  let chunks = open-chunks
  if ($chunks | is-empty) {
    return
  }
  cat ...$chunks
}

export def "pretty chunck" [--lang(-l): string = "txt"] {
  let chunks = open-chunks
  if ($chunks | is-empty) {
    return
  }
  bat --color=always --paging=never --language=($lang) --style=full ...$chunks
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
  let select = ($chunks | to text | filter-chunck $lang)
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
  path-ctx files.txt
}

def open-files [] {
  let path = path-files
  if ($path | path exists) {
    return (open $path | str trim | lines)
  }
  return []
}

def filter-files [query?: string] {
  filter "bat --color=always --style=numbers {}" $query
}

export def "add file" [--search(-s): string] {
  let select = (fd --type file | filter-files $search | lines)
  if ($select | is-empty) {
    return
  }

  mkdir (path-ctx)
  $select | save --append --force (path-files)
  print $select
}

export def "show file" [] {
  let files = open-files
  if ($files | is-empty) {
    return
  }
  cat ...$files
}

export def "pretty file" [] {
  let files = open-files
  if ($files | is-empty) {
    return
  }
  bat --color=always --paging=never --style=full ...$files
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

export def "remove file" [--search(-s): string] {
  let saved = open-files
  if ($saved | is-empty) {
    return
  }

  let to_rm = ($saved | to text | filter-files $search)
  if ($to_rm | is-empty) {
    return
  }

  let updated = ($saved | where {|f| $f not-in $to_rm})
  $updated | save --force (path-files)
  print $to_rm
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

export def show [] {
  let files = open-files
  let chunks = open-chunks
  cat ...$files ...$chunks
}

def "main add chunck" [] {
  add chunck
}

def "main show chunck" [] {
  show chunck
}

def "main pretty chunck" [--lang(-l): string = "txt"] {
  pretty chunck -l $lang
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

def "main add file" [--search(-s): string = ""] {
  add file --search $search
}

def "main show file" [] {
  show file
}

def "main pretty file" [] {
  pretty file
}

def "main path file" [] {
  path file
}

def "main edit file" [] {
  edit file
}

def "main remove file" [--search(-s): string = ""] {
  remove file --search $search
}

def "main clear file" [] {
  clear file
}

def "main show" [] {
  show
}

def actions [] {
  ["add", "show", "pretty", "open", "edit", "remove", "clear", "path"] 
}

def targets [] {
  ["chunck", "file"] 
}

def xmain [
    action: string@actions
    target: string@targets
    --lang(-l): string = "txt"
] {
  match [$action, $target] {
    ["add" "chunck"] => { add chunck }
    ["show" "chunck"] => { show chunck -l $lang }
    ["open" "chunck"] => { open chunck }
    ["edit" "chunck"] => { edit chunck }
    ["remove" "chunck"] => { remove chunck -l $lang }
    ["clear" "chunck"] => { clear chunck }
    ["add" "file"] => { add file }
    ["show" "file"] => { show file }
    ["pretty" "file"] => { pretty file }
    ["path" "file"] => { path file }
    ["edit" "file"] => { edit file }
    ["remove" "file"] => { remove file }
    ["clear" "file"] => { clear file }
    _ => { echo $"Unknown command: ($action) ($target)" }
  }
}
