
export def gallery [
  ...images: string
  --pixelation(-p): string
  --search(-s): string = "."
  --max-depth(-m): int = 1
  --columns(-c): int
  --dir(-d): path = "."
] {
  let images = if ($images | is-not-empty) { $images } else {
    fd -e png -e jpg -e jpeg -d $max_depth $search $dir | lines
  }

  if ($images | is-empty) {
    return
  }

  let terminal_width = (term size | get columns)
  let is_wide_terminal = $terminal_width > 110
  let image_count = ($images | length)
  
  let grid_columns = if $columns != null { $columns } else {
    let max_images_per_row = if $image_count <= 2 { $image_count } else { 2 }
    if $is_wide_terminal { $max_images_per_row * 2 } else { $max_images_per_row }
  }

  let graphics = match [$env.TERM, $env.TERM_PROGRAM?] {
    ["xterm-kitty", null] => "k",          # kitty graphics
    ["xterm-ghostty", "ghostty"] => "k",   # kitty graphics
    ["xterm-256color", "WezTerm"] => "s",  # sixel graphics
    ["xterm-256color", "BlackBox"] => "s", # sixel graphics
    _ => "q"                               # quarter blocks
  }

  let pixelation = ($pixelation | default $graphics)
  timg --title --pixelation $pixelation --grid $grid_columns ...$images
}

export def finder [] {
  # let preview = "img2sixel -w $FZF_PREVIEW_COLUMNS -h $FZF_PREVIEW_LINES {}"
  let preview = "chafa --size=$(echo $FZF_PREVIEW_COLUMNS)x$(echo $FZF_PREVIEW_LINES) {}"
  fd -e jpg -e jpg -e png | fzf --style full --layout reverse --preview $preview --preview-window=right:70%
}
