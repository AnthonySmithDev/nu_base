
export def filter [--multi (-m)] {
  let preview = 'bat --language SQL --plain --number --color=always {}'
  if $multi {
    fd --no-ignore --extension sql | fzf --layout reverse --border --preview $preview --preview-window 'right,75%' -m | lines
  } else {
    fd --no-ignore --extension sql | fzf --layout reverse --border --preview $preview --preview-window 'right,75%' | str trim
  }
}

export def main [--format(-f)] {
  if $format {
    sleek *.sql
  }
  let file = (filter)
  if ($file | is-empty) {
    return
  }
  hx $file
}
