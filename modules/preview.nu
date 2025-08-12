
def fuzzy [preview: string, size: int, execute: string = ""] {
  let stdin = $in
  if ($stdin | is-empty) {
    return
  }

  let enter = if ($execute | is-not-empty) {
    $"execute\(($execute))"
  } else {
    "accept"
  }

  let bind_vim = "j:down,k:up,/:show-input+unbind(j,k,/)"
  let bind_enter = $"enter,esc,ctrl-c:transform:
        if [[ $FZF_INPUT_STATE = enabled ]]; then
          echo 'rebind\(j,k,/)+hide-input'
        elif [[ $FZF_KEY = enter ]]; then
          echo '($enter)'
        else
          echo 'abort'
        fi"

  mut args = [
    --style full
    --layout reverse
    --preview $preview
    --preview-window right:($size)%
  ]

  $stdin | fzf --no-input --bind $bind_vim --bind $bind_enter ...$args
}

export def videos [--size(-s): int = 80] {
  let preview = "vicat -W $FZF_PREVIEW_COLUMNS -H $FZF_PREVIEW_LINES {}"
  fd -e mp4 -e mkv | fuzzy $preview $size "mpv {}"
}

export def images [--size(-s): int = 80] {
  let preview = "vicat -W $FZF_PREVIEW_COLUMNS -H $FZF_PREVIEW_LINES {}"
  fd -e jpg -e jpg -e png | fuzzy $preview $size
}

export def grid [
  ...images: string
  --pixelation(-p): string
  --search(-s): string = "."
  --max-depth(-m): int = 1
  --columns(-c): int
  --dir(-d): path = "."
] {
  let images = if ($images | is-not-empty) { $images } else {
    fd -e png -e jpg -e jpeg -e svg -d $max_depth $search $dir | lines
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

export def slide [
  --search(-s): string = "."
  --max-depth(-m): int = 1
  --dir(-d): path = "."
  --chunck(-c): int = 3
  --reset
] {
  let state_file = ($nu.temp-path | path join "slide_state.txt")

  mut skip = if $reset or not ($state_file | path exists) {
    0
  } else {
    try { open $state_file | into int } catch { 0 }
  }

  let images = (fd -e png -e jpg -e jpeg -e svg -d $max_depth $search $dir | lines | skip $skip)

  for images_chunk in ($images | chunks $chunck) {
    timg -wr1 --grid $chunck --fit-width --upscale=i --center ...($images_chunk) # -g 200x100
    $skip = $skip + $chunck
    $skip | save -f $state_file
  }

  if ($skip >= ($images | length)) {
    0 | save -f $state_file
  }
}
