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

def max_length_v1 [ratio: float, size_sum: int] {
  if (term size | get columns) < 120 {
    if $size_sum < 1280 {
      2
    } else if $ratio <= 1  {
      2
    } else {
      1
    }
  } else {
    if $size_sum < 1280 {
      5
    } else if $ratio == 0.56  {
      4
    } else if $ratio <= 0.5 {
      4
    } else if $ratio <= 1.0 {
      4
    } else if $ratio <= 1.5 {
      3
    } else if $ratio <= 2.0 {
      2
    } else {
      1
    }
  }
}

def item-to-link [width: int] {
  let item = $in
  let chars = ($item | get path | path basename | split chars)
  let text = ($chars | last ($width / 1.5 | math floor) | str join)
  let content = ($text | fill -a center -w $width -c " ")
  let link_text = if $item.video {
    (ansi cyan_bold)($content)(ansi reset)
  } else {
    (ansi green_bold)($content)(ansi reset)
  }
  $item | get path | ansi link --text $link_text
}

def space-evenly [...items: record] {
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
  for $item in $items {
    $blocks = ($blocks | append ($item | item-to-link $width))
  }

  return ($blocks | str join)
}

export def slide [
  dir: path = ".",
  --max-depth(-m): int = 1
  --search(-s): string = "."
  --sleep(-S): duration = 2sec
  --first(-f): int = 100_000
  --reset(-r)
  --no-title(-n)
  --debug(-d)
  --image(-i)
  --video(-v)
] {
  use preload/

  mut groups = {}
  mut size_sums = []
  mut group_keys = []

  let index_path = ($dir | path expand | path join .preview.index)
  let index_value = if $reset or not ($index_path | path exists) { 0 } else { open $index_path | into int }

  let extensions = if $image and $video {
    [-e "png",-e "jpg",-e "jpeg",-e "mp4"]
  } else if $image {
    [-e "png",-e "jpg",-e "jpeg"]
  } else if $video {
    [-e "mp4"]
  } else {
    [-e "png",-e "jpg",-e "jpeg",-e "mp4"]
  }

  let media_paths = (fd -a ...$extensions -d $max_depth $search $dir | lines)
  if ($media_paths | is-empty) {
    return
  }

  for media_path in ($media_paths | skip $index_value | first $first | enumerate) {
    let is_video = ($media_path.item | str downcase | str ends-with "mp4")
    let media_preview = if $is_video {
      let preview = preload video $media_path.item
      if ($preview | is-empty) {
        continue
      } else {
        $preview | first
      }
    } else {
      let preview = preload image $media_path.item
      if ($preview | is-empty) {
        $media_path.item
      } else {
        $preview | first
      }
    }

    let parse = (file $media_preview | parse -r ', (?P<width>\d+)\s*x\s*(?P<height>\d+), ')
    if ($parse | is-empty) {
      error make -u {msg: $"File parse: ($media_preview)"}
    }

    let size = ($parse | first)
    let width = ($size.width | into int)
    let height = ($size.height | into int)
    let ratio = $width / $height | math round -p 2

    let size_sum = $width + $height
    $size_sums = ($size_sums | append $size_sum)

    let group_key = ($ratio | to text)
    $group_keys = ($group_keys | append $group_key)

    let group_value = {path: $media_path.item, preview: $media_preview, ratio: $group_key, size_sum: $size_sum, video: $is_video}
    let group_values = ($groups | get -o $group_key | default [] | append $group_value)
    $groups = ($groups | upsert $group_key $group_values)

    let group_length = ($group_values | length)
    let max_length = max_length_v1 $ratio $size_sum

    if $group_length == $max_length {
      $groups = ($groups | upsert $group_key [])
      $index_value + $media_path.index | save --force $index_path

      if $debug {
        print $group_values
        continue
      }
      try {
        print "" (space-evenly ...$group_values)
        timg --center --auto-crop --fit-width --grid $group_length ...($group_values | get preview)
        sleep $sleep
      } catch { return }
    }
  }

  for group in ($groups | transpose key values) {
    let group_length = ($group.values | length)
    if ($group.values | is-empty) {
      continue
    }
    if $debug {
      print $group.values
      continue
    }
    try {
      print "" (space-evenly ...$group.values)
      timg --center --auto-crop --fit-width --grid $group_length ...($group.values | get preview)
      sleep $sleep 
    } catch { return }
  }

  if false {
    print ($size_sums | uniq | sort)
    print ($group_keys | uniq | sort)
  }

  0 | save --force $index_path
}

export def main [] {
  slide --debug
}
