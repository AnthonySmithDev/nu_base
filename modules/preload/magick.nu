
const rt = {
  preview: {
    max_width: 600
    max_height: 900
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
  let cache = $"/tmp/preload_image_($file | hash md5).jpg"
  if ($cache | path exists) {
    return $cache
  }

  mut cmd_args = with_limit
  if $flatten {
    $cmd_args = ($cmd_args | append "-flatten")
  }

  $cmd_args = ($cmd_args | append [
    $file, "-auto-orient", "-strip",
    "-sample", $"($rt.preview.max_width)x($rt.preview.max_height)>",
    "-quality", $rt.preview.image_quality,
    $"JPG:($cache)"
  ])

  let output = (run-external magick ...$cmd_args | complete)
    if $output.exit_code != 0 {
    return $"Failed to start `magick`, error: ($output.stderr)"
  }

  return $cache
}
