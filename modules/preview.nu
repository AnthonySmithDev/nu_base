
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


export def image-mediainfo-size [path: string] {
  mediainfo --Inform="Image;%Width%_%Height%" $path | parse "{width}_{height}" | first
}

export def image-identify-size [path: string] {
  identify -format "%w_%h" $path | parse "{width}_{height}" | first
}

export def image-size [path: string] {
  let size = (file $path | parse -r ', (?P<width>\d+)\s*x\s*(?P<height>\d+), ' | first)
  {
    width: ($size.width | into int)
    height: ($size.height | into int)
  }
}

export def image-group [images: list] {
  # let images = (fd -e png -e jpg -e jpeg | lines | first 1000)

  mut square_group = []
  mut vertical_group = []
  mut horizontal_group = []

  mut groups = []

  for $image in $images {
    let size = image-size $image

    if ($size.width == $size.height) {
      $square_group = ($square_group | append $image)
    }
    if ($size.width < $size.height) {
      $vertical_group = ($vertical_group | append $image)
    }
    if ($size.width > $size.height) {
      $horizontal_group = ($horizontal_group | append $image)
    }

    if ($square_group | length) == 2 {
      $groups = ($groups | append [$square_group])
      $square_group = []
    }
    if ($vertical_group | length) == 3 {
      $groups = ($groups | append [$vertical_group])
      $vertical_group = []
    }
    if ($horizontal_group | length) == 2 {
      $groups = ($groups | append [$horizontal_group])
      $horizontal_group = []
    }
  }

  $groups
}

export def image-group-v1 [images: list] {
  # let images = (fd -e png -e jpg -e jpeg | lines | first 1000)

  mut group_a = []
  mut group_b = []
  mut group_c = []
  mut group_d = []
  mut group_e = []
  mut group_f = []
  mut group_g = []

  mut groups = []

  for $image in $images {
    let size = image-size $image
    let ratio = ($size.width / $size.height)

    if $ratio < 0.5 {
      $group_a = ($group_a | append $image)
    } else if $ratio < 0.75 {
      $group_b = ($group_b | append $image)
    } else if $ratio < 1 {
      $group_c = ($group_c | append $image)
    } else if $ratio < 1.25 {
      $group_d = ($group_d | append $image)
    } else if $ratio < 1.5 {
      $group_e = ($group_e | append $image)
    } else if $ratio < 1.75 {
      $group_f = ($group_f | append $image)
    } else {
      $group_g = ($group_g | append $image)
    }

    if ($group_a | length) == 4 {
      $groups = ($groups | append [$group_a])
      $group_a = []
    }
    if ($group_b | length) == 3 {
      $groups = ($groups | append [$group_b])
      $group_b = []
    }
    if ($group_c | length) == 3 {
      $groups = ($groups | append [$group_c])
      $group_c = []
    }
    if ($group_d | length) == 2 {
      $groups = ($groups | append [$group_d])
      $group_d = []
    }
    if ($group_e | length) == 2 {
      $groups = ($groups | append [$group_e])
      $group_e = []
    }
    if ($group_f | length) == 2 {
      $groups = ($groups | append [$group_f])
      $group_f = []
    }
    if ($group_g | length) == 1 {
      $groups = ($groups | append [$group_g])
      $group_g = []
    }
  }

  $groups
}

export def slide [
  --search(-s): string = "."
  --max-depth(-m): int = 1
  --sleep(-s): duration = 1sec
  --dir(-d): path = "."
  --reset(-r)
] {
  let state_path = ($nu.temp-path | path join "preview_slide_state.txt")

  mut skip = if ($state_path | path exists) {
    open $state_path | into int
  } else if $reset or not ($state_path | path exists) {
    0
  }

  let images = (fd -e png -e jpg -e jpeg -e svg -d $max_depth $search $dir | lines | skip $skip)

  for group in (image-group-v1 $images) {
    let length = ($group | length)
    timg --title --grid $length --fit-width --upscale=i --center ...($group) # -g 200x100

    $skip = $skip + $length
    $skip | save --force $state_path
    sleep $sleep
  }

  0 | save --force $state_path
}
