# https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/video.lua

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
    ["xterm-ghostty", null] => "k",        # kitty graphics
    ["xterm-ghostty", "ghostty"] => "k",   # kitty graphics
    ["xterm-256color", "WezTerm"] => "s",  # sixel graphics
    ["xterm-256color", "BlackBox"] => "s", # sixel graphics
    _ => "q"                               # quarter blocks
  }

  let pixelation = ($pixelation | default $graphics)
  timg --title -wr1 --fit-width --pixelation $pixelation --grid $grid_columns ...$images
}

export def slide [
  dir: path = ".",
  --max-depth(-m): int = 1
  --search(-s): string = "."
  --sleep(-s): duration = 1sec
  --reset(-r)
  --title(-t)
  --debug(-d)
] {

  let group_config = [
    { max_ratio: 0.5, max_items: 4, group: "1" }
    { max_ratio: 0.6, max_items: 4, group: "2" }
    { max_ratio: 0.7, max_items: 4, group: "3" }
    { max_ratio: 0.8, max_items: 4, group: "4" }
    { max_ratio: 0.9, max_items: 4, group: "5" }
    { max_ratio: 1.0, max_items: 3, group: "6" }
    { max_ratio: 1.1, max_items: 3, group: "7" }
    { max_ratio: 1.2, max_items: 3, group: "8" }
    { max_ratio: 1.3, max_items: 3, group: "9" }
    { max_ratio: 1.4, max_items: 3, group: "10" }
    { max_ratio: 1.5, max_items: 3, group: "11" }
    { max_ratio: 1.6, max_items: 2, group: "12" }
    { max_ratio: 1.7, max_items: 2, group: "13" }
    { max_ratio: 1.8, max_items: 2, group: "14" }
    { max_ratio: 1.9, max_items: 2, group: "15" }
    { max_ratio: 2.0, max_items: 1, group: "16" }
  ]

  mut groups = {}

  let path = ($dir | path expand | path join .preview.index)
  let images = (fd -e png -e jpg -e jpeg -d $max_depth $search $dir | lines)
  let index = if $reset or not ($path | path exists) { 0 } else { open $path | into int }

  for $image in ($images | skip $index | enumerate) {
    let size = (file $image.item | parse -r ', (?P<width>\d+)\s*x\s*(?P<height>\d+), ' | first)
    let ratio = ($size.width | into int) / ($size.height | into int)

    let filter = ($group_config | where $ratio < $it.max_ratio)
    let config = if ($filter | is-not-empty) {
      $filter | first
    } else {
      { max_items: 1, group: "x" }
    }

    let items = ($groups | get -o $config.group | default [] | append {path: $image.item, ratio: $ratio})
    $groups = ($groups | upsert $config.group $items)

    let items_length = ($items | length)
    if $items_length == ($config.max_items) {
      $groups = ($groups | upsert $config.group [])
      if $debug {
        print $items
      } else {
        mut args = []
        if $title {
          $args = ($args | append [--title])
        }
        try {
          timg ...$args --fit-width --grid $items_length ...($items | get path)
        } catch {
          return
        }
      }
      $index + $image.index | save --force $path
      try { sleep $sleep } catch { return }
    }
  }

  0 | save --force $path
}
