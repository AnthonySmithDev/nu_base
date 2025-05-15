#!/usr/bin/env -S nu

export def main [line: string, path: string] {
  let temp = (mktemp -t)
  open $path | ansi strip | save --force $temp
  hx $line $temp
}
