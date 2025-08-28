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

def max_items_v1 [ratio: float] {
  if $ratio > 0.5 {
    5
  } else if $ratio > 1.0 {
    4
  } else if $ratio > 1.5 {
    3
  } else if $ratio > 2.0 {
    2
  } else {
    1
  }
}

export def slide [
  dir: path = ".",
  --max-depth(-m): int = 1
  --search(-s): string = "."
  --sleep(-S): duration = 1sec
  --reset(-r)
  --title(-t)
  --debug(-d)
] {

  mut groups = {}

  let path = ($dir | path expand | path join .preview.index)
  let images = (fd -e png -e jpg -e jpeg -d $max_depth $search $dir | lines)
  let index = if $reset or not ($path | path exists) { 0 } else { open $path | into int }

  for $image in ($images | skip $index | enumerate) {
    let size = (file $image.item | parse -r ', (?P<width>\d+)\s*x\s*(?P<height>\d+), ' | first)
    let ratio = ($size.width | into int) / ($size.height | into int)

    let group_key = ($ratio | math round -p 1 | to text)
    let max_items = max_items_v1 $ratio

    let items = ($groups | get -o $group_key | default [] | append {path: $image.item, ratio: $ratio})
    $groups = ($groups | upsert $group_key $items)

    let items_length = ($items | length)
    if $items_length == $max_items {
      $groups = ($groups | upsert $group_key [])
      $index + $image.index | save --force $path

      if $debug {
        print $items
        continue
      }
      if $title {
        print (space-evenly ...($items | get path | path expand))
      }
      try { timg --fit-width --grid $items_length ...($items | get path) } catch { return }
      try { sleep $sleep } catch { return }
    }
  }

  for $item in ($groups | transpose key value) {
    if ($item.value | is-empty) {
      continue
    }

    if $debug {
      print $item.value
      continue
    }
    if $title {
      print (space-evenly ...($item.value | get path | path expand))
    }
    try { timg --fit-width --grid ($item.value | length) ...($item.value | get path) } catch { return }
    try { sleep $sleep } catch { return }
  }

  0 | save --force $path
}

def item-to-link [width: int] {
  let item = $in
  let chars = ($item | path basename | split chars)
  let text = ($chars | last ($width / 1.5 | math floor) | str join)
  $item | ansi link --text ($text | fill -a center -w $width -c " ")
}

def space-evenly [...items: string] {
  if ($items | is-empty) {
    return ""
  }

  let term_width = term size | get columns
  let items_length = ($items | length)

  if $items_length == 1 {
    return ($items | first | item-to-link $term_width)
  }

  let width = $term_width / $items_length | math floor

  mut blocks = []
  for $index in 0..($items_length - 1) {
    $blocks = ($blocks | append ($items | get $index | item-to-link $width))
  }

  return ($blocks | str join)
}

export def main [] {
  use preload

  let videos = (fd -e mp4 | lines)
  for $chunk in ($videos | chunks 4) {
    let preloads = preload video ...$chunk
    print $preloads
    try {
      print (space-evenly ...($chunk | path expand))
      timg --fit-width --grid ($chunk | length) ...$preloads
      sleep 500ms
    } catch {
      return
    }
  }
}
