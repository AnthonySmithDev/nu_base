#!/usr/bin/env -S nu --stdin

def filename [] {
  $env.PWD | path join ctx.txt
}

def main [] {
  let path = filename
  $"\n($in)\n" | save --append $path
  print -n $in
}

def "main replace" [] {
  let path = filename
  $"\n($in)\n" | save --force $path
  print -n $in
}

def "main r" [] {
  main replace
}

def "main show" [lang: string = "txt"] {
  let path = filename
  if ($path | path exists) {
    bat --language $lang --paging never --plain $path
  }
}

def "main s" [lang: string = "txt"] {
  main show $lang
}

def "main delete" [] {
  let path = filename
  if ($path | path exists) {
    rm $path
  }
}

def "main d" [] {
  main delete
}

def "main editor" [...rest] {
  let path = filename
  if ($path | path exists) {
    hx $path
  }
}

def "main e" [...rest] {
  main editor ...$rest
}

def "main mods" [...rest] {
  let path = filename
  if ($path | path exists) {
    open $path | mods ...$rest
  }
}

def "main m" [...rest] {
  main mods ...$rest
}
