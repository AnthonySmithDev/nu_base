
const rt = {
  preview: {
    max_width: 800
    max_height: 1200
    image_quality: 75
  }
  tasks: {
    image_alloc: 0
    image_bound: [0, 0]
  }
}

export def with_limit [] {
  mut cmd_args = ["-limit", "thread", "1"]
  if $rt.tasks.image_alloc > 0 {
    $cmd_args = ($cmd_args | append ["-limit", "memory", $rt.tasks.image_alloc, "-limit", "disk", "1MiB"])
  }
  if ($rt.tasks.image_bound | get 0) > 0 {
    $cmd_args = ($cmd_args | append ["-limit", "width", ($rt.tasks.image_bound | get 0)])
  }
  if ($rt.tasks.image_bound | get 1) > 0 {
    $cmd_args = ($cmd_args | append ["-limit", "height", ($rt.tasks.image_bound | get 1)])
  }
  return $cmd_args
}

export def preload [file: string, flatten: bool = false] {
  let mimetype = (file --mime-type $file | str replace $"($file): " "" | str trim)
  if not ($mimetype | str starts-with "image/") {
    error make -u { msg: $"File is not an image file. Mimetype: ($mimetype)" }
  }

  let cache_dir = "/tmp/preload/image"
  if not ($cache_dir | path exists) {
    mkdir $cache_dir
  }

  let cache_file = ($cache_dir | path join $"($file | hash md5).jpg")
  if ($cache_file | path exists) {
    return $cache_file
  }

  mut cmd_args = with_limit
  if $flatten {
    $cmd_args = ($cmd_args | append "-flatten")
  }

  $cmd_args = ($cmd_args | append [ $file, "-auto-orient", "-strip" ])
  if (du $file | first | get apparent) > 2mb {
    $cmd_args = ($cmd_args | append [
      # "-sample", $"($rt.preview.max_width)x($rt.preview.max_height)>",
      "-quality", $rt.preview.image_quality,
    ])
  }
  $cmd_args = ($cmd_args | append [ $"JPG:($cache_file)" ])


  let output = (run-external magick ...$cmd_args | complete)
  if $output.exit_code != 0 {
    error make -u { msg: $"Failed to start `magick`, error: ($output.stderr)" }
  }

  return $cache_file
}

const svg_icon = '<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="60" height="60" rx="30" fill="#000000" fill-opacity="0.6"/>
<path d="M24 18L42 30L24 42V18Z" fill="#ffffff"/></svg>'

def path_play_icon [] {
  let svg_path = $"/tmp/play_icon.svg"
  if not ($svg_path | path exists) {
    $svg_icon | save --force $svg_path
  }
  return $svg_path
}

export def add_play_icon [image: string] {
  let svg_icon = path_play_icon

  let cmd_args = [
    $svg_icon, "-background", "none",
    $image, "+swap",
    "-gravity", "southeast", "-composite",
    $image
  ]
 
  let output = (run-external magick ...$cmd_args | complete)
  if $output.exit_code != 0 {
    error make -u { msg: $"Failed to add play icon: ($output.stderr)" }
  }
  
  return $image
}
