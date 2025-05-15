#!/usr/bin/env -S nu --stdin

export def main [] {
  let input = $in
  if ($input | is-empty) {
    return
  }

  let temp_file = (mktemp -t)
  $input | save --force $temp_file

  $env.VISUAL = "scrollback-editor"
  less -R +G $temp_file
  rm $temp_file
}
